<?php
$authfile = 'auth-file.csv';

// TODO: Lookup the session, store the username/perms/etc here
$g_email = "admin";
$g_perms = "";

function auth_load () {
   // TODO:
}

function auth_save () {
   // TODO:
}

function auth_login () {
   // TODO: Perform password comparison, generate session id, return session id
   return "012345678901234567890123456789012";
}

function auth_change_password () {
   // $ret = [ ERRCODE_AUTH_FAILURE, ERRMESG_AUTH_FAILURE ];
   // TODO: perform password comparison, generate new password, store new password.
   $ret = [ ERRCODE_SUCCESS, ERRMESG_SUCCESS ];
   return $ret;
}

function auth_logout () {
   // TODO: Clear session id in authfile, save authfile,
   $ret = [ ERRCODE_SUCCESS, ERRMESG_SUCCESS ];
   return $ret;
}

?>
