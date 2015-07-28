#!/bin/bash - 
#
# Platform : Linux
#
# Purpose : Capture the state of the system configuration for later
# troubleshooting in the event of system problems. The given data will be stored
# in the file defined in $SYSCONFIGFILE variable.
#
# Usage :

#       sysconfig-snapshot.sh [--output file] [--verbose] [--quiet] [--help] \
#                             [--version]
                                


PROGRAM=$(basename $0)
VERSION=0.1
CURRENTHOST=$(hostname)
DATETIME=$(date +%m%d%y_%H%M%S)
SYSCONFIGFILE=sysconfig-snapshot.$CURRENTHOST.$DATETIME

error()
{
   echo "$@" 1>&2
   usage_and_exit 1
}

usage()
{
   echo "Usage: $PROGRAM [--output file] [--verbose] [--quiet] [--help] \
         [--version]"

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

get_os()
{
   uname -mrs
}

get_timezone()
{
   date +'%z %Z'
}

get_cpu_info()
{
   lspci
}

get_real_mem()
{
   free -h | grep Mem | awk '{ printf("Total : %s\nUsed : %s\nFree : %s\n"\
, $2, $3, $4)}'
}

get_sys_hw_info()
{
   dmidecode -q
}

get_pci_list()
{
   lspci -m
}

 
while test $# -gt 0 
do 
   case $1 in
   --output | -o )
     SYSCONFIGFILE=$1
     ;;
   --help | -h )
      usage_and_exit 0
      ;;
   --version | -v )
      version
      exit 0
      ;;
   -*) 
      error "Unrecognized option: $1"
      ;;
   *)
      break
      ;;
   esac
   shift
done


