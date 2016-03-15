#!/bin/bash

tmpdir=$(mktemp -d)

startDatetime=$(date -Iminutes)
python3 ../pywebgettext.py --from-code utf-8 \
                           --copyright-holder maillol \
                           --package-name xpyweb \
                           --package-version 1 \
                           --msgid-bugs-address maillol@xpyweb \
                           --sort-by-file \
                           sample/*
endDatetime=$(date -Iminutes)

grep -v 'POT-Creation-Date:' expected.po > $tmpdir/expected.po
grep -v 'POT-Creation-Date:' messages.po > $tmpdir/messages.po

msg_date=$(grep 'POT-Creation-Date:' messages.po | cut -d ' ' -f2)
msg_time=$(grep 'POT-Creation-Date:' messages.po | cut -d ' ' -f3)
msg_datetime="${msg_date}T${msg_time::-3}"


if [[ ! ($msg_datetime == $endDatetime || $msg_datetime == $startDatetime || 
      ($startDatetime < $msg_datetime && $msg_datetime < $endDatetime)) ]]; then
    echo "POT-Creation-Date: value must be between $startDatetime and $endDatetime"
    exit 1
fi

diff $tmpdir/expected.po $tmpdir/messages.po
if [[ $? != 0 ]]; then
    exit 1    
fi

rm -r $tmpdir
rm messages.po
