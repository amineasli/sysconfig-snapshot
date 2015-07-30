#!/bin/bash - 
#
# Platform : Linux
#
# Purpose : Capture the state of the system configuration for later
# troubleshooting in the event of system problems. The given data will be stored
# in the file defined in $SYSCONFIGFILE variable.
#
# Usage :
#       sysconfig-snapshot.sh [--output file] [--verbose] [--help] [--version] 
#                                       

#Variables definition

PROGRAM=$(basename $0) 
VERSION=0.1 
VERBOSE=false
CURRENTHOST=$(hostname) 
DATETIME=$(date +%m%d%y_%H%M%S) 
SYSCONFIGFILE=snapshot.$CURRENTHOST.$DATETIME

#Functions definition 

error() 
{
   echo "$@" 1>&2 usage_and_exit 1 
}

usage() 
{  
   echo "Usage: $PROGRAM [--output file] [--verbose] [--help] [--version]"
         
}

usage_and_exit() 
{ 
   usage exit $1 
}

version() 
{ 
   echo "$PROGRAM version $VERSION" 
}

get_os() 
{ 
   uname -rs 
}

get_distro()
{
   cat /etc/*-release | 
     grep PRETTY |
        cut -d = -f 2 |
           tr -d '"'
}

get_arch()
{
   uname -m
}
get_timezone() 
{ 
   date +'%z %Z' 
}

get_cpu_info() 
{ 
   lscpu 
}

get_real_mem() 
{ 
   free -h | 
      grep Mem |
         awk 
            '{ printf("Total : %s\nUsed : %s\nFree: %s\n", $2,$3, $4)}' 
}

get_swap() 
{ 
   free -h | 
      grep Swap |
         awk 
            '{ printf("Total : %s\nUsed : %s\nFree: %s\n", $2,$3, $4)}' 
}

get_bios_hw_info() 
{ 
   dmidecode -q 
}

get_pci_list() 
{ 
   lspci -m 
}

get_long_dev_list()
{
   ls -l /dev
}

get_block_dev_list()
{
   lsblk -i
}

get_partition_table()
{
   fdisk -l
}

get_fs_stats()
{
   df -k 
   echo -e "\n"
   mount
}

get_list_ifaces()
{
   ifconfig -n
}

get_route_table()
{
   route -n
}

get_ps_list()
{
   ps aux
}

#Report generator function

generate_report()
{
   echo -e "\n\n $PROGRAM ($VERSION) - $DATETIME \n\n"
   echo -e "System-configuration snapshot for $CURRENTHOST\n"
   echo -e "\n###############################################################\n"
   echo    "GENERAL INFO:"
   echo -e "\n###############################################################\n"
   echo -e "Hostname:\t\t$CURRENTHOST"
   echo -e "Time Zone:\t\t$(get_timezone)"
   echo -e "Machine Architecture:\t$(get_arch)"
   echo -e "Operating System:\t$(get_os)"
   echo -e "Distribution:\t\t$(get_distro)"
}

#Command-line argument parser

while test $# -gt 0 
do 
   case $1 in 
   --output | -o )
      shift
      SYSCONFIGFILE=$1 
      ;;
   --verbose | -v )
      shift
      VERBOSE=true 
      ;;
   --help | -h ) 
      shift
      usage_and_exit 0 
      ;;
   --version | -V ) 
      shift
      version exit 0 
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

#Main section

if [ $(uname -s) != 'Linux' ]
then 
   echo -e "\n Error : This shell script is written exculsively for Linux OS.\n"
   exit 1
fi

if [ "$VERBOSE" = true ] 
then
   generate_report | tee -a $SYSCONFIGFILE  
else
   generate_report > $SYSCONFIGFILE 2> /dev/null 
fi
