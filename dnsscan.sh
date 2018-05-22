#!/bin/sh -e

# Run this script on a named slave or master

ZONEDIR=/var/named/slaves
OUTPUT=totality.txt

[ ! -d zones ] && mkdir zones
[ -f $OUTPUT ] && rm $OUTPUT
if [ ! -d $ZONEDIR ]; then
    echo "Error: $ZONEDIR does not exist" >&2
    exit 1;
fi

find $ZONEDIR -type f -print | xargs -I% sh -c "echo %; if [ \"\$(./parse_bin.rb %)\" ]; then named-compilezone -f raw -F text -o zones/\$(basename %.txt) \$(./parse_bin.rb %) % ; fi ; echo"
for zonefile in zones/*; do ./parse_zone.rb $zonefile >> $OUTPUT; done

