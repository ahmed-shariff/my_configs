# from: https://github.com/free-easy/auto-rclone/blob/master/auto-rclone
#################################
# Common section
#################################

# Name of this script
readonly PROGRAM_NAME="auto-rclone"
# Path to the config file to this script
readonly CONFIG_FILE_PATH="$HOME/.config/auto-rclone/remotes.conf"
# List of rclone remotes
readonly RCLONE_REMOTES=( $(rclone listremotes) )
# 1 minute as default local directory inactivity timeout 
readonly DEFAULT_INACTIVITY_TIMEOUT=60
# each 15 minutes as default pull frequency
readonly DEFAULT_PULL_FREQUENCY=900

##
# Given a rclone remote, get the path to its lock file
#
# Globals:
#	None
# Arguments:
#	remote_name: name of the remote (NOTE: validity is not checked)
# Returns:
# 	path to lock file (though its existence is not guaranteed)
#   
auto_rclone_get_lock_file_path() {
	echo "/tmp/${PROGRAM_NAME}_$1.lock"
}

##
# Given a rclone remote, put a lock (i.e. create a lock file)
#
# Globals:
#	None
# Arguments:
#	remote_name: name of the remote (NOTE: validity is not checked)
# Returns:
# 	None
#   
auto_rclone_acquire_lock() {
	touch $(auto_rclone_get_lock_file_path $1)
}

##
# Given a rclone remote, free its lock
#
# Globals:
#	None
# Arguments:
#	remote_name: name of the remote (NOTE: validity is not checked)
# Returns:
# 	None
#   
auto_rclone_free_lock() {
	rm -f $(auto_rclone_get_lock_file_path $1)
}

##
# Given a rclone remote, wait until its lock is freed
#
# Globals:
#	None
# Arguments:
#	remote_name: name of the remote (NOTE: validity is not checked)
# Returns:
# 	None
#   
auto_rclone_wait_lock_freed() {
	inotifywait -e delete $(auto_rclone_get_lock_file_path $1)
}

##
# Given a rclone remote, check whether it's locked
#
# Globals:
#	None
# Arguments:
#	remote_name: name of the remote (NOTE: validity is not checked)
# Returns:
# 	0 if locked
# 	1 if not locked
#   
auto_rclone_is_locked() {
	[[ -f $(auto_rclone_get_lock_file_path $1) ]] && { return 0; } || { return 1; }
}

##
# Output to desktop a fatal message
#
# Globals:
#	None
# Arguments:
#	message
# Returns:
#	None
#
auto_rclone_message_fatal() {
	notify-send -u critical -c im.error "$PROGRAM_NAME fatal:" "$1"
}

##
# Output to desktop a warning message
#
# Globals:
#	None
# Arguments:
#	message
# Returns:
#	None
#
auto_rclone_message_warning() {
	notify-send -t 3000 -u critical -c im.error "$PROGRAM_NAME warning:" "$1"
}

##
# Output to desktop a notify message
#
# Globals:
#	None
# Arguments:
#	message
# Returns:
#	None
#
auto_rclone_message_notify() {
	notify-send -t 2000 -u normal -c im "$PROGRAM_NAME notify:"  "$1"
}


#################################
# Push section
#################################

