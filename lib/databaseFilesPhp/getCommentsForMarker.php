<?php
include 'conn.php';

// Sanitize and validate the input parameters
$marker_id = mysqli_real_escape_string($conn, $_POST['marker_id']);

// Retrieve comments for the selected marker
$sql = "SELECT * FROM comments WHERE marker_id = '$marker_id'";
$result = $conn->query($sql);

// Return the comments to the client
if ($result->num_rows > 0) {
    $comments = array();
    while($row = $result->fetch_assoc()) {
        $comment = array(
            'comment_id' => $row['comment_id'],
            'user_id' => $row['user_id'],
            'comment_content' => $row['comment_content'],
            'time_stamp' => $row['time_stamp']
        );
        array_push($comments, $comment);
    }
    echo json_encode($comments);
} else {
    echo "No comments found for the selected marker";
}

// Close the connection
mysqli_close($conn);
?>
