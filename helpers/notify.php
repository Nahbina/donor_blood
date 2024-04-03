<?php
// Include database connection
include "./database/database_connection.php";

function sendNotification($donorId, $requestId, $message) {
    global $CON;
    
    // Check if the donor_id exists in the donors table
    $checkSql = "SELECT COUNT(*) FROM donors WHERE donor_id = ?";
    $checkStmt = mysqli_prepare($CON, $checkSql);
    mysqli_stmt_bind_param($checkStmt, "i", $donorId);
    mysqli_stmt_execute($checkStmt);
    mysqli_stmt_bind_result($checkStmt, $count);
    mysqli_stmt_fetch($checkStmt);
    mysqli_stmt_close($checkStmt);
    
    if ($count > 0) {
        // Insert notification into the notifications table
        $sql = "INSERT INTO notifications (donor_id, request_id, message) VALUES (?, ?, ?)";
        $stmt = mysqli_prepare($CON, $sql);
        mysqli_stmt_bind_param($stmt, "iis", $donorId, $requestId, $message);
        $result = mysqli_stmt_execute($stmt);
        mysqli_stmt_close($stmt);
        
        return $result;
    } else {
        return false; // Donor ID does not exist
    }
}

?>
