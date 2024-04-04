<?php

header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");
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

// Check if the user associated with the token is authenticated and authorized to request blood
if (!getUserId($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user is already a donor
if (isDonor($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Donors cannot request blood!"
    ]);
    die();
}

// Extract user ID from the token
$userId = getUserId($CON, $token);

// Check if required form fields are set
if (!isset($_POST['donor_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Donor ID is required!"
    ]);
    die();
}

$donorId = $_POST['donor_id'];

// Check if the user has already made a request to the same donor
$sql_check_request = "SELECT COUNT(*) FROM blood_requests WHERE user_id = ? AND donor_id = ?";
$stmt_check_request = mysqli_prepare($CON, $sql_check_request);
mysqli_stmt_bind_param($stmt_check_request, "ii", $userId, $donorId);
mysqli_stmt_execute($stmt_check_request);
mysqli_stmt_bind_result($stmt_check_request, $requestCount);
mysqli_stmt_fetch($stmt_check_request);
mysqli_stmt_close($stmt_check_request);

if ($requestCount > 0) {
    echo json_encode([
        "success" => false,
        "message" => "You have already made a blood request to this donor!"
    ]);
    die();
}

// Prepare the SQL statement to insert a new blood request
$sql_insert_request = "INSERT INTO blood_requests (user_id, donor_id, status, request_date) VALUES (?, ?, 'pending', NOW())";
$stmt_insert_request = mysqli_prepare($CON, $sql_insert_request);
mysqli_stmt_bind_param($stmt_insert_request, "ii", $userId, $donorId);
$result_insert_request = mysqli_stmt_execute($stmt_insert_request);

if ($result_insert_request) {
    echo json_encode([
        "success" => true,
        "message" => "Blood request sent successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to send blood request!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt_insert_request);
?>
