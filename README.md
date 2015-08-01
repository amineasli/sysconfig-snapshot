sysconfig-snapshot
====================

Performs a series of commands to take a snapshot of the state of your Linux machine. Among things to consider for this system configuration snapshot include : mounted filesystems, running processes, network stats, hardware configurations, to name a few.
With such information captured you have a better chance of fixing system problems quickly and reducing down time.

## Install
One line install (you must run this command as root) :

    # curl https://raw.githubusercontent.com/AmineAsli/sysconfig-snapshot/master/sysconfig-snapshot -o \
    /usr/local/sbin/sysconfig-snapshot && chmod +x /usr/local/sbin/sysconfig-snapshot

## Usage

    # sysconfig-snapshot [--output file] [--verbose] [--help] [--version]

## Examples
Take a snapshot of the system. The file will be located in the home directory : 

    # sysconfig-snapshot

Same result but in verbose mode :

    # sysconfig-snapshot --verbose

You can also save the snapshot in a different file :

    # sysconfig-snapshot --output myreport

## License
GNU GPL v2.0, see LICENSE.

