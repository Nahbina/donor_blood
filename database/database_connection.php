<?php

$HOST = 'localhost';
$USER = 'root';
$PASS = '';
$DB = 'donor_blood';

$CON = mysqli_connect($HOST, $USER, $PASS, $DB);

if (!$CON) {

    echo 'Connection failed';
}
