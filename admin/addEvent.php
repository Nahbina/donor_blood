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

// Check if the user associated with the token is authenticated and authorized to insert events
if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Extract event details from the request
if (isset($_POST['event_name'], $_POST['event_date'], $_POST['event_location'], $_POST['event_description'], $_POST['event_time'])) {
    $event_name = $_POST["event_name"];
    $event_date = $_POST["event_date"];
    $event_location = $_POST["event_location"];
    $event_description = $_POST['event_description'];
    $event_time = $_POST["event_time"];
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required event details are not set"
    ]);
    die();
}

// Insert event data into the database
$sql = "INSERT INTO events (event_name, event_date, event_location, event_description,event_time) VALUES (?,?, ?, ?, ?)";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "sssss", $event_name, $event_date, $event_location, $event_description,$event_time);

$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Event inserted successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to insert event!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
