<?php
include 'conn.php';

// Get user input from the request
$user_id = $_POST['user_id'];
$comment_id = $_POST['comment_id'];

// Check the current like status for the comment
$query = "SELECT like_situation FROM likes_dislikes WHERE user_id = ? AND comment_id = ?";
$stmt = $conn->prepare($query);
$stmt->execute([$user_id, $comment_id]);
$result = $stmt->fetch(PDO::FETCH_ASSOC);

if ($result) {
    $currentStatus = $result['like_situation'];
    $newStatus = !$currentStatus;

    // Update the like status
    $query = "UPDATE likes_dislikes SET like_situation = ? WHERE user_id = ? AND comment_id = ?";
    $stmt = $conn->prepare($query);
    $stmt->execute([$newStatus, $user_id, $comment_id]);

    $message = ($newStatus) ? 'Comment liked' : 'Comment unliked';
} else {
    // Insert a new like
    $query = "INSERT INTO likes_dislikes (user_id, comment_id, like_situation) VALUES (?, ?, 1)";
    $stmt = $conn->prepare($query);
    $stmt->execute([$user_id, $comment_id]);

    $message = 'Comment liked';
}

// Return a response
$response = [
    'status' => 'success',
    'message' => $message,
    'user_id' => $user_id,
];
echo json_encode($response);
?>