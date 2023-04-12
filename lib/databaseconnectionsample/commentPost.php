<?php

// Set up database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "project";
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get POST data
$user_id = $_POST["user_id"];
$comment_content = $_POST["comment_content"];
$timestamp = date("Y-m-d H:i:s");

// Insert comment into database
$sql = "INSERT INTO comments (User_ID,Comment_Content, Timestamp) VALUES ('$user_id','$comment_content', '$timestamp')";
if ($conn->query($sql) === TRUE) {
    echo "Comment posted successfully";
} else {
    echo "Error posting comment: " . $conn->error;
}

$conn->close();

?>