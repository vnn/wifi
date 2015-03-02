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
Edit the script and replace 'iwn0' (line 45), with your wifi network interface. Then, use the *--init* argument to create necessary folders, json database and generate the GnuPG private key:

```sh
$ wifi --init
Directory structure: done
Database: done
Master password:
Retype password:
GnuPG: done
```
You're now ready to go.

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

Here is an overview of the flow:
```sh
$ wifi --add home ACCESS_POINT1
Password:
Done

$ wifi --add office ACCESS_POINT2 10.0.0.5 255.255.255.0 10.0.0.1 8.8.8.8
Password:
Done

$ wifi --list
1) home
2) office

$ sudo wifi --connect home
Master password:
Connected to ACCESS_POINT1

$ wifi --delete office
Done

$ sudo wifi --scan
1) Bbox-A90014 (187dB)
2) Bbox-73F0F28C (171dB)
3) SFR_AE80 (168dB)
4) freebox_LEATI (168dB)
5) Adrience (189dB)
```

## Additional notes
Access points config informations are stored in 
*access_points.json* while their encrypted password is written in 
a standalone file conventionally named *\<ALIAS\>.gpg*.

Thanks to my friend Tamentis for his help on this project.
