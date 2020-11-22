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


function runcurl () {
   curl -k -X POST -d postdata.txt -b cookie-jar.txt -c cookie-jar.txt -o response.txt "$1"
   return $?
}

function die () {
   echo -ne "$@" "\n"
   exit 127;
}

rm -fv cookie-jar.txt postdata.txt response.txt

function check_rsperror () {
   if [ `grep -c '"errorcode": 0' "$1"` -eq 0 ]; then
      echo -ne $RED Error:$NC "\n"
      cat $1 | sed "s/^/$CROSS   /g"
      die "[$FAILED] $2 test ${RED}failed$NC"
   fi
   echo "[$PASSED] $2 test ${GREEN}passed"
}

# ########################### #
# The endpoint test functions #
# ########################### #
#
function mysqlshim_login () {
   echo -ne '
{
   "email":    '"$1"',
   "password": '"$2"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_login.php
   check_rsperror response.txt mysqlshim_login
}

function mysqlshim_logout () {
   echo -ne '
{

}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_logout.php
   check_rsperror response.txt mysqlshim_logout
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
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_change_password.php
   check_rsperror response.txt mysqlshim_change_password
}

function mysqlshim_add_user () {
   echo -ne '
{
   "new-email":            '"$1"',
   "new-password":         '"$2"',
   "confirm-password":     '"$3"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_add_user.php
   check_rsperror response.txt mysqlshim_add_user
}

function mysqlshim_disable_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_disable_user.php
   check_rsperror response.txt mysqlshim_disable_user
}

function mysqlshim_enable_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_enable_user.php
   check_rsperror response.txt mysqlshim_enable_user
}

function mysqlshim_del_user () {
   echo -ne '
{
   "email":            '"$1"',
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_del_user.php
   check_rsperror response.txt mysqlshim_del_user
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
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_callsp.php
   check_rsperror response.txt mysqlshim_callsp
}


# ################## #
# The testing itself #
# ################## #

mysqlshim_login "admin" "54321"


