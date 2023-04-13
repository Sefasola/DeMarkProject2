<?php
include 'conn.php';

// Generate random values
$title = 'Marker ' . rand(1, 100);
$posX = rand(-90, 90) + rand(0, 999999) / 1000000; // Random latitude between -90 and 90
$posY = rand(-180, 180) + rand(0, 999999) / 1000000; // Random longitude between -180 and 180
$message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

// Insert marker into database
$sql = "INSERT INTO markers (Title, Position_X, Position_Y, Message) VALUES ('$title', '$posX', '$posY', '$message')";
if ($conn->query($sql) === TRUE) {
    $marker_id = $conn->insert_id;
    echo "Marker added successfully with Marker_ID = $marker_id";
} else {
    echo "Error adding marker: " . $conn->error;
}

// Close the connection
mysqli_close($conn);
?>