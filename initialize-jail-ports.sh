#!/usr/local/bin/bash
# Initialiazes a jails PORTs for use with the cron job.

[ 0 -eq $(grep -c WITH_PKGNG /mnt/jails/$1/etc/make.conf) ] && echo 'WITH_PKGNG=yes' >> /mnt/jails/$1/etc/make.conf && jexec "$1" pkg2ng

echo "Updating PORTS with fetch/extract"
 jexec "${1}" portsnap -p $JAIL_PORTS fetch extract &>/dev/null || (echo "Updating ports tree failed for jail ${jail}!" && exit 1)

jexec "${1}" pkg update
jexec "${1}" portmaster -Pa
jexec "${1}" portmaster --update-if-newer bash emacs-nox11 portmaster
