<?php

header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");

// Include database connection
include "../database/database_connection.php";

// Include authentication helper functions
include "../helpers/auth.php";

// Check if token is provided in the request
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

// Check if the user associated with the token is authenticated
$userId = getUserId($CON, $token);
if (!$userId) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user associated with the token is an admin
if (!isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Only admins are allowed to edit blood requests!"
    ]);
    die();
}

// Check if required form fields are set
if (!isset($_POST['request_id']) || !isset($_POST['status'])) {
    echo json_encode([
        "success" => false,
        "message" => "Request ID and status are required!"
    ]);
    die();
}

$requestId = $_POST['request_id'];
$status = $_POST['status'];

// Update the blood request status
$sql_update_request = "UPDATE blood_requests SET status = ? WHERE request_id = ?";
$stmt_update_request = mysqli_prepare($CON, $sql_update_request);
mysqli_stmt_bind_param($stmt_update_request, "si", $status, $requestId);
$result_update_request = mysqli_stmt_execute($stmt_update_request);

if ($result_update_request) {
    echo json_encode([
        "success" => true,
        "message" => "Blood request updated successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to update blood request!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt_update_request);
?>
