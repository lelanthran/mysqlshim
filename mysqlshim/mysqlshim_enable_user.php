<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_enable_user ($email) {
   auth_load ();

   $result = auth_enable_user ($email);
   setcookie ("mysqlshim_session", "0");
   echo util_response ($result[0], $result[1], []);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);
mysqlshim_enable_user ($data->{"email"});

?>
