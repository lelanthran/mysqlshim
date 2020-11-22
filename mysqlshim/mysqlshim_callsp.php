<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_callsp ($sp_name, $pagenum, $pagesize, $params) {
   auth_load ();
   print_r ($params, true);

   // echo util_response ($result[0], $result[1], []);
   echo util_response (0, 0, []);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);
$params = $data->{"params"};

mysqlshim_callsp ($data->{"sp-name"}, $data->{"page-number"}, $data->{"page-size"}, $params);

?>

