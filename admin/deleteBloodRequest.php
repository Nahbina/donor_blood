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

// Check if required form fields are set
if (!isset($_POST['request_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Request ID is required!"
    ]);
    die();
}

$requestId = $_POST['request_id'];

// Check if the user is authorized to delete this blood request
$sql_check_authorization = "SELECT COUNT(*) FROM blood_requests WHERE request_id = ? AND (user_id = ? OR ?)";
$stmt_check_authorization = mysqli_prepare($CON, $sql_check_authorization);
$isAdmin = isAdmin($CON, $token) ? 1 : 0;
mysqli_stmt_bind_param($stmt_check_authorization, "iii", $requestId, $userId, $isAdmin);
mysqli_stmt_execute($stmt_check_authorization);
mysqli_stmt_bind_result($stmt_check_authorization, $authorizationCount);
mysqli_stmt_fetch($stmt_check_authorization);
mysqli_stmt_close($stmt_check_authorization);

if ($authorizationCount == 0) {
    echo json_encode([
        "success" => false,
        "message" => "You are not authorized to delete this blood request!"
    ]);
    die();
}

// Delete the blood request
$sql_delete_request = "DELETE FROM blood_requests WHERE request_id = ?";
$stmt_delete_request = mysqli_prepare($CON, $sql_delete_request);
mysqli_stmt_bind_param($stmt_delete_request, "i", $requestId);
$result_delete_request = mysqli_stmt_execute($stmt_delete_request);

if ($result_delete_request) {
    echo json_encode([
        "success" => true,
        "message" => "Blood request deleted successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete blood request!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt_delete_request);
?>
