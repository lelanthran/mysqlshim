<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_auth_logout () {
   auth_load ();

   $result = auth_logout ();
   setcookie ("mysqlshim_session", "0");
   echo util_response ($result[0], $result[1], []);
}

mysqlshim_auth_logout ();

?>
