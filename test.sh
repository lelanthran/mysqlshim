#/bin/bash

# ################ #
# Global functions #
# ################ #

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
CROSS="✗"
CHECK="✓"
FAILED="$RED$CROSS$NC"
PASSED="$GREEN$CHECK$NC"


function check_rsperror () {
   if [ `grep -c '"errorcode": 0' "$1"` -eq 0 ]; then
      echo -ne $RED Error:$NC "\n"
      cat $1 | sed "s/^/$CROSS   /g"
      die "[$FAILED] $2 ${RED}failed$NC"
   fi
   echo -ne "[$PASSED] $2 ${GREEN}passed\n"
}

function runcurl () {
   curl -k -X POST -d postdata.txt -b cookie-jar.txt -c cookie-jar.txt -o response.txt "$1"
   export RC=$?
   check_rsperror response.txt "$1"
}

function die () {
   echo -ne "$@" "\n"
   exit 127;
}

rm -fv cookie-jar.txt postdata.txt response.txt

# ########################### #
# The endpoint test functions #
# ########################### #


function mysqlshim_login () {
   echo -ne '
{
   "email":    '"$1"',
   "password": '"$2"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_login.php
}

function mysqlshim_logout () {
   echo -ne '
{

}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_logout.php
}

function mysqlshim_change_password () {
   echo -ne '
{
   "target-email":         '"$1"',
   "old-password":         '"$2"',
   "new-password":         '"$3"',
   "confirm-password":     '"$4"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_change_password.php
}

function mysqlshim_add_user () {
   echo -ne '
{
   "new-email":            '"$1"',
   "new-password":         '"$2"',
   "confirm-password":     '"$3"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_add_user.php
}

function mysqlshim_disable_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_disable_user.php
}

function mysqlshim_enable_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_enable_user.php
}

function mysqlshim_del_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_del_user.php
}

function mysqlshim_callsp () {
   echo -ne '
{
   "sp-name":           '"$1"',
   "page-number":       '"$2"',
   "page-size":         '"$3"',

'  > postdata.txt
   shift 3;
   export PARAM=0
   for X in $@; do
      echo -ne "\"p_${PARAM}\": \"$x\",\n" >> postdata.txt
   done
   echo -ne '
   "random":     5
}'
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlshim/mysqlshim_callsp.php
}


# ################## #
# The testing itself #
# ################## #

mysqlshim_login "admin" "54321"


