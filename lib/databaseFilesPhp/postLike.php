<?php
include 'conn.php';

// Get user input from the request
$user_id = $_POST['user_id'];
$comment_id = $_POST['comment_id'];

// Check the current like status for the comment
$query = "SELECT like_status FROM like WHERE user_id = ? AND comment_id = ?";
$stmt = $db->prepare($query);
$stmt->execute([$user_id, $comment_id]);
$result = $stmt->fetch(PDO::FETCH_ASSOC);

if ($result) {
    $currentStatus = $result['like_status'];
    $newStatus = ($currentStatus == 1) ? 0 : 1;

    // Update the like status
    $query = "UPDATE like SET like_status = ? WHERE user_id = ? AND comment_id = ?";
    $stmt = $db->prepare($query);
    $stmt->execute([$newStatus, $user_id, $comment_id]);

    $message = ($newStatus == 1) ? 'Comment liked' : 'Comment unliked';
} else {
    // Insert a new like
    $query = "INSERT INTO like (user_id, comment_id, like_status) VALUES (?, ?, 1)";
    $stmt = $db->prepare($query);
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