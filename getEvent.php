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

// Extract the token from the request
$token = $_POST['token'];

// Check if the user associated with the token is authenticated and authorized to retrieve events
//if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    //echo json_encode([
      //  "success" => false,
        //"message" => "Unauthorized access!"
    //]);
    //die();
//}
if (!getUserId($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}
// Retrieve events from the database
$sql = "SELECT * FROM events";
$result = mysqli_query($CON, $sql);

if ($result) {
    $events = [];
    while ($row = mysqli_fetch_assoc($result)) {
        // Build an array of events
        $events[] = [
            "id" => $row['id'],
            "event_name" => $row['event_name'],
            "event_date" => $row['event_date'],
            "event_location" => $row['event_location'],
            "event_description" => $row['event_description'],
            "event_time" => $row['event_time']
        ];
    }
    echo json_encode([
        "success" => true,
        "events" => $events
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to retrieve events!"
    ]);
}

// Close the database connection
mysqli_close($CON);
?>
