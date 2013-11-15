#!/usr/local/bin/zsh
SHELL=/usr/local/bin/zsh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin
JAIL_PORTS=/usr/jails/ports
SECTION=' * * * * * * '
DELIMITER='------------------------------'

portsnap -p "${JAIL_PORTS}" fetch extract &>/dev/null || { echo "[-] Updating ports tree failed!"; }
echo "# PORTS TREE UPDATED"
echo

echo
echo "$SECTION"
echo

echo "# VULNERABILITIES"
echo

for jail in $(jails);do 
	JID=$(jid ${jail})
	echo "--- ${jail} ---"
	jexec ${JID} portaudit -Fda
	echo "$DELIMITER"
	echo
done

echo
echo "$SECTION"
echo

echo "# AVAILABLE UPDATES"
echo

for jail in $(jails);do 
	JID=$(jid ${jail})
	echo "--- ${jail} ---"
	jexec ${JID} portmaster -L --index-only| egrep '(ew|ort) version|total install'
	echo "$DELIMITER"
	echo
done