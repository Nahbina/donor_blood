<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";
include "../helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

if (
    isset(
        $_POST['event_name'], 
        $_POST['event_date'], 
        $_POST['event_location'], 
        $_POST['event_description'], 
        $_POST['event_time']
    )
) {
    $event_name = $_POST["event_name"];
    $event_date = $_POST["event_date"];
    $event_location = $_POST["event_location"];
    $event_description = $_POST['event_description'];
    $event_time = $_POST["event_time"];
    $user_id = getUserId($CON, $token);
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required event details are not set"
    ]);
    die();
}

$sql = "INSERT INTO events (event_name, event_date, event_location, event_description, event_time, user_id) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "sssssi", $event_name, $event_date, $event_location, $event_description, $event_time, $user_id);

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

mysqli_stmt_close($stmt);
?>
