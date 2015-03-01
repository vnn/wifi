wifi
====
wifi is a minimal and secure wifi network manager using gpg password encryption.

## FEATURES:
* Connect to a list of predefined networks
* Add or delete networks
* Password encryption via GnuPG
* Aliases (for quick use)
* ipv6 (coming soon)
* scan for available AP (coming soon)

##USAGE (see -h):
```sh
$ wifi add ACCESS_POINT1
Network password:
Access point ACCESS_POINT1 addedd successfully

$ wifi add ACCESS_POINT2 10.0.0.5 255.255.255.0 10.0.0.1
Network password:
Access point ACCESS_POINT2 addedd successfully

$ wifi list
1) ACCESS_POINT1
2) ACCESS_POINT2

$ sudo wifi connect ACCESS_POINT1
Connected to ACCESS_POINT1

$ sudo wifi connect 2
Connected to ACCESS_POINT2

$ wifi delete ACCESS_POINT1
Access point ACCESS_POINT1 deleted sucessfully
```

This script is a first draft/experiment around Python and it will be
certainly improved in a near future. Thanks to my friend Tamentis for
his input on this.
