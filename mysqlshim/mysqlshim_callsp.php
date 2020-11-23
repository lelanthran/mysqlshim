<?php

require_once 'auth.php';
require_once 'util.php';
require_once 'errorcodes.php';

function mysqlshim_callsp ($sp_name, $pagenum, $pagesize, $params) {
   auth_load ();

   // Connect to the database
   $mysqli = mysqli_connect ('localhost', 'lelanthran', 'a', 'testdb');

   /*
   // Create the querystring, format string
   $qstring = 'call ?(';
   $delim = '';
   $fstring = '';
   for ($i=0; $i<count ($params); $i++) {
      $qstring = $qstring . '?' . $delim;
      $delim = ',';
      $fstring = $fstring . 's';
   }

   // Prepare the statement
   $stmt = mysqli_prepare ($mysqli, $qstring);

   // Bind the parameters
   $bind_params = [];
   array_push ($bind_params, $stmt);
   array_push ($fstring, $mysqli);
   for ($i=0; $i<count ($params); $i++) {
      array_push ($bind_params, $params[$i]);
   }
   call_user_func_array (mysqli_bind_param, $bind_params);

   // Execute the statement
   mysqli_stmt_execute ($stmt);

   // TODO: Binding the results from the mysql interface is a pain in the rear.
   // Will come back to this later to fix, for now will simply concatenate the
   // statement and hope for the best.
   */

   // Work out the limit and offset
   $limit = $pagesize;
   $offset = $pagesize * $pagenum;
   $stmt = "call $sp_name(";
   $delim = '';
   $plist = '';
   for ($i=0; $i<count ($params); $i++) {
      $plist = $plist . $delim . $params[$i];
      $delim = ',';
   }
   $stmt = $stmt . $plist . ") LIMIT $limit OFFSET $offset;";

   echo $stmt;
   $res = mysqli_query ($mysqli, $stmt);

   $nrows = mysqli_num_rows ($res);

   $retval = [];
   $record = [];
   while ($finfo = mysqli_fetch_field ($res)) {
      array_push ($record, $finfo->name);
   }
   array_push ($retval, $record);
   for ($i=0; $i<$nrows; $i++) {
      array_push (mysqli_fetch_row ($res));
   }

   echo util_response (0, "Success", $retval);
}

$json = file_get_contents ('php://input');
$data = json_decode ($json);
$params = $data->{"params"};

mysqlshim_callsp ($data->{"sp-name"}, $data->{"page-number"}, $data->{"page-size"}, $params);

?>

