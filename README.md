wifi
====
wifi is a minimal and secure wifi network manager using GnuPG for password encryption.

## Requirements
 * python 3.4: https://www.python.org/
 * python-gnupg: https://pypi.python.org/pypi/gnupg/
 * requests: https://pypi.python.org/pypi/requests

## Features
* Connect to a list of predefined networks
* Add or delete networks
* List available networks
* Password encryption via GnuPG
* Aliases (for quick use)
* Scan for available AP (coming soon)

## Usage
First, you have to init all the necessary stuff (folders, database file, GnuPG key) using the _init_ argument.
```sh
$ wifi -h
usage: wifi [-h] [-v] {add,connect,delete,init,list} ...

$ wifi init
Directory structure: done
Database: done
Master password:
Retype password:
GnuPG: done

$ wifi add ACCESS_POINT1
Password:
Access point ACCESS_POINT1 addedd successfully

$ wifi add ACCESS_POINT2 10.0.0.5 255.255.255.0 10.0.0.1
Password:
Access point ACCESS_POINT2 addedd successfully

$ wifi list
1) ACCESS_POINT1
2) ACCESS_POINT2

$ sudo wifi connect ACCESS_POINT1
Master password:
Connected to ACCESS_POINT1

$ sudo wifi connect 2
Master password:
Connected to ACCESS_POINT2

$ wifi delete ACCESS_POINT1
Access point ACCESS_POINT1 deleted sucessfully
```

## Note
This script was intended to be used on an OpenBSD laptop, connecting
to ipv4 networks. That being said, it should work on several unix systems
as well as ipv6 networks with a few efforts. Thanks to my friend Tamentis
for his help on this projects.