##
# Push changes to remote.
# Create a lock file that will be removed at the end of this function
# If lock file already exists, wait until it's deleted and then retry
#
# Globals:
#	None
# Arguments:
#	rclone_remote: name of the rclone's remote you want push changes to
#	local_directory: local directory corresponding to the given remote
# Returns:
#	None
#
auto_rclone_push_changes()
{
	local rclone_remote="$1"
	local local_directory="$2"
	if ! auto_rclone_is_locked "$rclone_remote"; then
		echo "Pushing changes from $local_directory to $rclone_remote"
		auto_rclone_acquire_lock "$rclone_remote"

		local output=$(rclone sync --stats-log-level NOTICE "${local_directory}" "${rclone_remote}" 2>&1 | grep -E 'Errors|Transferred')

		local transferred_size=${output#'Transferred:'*}
		transferred_size=${transferred_size%%'Bytes'*}
		local errors=${output#*'Errors:'}
		errors=${errors%T*}
		local transferred_files=${output##*'Transferred:'}

		auto_rclone_free_lock "$rclone_remote"

		auto_rclone_message_notify "Changes pushed to ${rclone_remote}: \
			Files: ${transferred_files} \
			Bytes: ${transferred_size} \
			Errors: ${errors}"
	else
		echo "$0"
		auto_rclone_wait_lock_freed "$rclone_remote"
		auto_rclone_push_changes "$rclone_remote" "$local_directory"
	fi
}

##
# Given a remote and it's corresponding directory in the filesystem,
# watch for changes (create, delete, modify, move) in that directory.
# When some change happens, if within INACTIVITY_TIMEOUT no other changes
# happened, push changes to remote
#
# Globals:
#	None
# Arguments:
#	rclone_remote: name of the given rclone's remote
#	local_directory: local directory corresponding to the given remote
#	inactivity_timeout: time of $local_directory inactivity to wait before pushing changes
# Returns:
#	None
#
auto_rclone_register_push()
{
	local rclone_remote="$1"
	local local_directory="$2"
	local inactivity_timeout="$3"
	while inotifywait -e create,delete,modify,move "$local_directory"; do
		while true; do
			timeout "${inactivity_timeout}s" inotifywait -e create,delete,modify,move "$local_directory"
			# timeout exits with 124 when time has expired
			if [[ $? -eq 124 ]]; then
				break
			fi
		done
		auto_rclone_push_changes "$rclone_remote" "$local_directory" &
	done 
}

#################################
# Pull section
#################################

##
# Pull changes from remote.
# Create a lock file that will be removed at the end of this function
# If lock file already exists, wait until it's deleted and then retry
#
# Globals:
#	None
# Arguments:
#	rclone_remote: name of the rclone's remote you want push changes to
#	local_directory: local directory corresponding to the given remote
# Returns:
#	None
#
auto_rclone_pull_changes()
{
	local rclone_remote="$1"
	local local_directory="$2"
	if ! auto_rclone_is_locked "$rclone_remote"; then
		echo "Pulling changes from $rclone_remote to $local_directory"
		auto_rclone_acquire_lock "$rclone_remote"

		local output=$(rclone sync --stats-log-level NOTICE "${rclone_remote}" "${local_directory}" 2>&1 | grep -E 'Errors|Transferred')

		local transferred_size=${output#'Transferred:'*}
		transferred_size=${transferred_size%%'Bytes'*}
		local errors=${output#*'Errors:'}
		errors=${errors%T*}
		local transferred_files=${output##*'Transferred:'}

		auto_rclone_free_lock "$rclone_remote"

		auto_rclone_message_notify "Changes pulled from ${rclone_remote}: \
			Files: ${transferred_files} \
			Bytes: ${transferred_size} \
			Errors: ${errors}"
	else
		auto_rclone_wait_lock_freed "$rclone_remote"
		auto_rclone_pull_changes "$rclone_remote" "$local_directory"
	fi
}

##
# Given a remote and it's corresponding directory in the filesystem,
# watch for changes (create, delete, modify, move) in that directory.
# When some change happens, if within INACTIVITY_TIMEOUT no other changes
# happened, push changes to remote
#
# Globals:
#	None
# Arguments:
#	rclone_remote: name of the given rclone's remote
#	local_directory: directory corresponding to the given remote
#	pull_frequency: time to wait between each pull 
# Returns:
#	None
#
auto_rclone_register_pull()
{
	local rclone_remote="$1"
	local local_directory="$2"
	local pull_frequency="$3"
	while true; do
		auto_rclone_pull_changes "$rclone_remote" "$local_directory"
		sleep "${pull_frequency}s"
	done 
}

#################################
# Main section
################################

##
# Check availability of programs needed by auto-rclone
# If not all the programs are available, this function will
# stop the script and exit with 1, after sending a proper error message 
# (when possible, i.e. if the program to send message is available)
# 
# Globals:
#	None
# Arguments:
#	None
# Returns:
#	None
#
auto_rclone_check_dependent_programs() {
	readonly local dependencies=( rclone envsubst timeout inotifywait notify-send )
	for program in "${dependencies[@]}"; do
		if [[ ! -x "$(command -v $program)" ]]; then
			if [[ "$program" != "notify-send" ]]; then
				auto_rclone_message_fatal "\"$program\" not available: please install it"
			fi
			exit 1
		fi
	done
}

##
# Check validity of the arguments of this script
#
# Globals:
#	RCLONE_REMOTES: list of rclone remotes
# Arguments:
#	rclone_remote: name of a rclone's remote
#	local_directory: local directory corresponding to the given remote
#	inactivity_timeout: time of $local_directory inactivity to wait before pushing changes
#	pull_frequency: time to wait between each pull
# Returns:
# 	0 if parameters are acceptable
# 	1 if not acceptable
#
auto_rclone_check_parameters()
{
	local rclone_remote="$1"
	local local_directory="$2"
	local inactivity_timeout="$3"
	local pull_frequency="$4"
	while true; do
		for remote in "${RCLONE_REMOTES[@]}"; do
			if [[ "$rclone_remote" == "$remote" ]]; then
				break 2
			fi
		done
		auto_rclone_message_fatal "\"$rclone_remote\" is not a rclone's remote"
		return 1
	done

	# check whether given local_directory is a valid directory
	if [[ ! -d "$local_directory" ]]; then
		auto_rclone_message_fatal "\"$local_directory\" doesn't exist as directory"
		return 1
	fi
	# check whether inactivity_timeout is valid
	if [[ ! "$inactivity_timeout" =~ ^[0-9]+$ ]]; then
		auto_rclone_message_fatal "Invalid inactivity_timeout value \"$inactivity_timeout\": using default 60 seconds"
		return 1
	fi
	# check whether inactivity_timeout is valid
	if [[ ! "$pull_frequency" =~ ^[0-9]+$ ]]; then
		auto_rclone_message_fatal "Invalid pull_frequency value \"$pull_frequency\": using default 60 seconds"
		return 1
	fi

	return 0
}

##
# For each remote read from config file register a push and a pull activity,
# if the supplied parameters are acceptable
#
# Globals:
#	CONFIG_FILE_PATH: path to the config file
# Arguments:
#	None
# Returns:
#	None
#
main()
{
	auto_rclone_check_dependent_programs
	cat "$CONFIG_FILE_PATH" | envsubst | 
	while read rclone_remote local_directory inactivity_timeout pull_frequency; do
		# set default inactivity_timeout if not passed
		if [[ -z "${inactivity_timeout// }" ]]; then
			auto_rclone_message_warning "inactivity_timeout not passed: using default 60 seconds"
			inactivity_timeout=$DEFAULT_INACTIVITY_TIMEOUT
		fi
		# set default pull_frequency if not passed
		if [[ -z "${pull_frequency// }" ]]; then
			auto_rclone_message_warning "pull_frequency not passed: using default 15 minutes"
			pull_frequency=$DEFAULT_PULL_FREQUENCY
		fi

		if auto_rclone_check_parameters "$rclone_remote" "$local_directory" "$inactivity_timeout" "$pull_frequency"; then
			auto_rclone_register_pull "$remote" "$local_directory" "$pull_frequency" &
			auto_rclone_register_push "$remote" "$local_directory" "$inactivity_timeout" &
		fi
	done 
}

#main "$@"

dropbox_pull()
{
    auto_rclone_pull_changes "dropbox:org" "$HOME/Documents/org"
}

dropbox_push()
{
    auto_rclone_push_changes "$HOME/Documents/org" "dropbox:org"
}

rclone_pull_and_push()
{
    dropbox_pull
    dropbox_push
}
