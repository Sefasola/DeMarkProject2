<?php
include 'conn.php';

// Sanitize and validate the input parameters
$title = mysqli_real_escape_string($conn, $_POST['title']);
$posX = mysqli_real_escape_string($conn, $_POST['Position_X']);
$posY = mysqli_real_escape_string($conn, $_POST['Position_Y']);
$message = mysqli_real_escape_string($conn, $_POST['message']);

// Insert marker into database
$sql = "INSERT INTO markers (Title, Position_X, Position_Y, Message) VALUES ('$title', '$posX', '$posY', '$message')";
if ($conn->query($sql) === TRUE) {
    $marker_id = $conn->insert_id;
    echo json_encode(array('marker_id' => $marker_id));
} else {
    echo "Error adding marker: " . $conn->error;
}

// Close the connection
mysqli_close($conn);
?>