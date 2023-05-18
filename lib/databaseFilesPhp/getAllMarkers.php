<?php
include 'conn.php';

// Select all markers from the database
$sql = "SELECT * FROM markers";
$result = $conn->query($sql);

// Check if there are any markers
if ($result->num_rows > 0) {
    // Create an array to store the markers
    $markers = array();

    // Loop through each marker and add it to the array
    while ($row = $result->fetch_assoc()) {
        $markers[] = array(
            'marker_id' => $row['marker_id'],
            'position_x' => $row['position_x'],
            'position_y' => $row['position_y'],
            'title' => $row['title'],
            'message' => $row['message'],
        );
    }

    // Return the array of markers as JSON
    echo json_encode($markers);
} else {
    // No markers found
    echo "No markers found";
}

// Close the connection
$conn->close();
?>