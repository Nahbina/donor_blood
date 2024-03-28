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

// Extract the token from the request
$token = $_POST['token'];

// Check if the user associated with the token is authenticated and authorized to delete events
if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if event ID is provided in the request
if (!isset($_POST['event_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Event ID not provided!"
    ]);
    die();
}

// Extract event ID from the request
$event_id = $_POST["event_id"];

// Delete event data from the database
$sql = "DELETE FROM events WHERE id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $event_id);

$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Event deleted successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete event!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>