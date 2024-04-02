<?php

// Include database connection
include "./database/database_connection.php";

// Check if token is provided in the request
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

// Check if request ID is provided
if (!isset($_POST['request_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Request ID not found!"
    ]);
    die();
}

$requestId = $_POST['request_id'];

// Get the donor ID associated with the accepted request
$donorId = getDonorIdForAcceptedRequest($CON, $requestId);

if ($donorId != null) {
    // Insert a new record into the donation_history table
    $donationDate = date("Y-m-d H:i:s"); // Get the current date and time
    $insertSql = "INSERT INTO donation_history (donor_id, request_id, donation_date) VALUES (?, ?, ?)";
    $insertStmt = mysqli_prepare($CON, $insertSql);
    mysqli_stmt_bind_param($insertStmt, "iis", $donorId, $requestId, $donationDate);
    $insertResult = mysqli_stmt_execute($insertStmt);

    if ($insertResult) {
        echo json_encode([
            "success" => true,
            "message" => "Record inserted into donation history table successfully!"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to insert record into donation history table."
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to find donor ID for the accepted request."
    ]);
}

// Close the statement
mysqli_stmt_close($insertStmt);

// Function to retrieve the donor ID associated with the accepted request
function getDonorIdForAcceptedRequest($con, $requestId) {
    $sql = "SELECT donor_id FROM blood_requests WHERE request_id = ? AND status = 'accepted'";
    $stmt = mysqli_prepare($con, $sql);
    mysqli_stmt_bind_param($stmt, "i", $requestId);
    mysqli_stmt_execute($stmt);
    mysqli_stmt_bind_result($stmt, $donorId);
    mysqli_stmt_fetch($stmt);
    mysqli_stmt_close($stmt);
    return $donorId;
}
?>
