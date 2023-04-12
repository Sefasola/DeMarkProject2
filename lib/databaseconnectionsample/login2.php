<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "login";
$port = 4306;

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname, $port);
mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 300);
mysqli_query($conn, "SET GLOBAL max_allowed_packet=100000000");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Query the database
$sql = "SELECT id, username, level FROM user";
$result = mysqli_query($conn, $sql);

// Check for errors
if (!$result) {
    die("Query failed: " . mysqli_error($conn));
}

// Create an array to hold the results
$users = array();

// Loop through the result set
while ($row = mysqli_fetch_assoc($result)) {
    $user = array(
        'id' => $row['id'],
        'username' => $row['username'],
        'level' => $row['level']
    );
    array_push($users, $user);
}

// Send the JSON response
header('Content-Type: application/json');
echo json_encode($users);

// Close the connection
mysqli_close($conn);

?>
