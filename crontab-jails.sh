#!/usr/local/bin/bash
# modified for freenas from https://gist.github.com/takeshixx/7487381
SHELL=/usr/local/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/root/bin
JAIL_PORTS=/mnt/jails/ports
SECTION=' * * * * * * '
DELIMITER='------------------------------'

#updates shared ports dir that is null mounted into each jail
#portsnap -p $JAIL_PORTS fetch extract &>/dev/null || echo "Updating ports tree failed!"

# if you don't have a shared ports mount, then use this.
# this will take a long time to run for each jail.
for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    jexec $JID portsnap -p $JAIL_PORTS fetch extract &>/dev/null || echo "Updating ports tree failed for jail ${jail}!"
done

echo "# VULNERABILITIES"
echo

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jexec $JID portsnap -p $JAIL_PORTS fetch extract &>/dev/null
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "--- ${jail} ---"
    jexec $JID pkg audit
    echo $DELIMITER
done

echo
echo $SECTION
echo

echo "# AVAILABLE UPDATES"
echo

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "--- ${jail} ---"
    jexec $JID portmaster -L --index-only| egrep '(ew|ort) version|total install'
    echo $DELIMITER
    echo
done
