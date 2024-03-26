<?php
// Include database connection
include "./database/database_connection.php";

// Include authentication helper functions
include "./helpers/auth.php";

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

// Check if the user associated with the token is the donor for this request
$sql = "SELECT * FROM blood_requests WHERE donor_id = ? AND request_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "ii", $userId, $requestId);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$row = mysqli_fetch_assoc($result);

if (!$row) {
    echo json_encode([
        "success" => false,
        "message" => "You are not authorized to cancel this request!"
    ]);
    die();
}

// Prepare the SQL statement to cancel the blood request
$sql = "UPDATE blood_requests SET status = 'cancelled' WHERE request_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $requestId);
mysqli_stmt_execute($stmt);

// Check if the update was successful
if (mysqli_stmt_affected_rows($stmt) > 0) {
    echo json_encode([
        "success" => true,
        "message" => "Blood request cancelled successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to cancel blood request or request not found!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
