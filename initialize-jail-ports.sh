#!/usr/local/bin/bash
# Initialiazes a jails PORTs for use with the cron job.

echo "Updating PORTS with fetch/extract"
jexec "${1}" portsnap -p $JAIL_PORTS fetch extract &>/dev/null || (echo "Updating ports tree failed for jail ${jail}!" && exit 1)

jexec "${1}" pkg update
jexec "${1}" pkg install bash emacs-nox11 portmaster
jexec "${1}" portmaster -a

[ ! -s /etc/make.conf ] && echo 'WITH_PKGNG=yes' >> /etc/make.conf && pkg2ng
