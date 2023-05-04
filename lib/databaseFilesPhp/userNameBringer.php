<?php
include 'conn.php';

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Sanitize and validate the input parameter
$userId = mysqli_real_escape_string($conn, $_POST['userId']);

// Query the database
$sql = "SELECT User_name FROM usertable WHERE User_ID = '$userId'";
$result = mysqli_query($conn, $sql);

// Check for errors
if (!$result) {
    die("Query failed: " . mysqli_error($conn));
}

// Check if the user exists
if (mysqli_num_rows($result) > 0) {
    // Fetch the username from the result set
    $row = mysqli_fetch_assoc($result);
    $userName = $row['User_name'];

    // Send the JSON response
    header('Content-Type: application/json');
    echo json_encode(array('userName' => $userName));
} else {
    // Send an error response
    header('HTTP/1.1 404 Not Found');
    echo 'User not found';
}

// Close the connection
mysqli_close($conn);
?>
