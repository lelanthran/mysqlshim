<?php

function util_response ($errcode, $errmsg, $matrix) {
   $ret = '{';
   $ret = $ret . "\n" .
                 "  \"errorcode\": $errcode,\n" .
                 "  \"errormessage\": \"$errmsg\",\n";

   $ret = $ret . '  "payload": [ ';
   $nrows = count ($matrix);
   $delim = '';
   for ($i=0; $i<$nrows; $i++) {
      $ret = $ret . $delim;
      $delim = ",\n      ";
      $ret = $ret . json_encode ($matrix[$i]);
   }
   $ret = $ret . "   ]\n}\n";
   return $ret;
}

?>

