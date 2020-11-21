#/bin/bash

function runcurl () {
   curl -k -X POST -d postdata.txt -b cookie-jar.txt -c cookie-jar.txt -o response.txt "$1"
   return $?
}

function die () {
   echo $@
   exit 127;
}

rm -v cookie-jar.txt postdata.txt response.txt

function check_rsperror () {
   if [ `grep -c '"errorcode": 0' "$1"` -ne 0 ]; then
      echo Error: `cat "$1"`
      die "response error"
   fi
}

function mysqlshim_login () {
   echo -ne '
{
   "email":    "admin",
   "password": "12345"
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_login.php
   check_rsperror response.txt
}

function mysqlshim_logout () {
   echo -ne '
{

}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_logout.php
   check_rsperror response.txt
}

function mysqlshim_change_password () {
   echo -ne '
{
   "target-email":         "admin",
   "old-password":         "54321",
   "new-password":         "12345",
   "confirm-password":     "12345",
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_change_password.php
   check_rsperror response.txt
}

function mysqlshim_add_user () {
   echo -ne '
{
   "new-email":            "test-user",
   "new-password":         "12345",
   "confirm-password":     "12345",
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_add_user.php
   check_rsperror response.txt
}

function mysqlshim_lockout_user () {
   echo -ne '
{
   "email":            "test-user",
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_lockout_user.php
   check_rsperror response.txt
}

function mysqlshim_del_user () {
   echo -ne '
{
   "email":            "test-user",
}
'  > postdata.txt
   runcurl http://localhost/~lelanthran/mysqlshim/mysqlhim/mysqlshim_del_user.php
   check_rsperror response.txt
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
   check_rsperror response.txt
}

