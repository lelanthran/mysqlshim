<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_login ($email, $password) {
   auth_load ();

   $session_id = auth_login ($email, $password);
   if (strlen ($session_id) < 32) {
      echo util_response (ERRCODE_LOGIN_FAILURE, ERRMESG_LOGIN_FAILURE, []);
      exit (0);
   }

   setcookie ("mysqlshim_session", $session_id);
   echo util_response (ERRCODE_SUCCESS, ERRMESG_SUCCESS, [ ["session-id"], [$session_id] ]);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);

mysqlshim_login ($data->{'email'}, $data->{'password'});

?>
