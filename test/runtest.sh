#!/bin/bash

if [[ ${0:0:1} == "/" ]]; then
    pypath=${0%/*}
else
    pypath=${PWD}/${0}
    pypath=${pypath%/*}
fi
export PYTHONPATH="${pypath}/.."


tmpdir=$(mktemp -d)

startDatetime=$(date -Iminutes)
python3 -m pywebgettext --from-code utf-8 \
                        --copyright-holder maillol \
                        --package-name xpyweb \
                        --package-version 1 \
                        --msgid-bugs-address maillol@xpyweb \
                        --sort-by-file \
                        sample/* 2> $tmpdir/warning
endDatetime=$(date -Iminutes)


expected_warning='Warning: File "sample/script-1.py", line 20'
grep -q "$expected_warning" $tmpdir/warning
warning_found=$?
if [[ $warning_found != 0 ]]; then
    echo 'Expected:' $expected_warning
    echo 'Got:     ' "$(cat $tmpdir/warning)"
    exit 1
fi

grep -v 'POT-Creation-Date:' expected.po > $tmpdir/expected.po
grep -v 'POT-Creation-Date:' messages.po > $tmpdir/messages.po

msg_date=$(grep 'POT-Creation-Date:' messages.po | cut -d ' ' -f2)
msg_time=$(grep 'POT-Creation-Date:' messages.po | cut -d ' ' -f3)
msg_datetime="${msg_date}T${msg_time::-3}"


if [[ ! ($msg_datetime == $endDatetime || $msg_datetime == $startDatetime || 
      ($startDatetime < $msg_datetime && $msg_datetime < $endDatetime)) ]]; then
    echo "POT-Creation-Date: value must be between $startDatetime and $endDatetime"
    cat $tmpdir/warning
    exit 1
fi

diff $tmpdir/expected.po $tmpdir/messages.po
if [[ $? != 0 ]]; then
    cat $tmpdir/warning
    exit 1    
fi

rm -r $tmpdir
rm messages.po
