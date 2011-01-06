#!/bin/sh
for host in `avahi-browse -rt \
_pdl-datastream._tcp | grep address | \
sed -e 's:^.*\[\(.*\)\]:\1:g'`
do echo "@PJL RDYMSG DISPLAY=\"$*\"" | \
nc -q5 $host 9100
done
