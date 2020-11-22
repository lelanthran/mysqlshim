<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_add_user ($new_email, $new_pass, $confirm_pass) {
   auth_load ();

   $result = auth_add_user ($new_email, $new_pass, $confirm_pass);
   setcookie ("mysqlshim_session", "0");
   echo util_response ($result[0], $result[1], []);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);
mysqlshim_add_user ($data["new-email"], $data["new-password"], $data["confirm-password"]);

?>
