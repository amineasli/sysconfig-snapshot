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
SYSCONFIGFILE=$HOME/snapshot.$CURRENTHOST.$DATETIME

#Functions definition 

error() 
{
   echo "$@" 1>&2 
   usage_and_exit 1 
}

usage() 
{  
   echo "Usage: $PROGRAM [--output file] [--verbose] [--help] [--version]"
         
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
         awk \
            '{ printf("Total : %s\nUsed : %s\nFree: %s\n", $2,$3, $4)}' 
}

get_swap() 
{ 
   free -h | 
      grep Swap |
         awk \
            '{ printf("Total : %s\nUsed : %s\nFree: %s\n", $2,$3, $4)}' 
}

get_dmi_table() 
{ 
   dmidecode -q 
}

get_pci_list() 
{ 
   lspci -v 
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

get_ifaces_list()
{
   ifconfig -s
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
   echo -e "\n\n $PROGRAM ($VERSION) - $(date) \n\n"
   echo -e "\n###############################################################\n"
   echo -e "\tGENERAL:"
   echo -e "\n###############################################################\n"
   echo -e "#Hostname:\t\t$CURRENTHOST"
   echo -e "#Time Zone:\t\t$(get_timezone)"
   echo -e "#Machine Architecture:\t$(get_arch)"
   echo -e "#Operating System:\t$(get_os)"
   echo -e "#Distribution:\t\t$(get_distro)"
   echo -e "\n###############################################################\n"
   echo -e "\tHARDWARE:"
   echo -e "\n###############################################################\n"
   echo -e "#CPU:\n\n$(get_cpu_info)\n" 
   echo -e "#Physical Memory:\n\n$(get_real_mem)\n" 
   echo -e "#Swap Memory:\n\n$(get_swap)\n" 
   echo -e "#DMI table:\n\n$(get_dmi_table)\n" 
   echo -e "#PCI devices list:\n\n$(get_pci_list)\n" 
   echo -e "#Device directory list - /dev:\n\n$(get_long_dev_list)\n" 
   echo -e "\n###############################################################\n"
   echo -e "\tFILE SYSTEM:"
   echo -e "\n###############################################################\n"
   echo -e "#Block devices list:\n\n$(get_block_dev_list)\n" 
   echo -e "#Partition table:\n$(get_partition_table)\n" 
   echo -e "#File system stats:\n\n$(get_fs_stats)\n" 
   echo -e "\n###############################################################\n"
   echo -e "\tNETWORKING:"
   echo -e "\n###############################################################\n"
   echo -e "#Interfaces list:\n\n$(get_ifaces_list)\n" 
   echo -e "#IP routing table:\n\n$(get_route_table)\n" 
   echo -e "\n###############################################################\n"
   echo -e "\tPROCESSES:"
   echo -e "\n###############################################################\n"
   echo -e "#Process list:\n\n$(get_ps_list)\n" 
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
      VERBOSE=true 
      ;;
   --help | -h ) 
      usage_and_exit 0 
      ;;
   --version | -V ) 
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

#Main section

if [ $(uname -s) != 'Linux' ]
then 
   echo -e "\n Error : This shell script is written exculsively for Linux OS.\n"
   exit 1
fi

if [ $VERBOSE = true ] 
then
   generate_report | tee -a $SYSCONFIGFILE  
else
   generate_report > $SYSCONFIGFILE 2> /dev/null 
fi

if [ -e $SYSCONFIGFILE ]
then
   echo -e "\n A snapshot of your system configuration has been successfully \
saved in :\n\"$SYSCONFIGFILE\"" 
fi
