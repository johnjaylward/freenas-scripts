#!/usr/local/bin/zsh
JAIL_PORTS=/usr/jails/ports
SECTION=' * * * * * * '
DELIMITER='------------------------------'

portsnap -p $JAIL_PORTS fetch extract &>/dev/null || echo "Updating ports tree failed!"

echo "# VULNERABILITIES"
echo

for jail in $(jails);do 
        JID=$(jid $jail)
        echo "--- ${jail} ---"
        jexec $JID pkg audit 
        echo $DELIMITER
done

echo
echo $SECTION
echo

echo "# AVAILABLE UPDATES"
echo

for jail in $(jails);do 
        JID=$(jid $jail)
        echo "--- ${jail} ---"
        jexec $JID portmaster -L --index-only| egrep '(ew|ort) version|total install'
        echo $DELIMITER
        echo
done
