wifi
====
wifi is a secure wifi network manager designed for OpenBSD.

## Features
* Connect to a list of registered access points
* Add or delete access points
* List all registered access points
* Scan for available access points
* Password encryption via GnuPG

## Requirements
 * python 3.4: https://www.python.org/
 * docopt: http://docopt.org/
 * python-gnupg: https://pypi.python.org/pypi/gnupg/
 * requests: https://pypi.python.org/pypi/requests

## Installation
First, you have to create the necessary folders, database file and generate the GnuPG key (default: _~/.wifi_). Hopefully, everything is done automatically:

```sh
$ wifi --init
Directory structure: done
Database: done
Master password:
Retype password:
GnuPG: done
```

## Usage
```sh
$ wifi --help
Manage Wifi access points.

Usage:
  wifi --add <alias> <nwid> [(<ip> <netmask> <gateway> <dns>)]
  wifi --delete <alias>
  wifi --connect <alias>
  wifi --list
  wifi --scan
  wifi --init
  wifi --help
  wifi --version

Options:
  -h --help      Show this screen.
  -v --version   Show version.
  -i --init      Initialize required files.
  -a --add       Add an access point.
  -d --delete    Delete ean access point.
  -c --connect   Connect to an access point.
  -l --list      List available access points.
  -s --scan      Show the results of an access point scan.
```

### Flow
```sh
$ wifi --add ACCESS_POINT1
Password:
Access point ACCESS_POINT1 addedd successfully

$ wifi --add ACCESS_POINT2 10.0.0.5 255.255.255.0 10.0.0.1 8.8.8.8
Password:
Access point ACCESS_POINT2 added successfully

$ wifi --list
1) ACCESS_POINT1
2) ACCESS_POINT2

$ sudo wifi --connect ACCESS_POINT1
Master password:
Connected to ACCESS_POINT1

$ wifi --delete ACCESS_POINT1
Access point ACCESS_POINT1 deleted sucessfully

$ sudo wifi --scan
1) Bbox-A90014 (187dB)
2) Bbox-73F0F28C (171dB)
3) SFR_AE80 (168dB)
4) freebox_LEATI (168dB)
5) Adrience (189dB)
```

## Additional notes
Access points config informations are stored in a json file located in 
_~/.wifi/access_points.json_ while their encrypted password is saved in 
a standalone file conventionally named _~/.wifi/passwords/\<ALIAS\>.gpg_.

Thanks to my friend Tamentis for his help on this project.
