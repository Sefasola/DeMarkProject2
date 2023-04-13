

<?php
include 'conn.php';
// Insert comment into database
$sql = "INSERT INTO comments (User_ID, Comment_Content, Timestamp) VALUES ('$user_id', '$comment_content', '$timestamp')";
if ($conn->query($sql) === TRUE) {
    $comment_id = $conn->insert_id;
    echo "Comment posted successfully with Comment_ID = $comment_id";
    
    // Associate comment with marker
    $marker_id = $_POST["marker_id"];
    $sql = "INSERT INTO marker_comments (Marker_ID, Comment_ID) VALUES ('$marker_id', '$comment_id')";
    if ($conn->query($sql) === TRUE) {
        echo "Comment associated with marker successfully";
    } else {
        echo "Error associating comment with marker: " . $conn->error;
    }
} else {
    echo "Error posting comment: " . $conn->error;
}

?>