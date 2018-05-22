#!/bin/sh -e

# Run this script on a named slave or master

# If zones/ is a directory, and contains one or more files,
# then the script will _just_ parse the zone files to $OUTPUT.

# If zones/ is not a directory, or doesn't exist, the script
# will create it and populate it with zone files from $ZONEDIR.

ZONEDIR=/var/named/slaves
OUTPUT=totality.txt

NO_COLLECT=0

if [ -d zones ]; then
    if [ $(ls -1 zones/ | wc -l) -gt 0 ]; then
        NO_COLLECT=1
    fi
fi

if [ $NO_COLLECT -eq 0 ]; then
    if [ ! -d $ZONEDIR ]; then
        echo "Error: $ZONEDIR does not exist" >&2
        exit 1;
    fi
    mkdir zones
fi

[ -f $OUTPUT ] && rm $OUTPUT

[ $NO_COLLECT -eq 0 ] && find $ZONEDIR -type f -print | xargs -I% sh -c "echo %; if [ \"\$(./parse_bin.rb %)\" ]; then named-compilezone -f raw -F text -o zones/\$(basename %.txt) \$(./parse_bin.rb %) % ; fi ; echo"
for zonefile in zones/*; do ./parse_zone.rb $zonefile >> $OUTPUT; done

