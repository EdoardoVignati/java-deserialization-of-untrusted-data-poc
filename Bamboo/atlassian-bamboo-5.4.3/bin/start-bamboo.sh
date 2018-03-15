# resolve links - $0 may be a softlink - stolen from catalina.sh
PRG="$0"
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=`dirname "$PRG"`
PRGBASE=`dirname "$PRGBASE"`
pushd $PRGBASE > /dev/null
PRGBASEABS=`pwd`
popd > /dev/null

PRGRUNMODE=false
if [ "$1" = "-fg" ] || [ "$1" = "run" ]  ; then
	shift
	PRGRUNMODE=true
else
	echo ""
	echo "To run Bamboo in the foreground, start the server with start-bamboo.sh -fg"
fi

echo ""
echo "Server startup logs are located in $PRGBASEABS/logs/catalina.out"
if [ "$PRGRUNMODE" = "true" ] ; then
    exec $PRGDIR/catalina.sh run $@
else
   exec $PRGDIR/startup.sh $@

fi
