#!/bin/bash - 
#
# Platform : Linux
#
# Purpose : Capture the state of the system configuration for later troubleshooting in the event of system problems. The given data will be stored in the file defined in $SYSCONFIGFILE variable.
#
# Usage :
#         sysconfig-snapshot.sh 

PROGRAM=`basename $0`
VERSION=0.1

error()
{
   echo "$@" 1>&2
   usage_and_exit 1
}

usage()
{
   echo "Usage: $PROGRAM"
}

usage_and_exit()
{
   usage
   exit $1
}

version()
{
   echo "$PROGRAM version $VERSION"
}
