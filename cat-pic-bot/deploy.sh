#!/usr/bin/env bash
now remove $1 -y
url=$(now --public -e TOKEN=$2 | grep -o "[0-9a-zA-Z.-]*\.now\.sh")
now alias
now scale $url sfo1 1