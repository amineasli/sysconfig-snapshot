sysconfig-snapshot
====================

Performs a series of commands to take a snapshot of the state of your Linux machine. Among things to consider for this system configuration snapshot include : mounted filesystems, running processes, network stats, hardware configurations, to name a few.
With such information captured you have a better chance of fixing system problems quickly and reducing down time.

## Install
One line install (you must run this command as root) :

    # curl https://raw.githubusercontent.com/AmineAsli/sysconfig-snapshot/master/sysconfig-snapshot -o \
    /usr/local/sbin/sysconfig-snapshot && chmod +x /usr/local/sbin/sysconfig-snapshot

## Usage

    # sysconfig-snapshot [--output file] [--compress] [--help] [--version]

## Examples
Take a snapshot of the system. The resulting text file will be located in the /var/log/sysconfig-snapshot directory : 

    # sysconfig-snapshot

Compressing the default snapshot file :

    # sysconfig-snapshot --compress

You can also save the snapshot in a different text file :

    # sysconfig-snapshot --output myreport

Same result but in compressed format :

    # sysconfig-snapshot --compress --output myreport

## License
GNU GPL v2.0, see LICENSE.

