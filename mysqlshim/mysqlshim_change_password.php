<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_change_password ($email, $old_pass, $new_pass, $confirm_pass) {
   auth_load ();

   $result = auth_change_password ($email, $old_pass, $new_pass, $confirm_pass);
   echo util_response ($result[0], $result[1], []);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);

mysqlshim_change_password ($data->{'target-email'},
                           $data->{'old-password'},
                           $data->{'new-password'},
                           $data->{'confirm-password'});

?>
