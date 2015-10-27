#!/usr/local/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "-------- updating ${jail} --------"
    #jexec $JID portmaster -P -a -y
    jexec $JID portmaster -a -y
    jexec $JID portmaster -s -y
    #jexec $JID portmaster -t -y --clean-distfiles
    echo "-------- completed ${jail} -------"
    echo ""
    echo ""
done
