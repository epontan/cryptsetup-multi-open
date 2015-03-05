cryptsetup-multi-open
=====================

cryptsetup-multi-open is a simple (yet secure) utility to open/unlock multiple
encrypted disks that all share the same secret passphrase. This is to avoid
having to input the same passphrase multiple times.

The reason for not using a keyfile instead would for example be if the root
partition is not encrypted or having it available in the system at all times
is not desired.

The utility is implemented in C in order to have better control of the memory
management for the program. We can cleanup the memory area where the passphrase
is temporarily stored while opening up all the devices.


Usage
-----

```
usage: cryptsetup-multi-open <device> <name> [<device> <name>] ...

# cryptsetup-multi-open /dev/sdb1 disk0 /dev/sdc1 disk1
Passphrase: 
Opening device disk0 ... OK
Opening device disk1 ... OK
```


Examples
--------

See the examples directory in the source tree for example scripts using this
utility.


Issues / feedback
-----------------

Write in github issue tracker if you find a bug or want to propose an
improvement. Better yet, why don't you fork and create a pull request? :)

