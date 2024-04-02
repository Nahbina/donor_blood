<?php

// Include database connection
include "./database/database_connection.php";

// Include authentication helper functions
include "./helpers/auth.php";
include "./helpers/notify.php"; // Include notification helper functions

// Check if token is provided in the request
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

// Get user ID associated with the token
$userId = getUserId($CON, $token);
if ($userId == null) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
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

// Prepare the SQL statement to update the status of the blood request
$sql = "UPDATE blood_requests SET status = 'accepted' WHERE request_id = ?";
$stmt = mysqli_prepare($CON, $sql);

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "i", $requestId);
$result = mysqli_stmt_execute($stmt);

// Check if the update was successful
if ($result) {
    // Get the donor ID associated with the accepted request
    $donorId = getDonorIdForAcceptedRequest($CON, $requestId);

    if ($donorId != null) {
        // Send notification to the user who sent the request
        $notificationResult = sendNotification($donorId, $requestId, "Your blood request has been accepted.");

        if ($notificationResult) {
            echo json_encode([
                "success" => true,
                "message" => "Blood request accepted successfully!"
            ]);
            die();
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Failed to send notification to the user."
            ]);
            die();
        }
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to find donor ID for the accepted request."
        ]);
        die();
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to accept blood request or request not found!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);

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
