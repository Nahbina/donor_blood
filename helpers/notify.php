<?php
// Include database connection
include "./database/database_connection.php";

function sendNotification($userId, $requestId, $message) {
    global $CON;

    // SQL statement to insert a new notification
    $sql = "INSERT INTO Notifications (user_id, request_id, message, created_at) VALUES (?, ?, ?, NOW())";
    $stmt = mysqli_prepare($CON, $sql);

    // Bind parameters and execute the statement
    mysqli_stmt_bind_param($stmt, "iis", $userId, $requestId, $message);
    mysqli_stmt_execute($stmt);

    // Close the statement
    mysqli_stmt_close($stmt);
}


?>
