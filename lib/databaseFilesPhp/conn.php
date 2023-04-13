<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "project";
$port = 3306;

$conn = mysqli_connect($servername, $username, $password, $dbname, $port);
mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 300);
mysqli_query($conn, "SET GLOBAL max_allowed_packet=100000000");




?>