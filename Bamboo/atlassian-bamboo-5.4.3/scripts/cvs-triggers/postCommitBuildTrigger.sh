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

while read -r line; do
    # filter program must read all of the log information from its standard input or CVS may fail with a broken pipe signal
    echo $line
done

#
# Which directory are we processing in this post-commit trigger?
#

if [ -e $1 ]; then
    currentdir=$1
else
    # backward compatibility, not 100% correct
    currentdir=$CVSROOT/$1
fi

#
# Get the file containing the last directory processed by the
# pre-commit trigger
#
#ideally, we'd use %I here, but it's non-standard
commitId=$(getAncestorPid $PPID cvs)
lastDirFile=/tmp/commit-tokens/cvs.$commitId.pid

#
# Ensure we have the file, or report an  error
#
if [ -f $lastDirFile ]; then

    #
    # Are we processing the last directory in the commit?
    #
    lastdir=`cat $lastDirFile`
    if [ "$lastdir" == "$currentdir" ]; then

       #
       # Use the REST API to trigger a build
       #
       baseurl=$2/updateAndBuild.action?buildKey=

       # Moves to the 3rd param (first is CVSROOT, second is URL)
       shift
       shift
       # Loop for each build key
       while (( "$#" )); do

           #
           # Invoke the trigger
           #
           remoteCall=$baseurl$1
           echo "Detected last directory that was committed ... triggering $remoteCall"
           /usr/bin/wget --timeout=10 -t1 $remoteCall -O /dev/null
           shift

           # If param starts with http then change the baseurl
           if [ `/usr/bin/expr "$1" : http*` -gt 0 ]; then
              baseurl=$1/updateAndBuild.action?buildKey=
              shift
           fi
       done

       #
       # Clean up temp file
       #
       rm $lastDirFile
    fi
else
    echo "****************************************"
    echo
    echo
    echo "Commit completed, but the post commit trigger could not read $lastDirFile - the build will NOT be triggered. You can ignore this message if you're only adding a directory."
    echo
    echo
    echo "****************************************"
fi
exit 0
