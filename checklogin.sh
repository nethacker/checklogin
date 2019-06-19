#!/bin/sh
#
# License: (MIT), Copyright (C) 2019 checklogin Author Phil Chen
#
# The below directory path under BASE is where the script will keep track of logins
# and hold the checklogin.sh script itself. EMAIL is what email gets notified of logins change this. 
BASE=/var/log/logins
EMAIL="youremail@whatever.com"
#
# The two files below checked for a delta against each other 
HISTORY=${BASE}/history
CURRENT=${BASE}/current
#
# Failure function
fail()
{
    echo "Failed: $*"
    exit 1
}
#
# Function to clean output from the last command
clean_last()
{
    /usr/bin/last | sed '{
        /^reboot /d
        /^$/d
        /^wtmp begins /d
    }'
}
MYGROUP=`id -gn`
MYIDENT=`id -un`
#
# Checking the env or error
[ -d ${BASE} ] || mkdir -p ${BASE}
[ -d ${BASE} ] || fail could not create ${BASE}
[ -G ${BASE} ] || fail ${BASE} not owned by ${MYGROUP}
[ -O ${BASE} ] || fail ${BASE} not owned by ${MYIDENT}
#
# Store current info
clean_last >${CURRENT}
#
# Is there a history file?
if [ -f ${HISTORY} ]
then
#
if ! `cmp --silent $CURRENT $HISTORY`
then
# Yes mail someone
#
diff $HISTORY $CURRENT |mail $EMAIL -s "Login report"
fi
fi
#
# Make current history
#
mv ${CURRENT} ${HISTORY}
[ $? -eq 0 ] || fail mv ${CURRENT} ${HISTORY}
exit 0
 
#END OF SCRIPT