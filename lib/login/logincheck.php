<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "project";
$port = 4306;

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname, $port);
mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 300);
mysqli_query($conn, "SET GLOBAL max_allowed_packet=100000000");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Sanitize and validate the input parameters
$username = mysqli_real_escape_string($conn, $_POST['username']);
$password = mysqli_real_escape_string($conn, $_POST['password']);

// Query the database
$sql = "SELECT User_ID, User_name, Password, Level FROM usertable WHERE User_name = '$username' AND Password = '$password'";
$result = mysqli_query($conn, $sql);

// Check for errors
if (!$result) {
    die("Query failed: " . mysqli_error($conn));
}

// Create an array to hold the results
$users = array();

// Check if the user is registered
if (mysqli_num_rows($result) > 0) {
    // Loop through the result set
    while ($row = mysqli_fetch_assoc($result)) {
        $user = array(
            'User_ID' => $row['User_ID'],
            'User_name' => $row['User_name'],
            'Level' => $row['Level']
        );
        array_push($users, $user);
    }

    // Send the JSON response
    header('Content-Type: application/json');
    echo json_encode($users);
} else {
    // Send an error response
    header('HTTP/1.1 401 Unauthorized');
    echo 'Invalid username or password';
}

// Close the connection
mysqli_close($conn);
?>

