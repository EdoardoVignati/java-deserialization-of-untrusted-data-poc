#!/bin/bash

getAncestorPid() {
	local pid=$1
	local parentToFind=$2

	ps -o ppid=,pid=,comm= $pid | while read -r ppid pid comm; do
		case "$comm" in
			"$parentToFind"|*/"$parentToFind")
				echo $pid
				;;
			*)
				getAncestorPid $ppid $parentToFind
				;;
		esac
	done
}

#ideally, we'd use %I here, but it's non-standard
commitId=$(getAncestorPid $PPID cvs)

# all "last directory" tokens are stored in the same directory
mkdir -p /tmp/commit-tokens

# Assume the given directory is the last one, overwritting any existing data.
echo $1 > /tmp/commit-tokens/cvs.$commitId.pid
exit 0
