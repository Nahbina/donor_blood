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

// Extract the token from the request
$token = $_POST['token'];

// Check if the user associated with the token is authenticated and authorized to edit events
if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if event ID and new event details are provided in the request
if (!isset($_POST['event_id'], $_POST['event_name'], $_POST['event_date'], $_POST['event_location'], $_POST['event_description'], $_POST['event_time'])) {
    echo json_encode([
        "success" => false,
        "message" => "Event ID or new event details are not set"
    ]);
    die();
}

// Extract event ID and new event details from the request
$event_id = $_POST["event_id"];
$event_name = $_POST["event_name"];
$event_date = $_POST["event_date"];
$event_location = $_POST["event_location"];
$event_description = $_POST['event_description'];
$event_time = $_POST["event_time"];

// Update event data in the database
$sql = "UPDATE events SET event_name = ?, event_date = ?, event_location = ?, event_description = ?, event_time = ? WHERE id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "ssssss", $event_name, $event_date, $event_location, $event_description, $event_time, $event_id);

$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Event edited successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to edit event!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
