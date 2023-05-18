<?php
include 'conn.php';

// Sanitize and validate the input parameters
$marker_id = mysqli_real_escape_string($conn, $_POST['marker_id']);
$user_id = mysqli_real_escape_string($conn, $_POST['user_id']);
$comment_content = mysqli_real_escape_string($conn, $_POST['comment_content']);

// Insert comment into database
$stmt = $conn->prepare('INSERT INTO comments (marker_id, User_ID, Comment_Content, time_stamp) VALUES (?, ?, ?, NOW())');
$stmt->bind_param('iis', $marker_id, $user_id, $comment_content);
if ($stmt->execute()) {
    $comment_id = $stmt->insert_id;
    echo json_encode(array('comment_id' => $comment_id));
} else {
    echo "Error adding comment: " . $conn->error;
}

// Close the connection
mysqli_close($conn);
?>
