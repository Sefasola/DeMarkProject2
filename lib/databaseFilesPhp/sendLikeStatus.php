<?php
include 'conn.php';

// Sanitize and validate the input parameters
$commentId = mysqli_real_escape_string($conn, $_POST['comment_id']);
$userId = mysqli_real_escape_string($conn, $_POST['user_id']);
$likeStatus = mysqli_real_escape_string($conn, $_POST['like_situation']);

// Check if the connection between user_id and comment_id already exists
$checkSql = "SELECT id FROM likes_dislikes WHERE comment_id = '$commentId' AND user_id = '$userId'";
$checkResult = $conn->query($checkSql);

if ($checkResult->num_rows > 0) {
    // Update the like_situation
    $updateSql = "UPDATE likes_dislikes SET like_situation = '$likeStatus' WHERE comment_id = '$commentId' AND user_id = '$userId'";
    if ($conn->query($updateSql) === TRUE) {
        $id = $conn->insert_id;
        echo json_encode(array('id' => $id));
    } else {
        echo "Error updating like: " . $conn->error;
    }
} else {
    // Insert a new record
    $insertSql = "INSERT INTO likes_dislikes (comment_id, user_id, like_situation) VALUES ('$commentId', '$userId', '$likeStatus')";
    if ($conn->query($insertSql) === TRUE) {
        $id = $conn->insert_id;
        echo json_encode(array('id' => $id));
    } else {
        echo "Error adding like: " . $conn->error;
    }
}

// Close the connection
mysqli_close($conn);
?>