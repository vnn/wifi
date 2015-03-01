wifi
====
wifi is a minimal and secure wifi network manager using gpg password encryption.

## FEATURES:
* Connect to a list of predefined networks
* Add or delete networks
* Password encryption via GnuPG
* Aliases (for quick use)
* ipv6 (coming soon)
* scan for available ap (coming soon)

##USAGE (see -h):
```sh
$ wifi add ACCESS_POINT
$ wifi add ACCESS_POINT 10.0.0.5 255.255.255.0 10.0.0.1
$ wifi list
$ sudo wifi connect ACCESS_POINT
$ sudo wifi connect 1 (alias)
$ wifi delete ACCESS_POINT
```

This script is a first draft/experiment around Python and it will be
certainly improved in a near future. Thanks to my friend Tamentis for
his input on this.
