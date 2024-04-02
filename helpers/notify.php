<?php
// Include database connection
include "./database/database_connection.php";

function sendNotification($donorId, $requestId, $message) {
    global $CON;

    // Insert the notification
    $sql = "INSERT INTO Notifications (donor_Id, request_id, message, created_at) VALUES (?, ?, ?, NOW())";
    $stmt = mysqli_prepare($CON, $sql);

    // Bind parameters and execute the statement
    mysqli_stmt_bind_param($stmt, "iis", $donorId, $requestId, $message);
    $result = mysqli_stmt_execute($stmt);

    // Close the statement
    mysqli_stmt_close($stmt);

    return $result; // Return true if successful, false otherwise
}
?>
