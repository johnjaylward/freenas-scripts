#!/usr/local/bin/bash
# modified for freenas from https://gist.github.com/takeshixx/7487381
SHELL=/usr/local/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/root/bin
JAIL_PORTS=/mnt/jails/ports
DELIMITER='------------------------------'

echo "# VULNERABILITIES"
echo

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jexec $JID portsnap -p $JAIL_PORTS fetch extract &>/dev/null
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "--- ${jail} ---"
    jexec $JID pkg audit
    echo $DELIMITER
done
