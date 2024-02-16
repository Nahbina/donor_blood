<?php

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

// Include necessary files
include "./database/connection.php";
include "./helpers/auth.php";

// Collect token from the request
$token = $_POST['token'];
// $userId = getUserId($token); // Assuming there's a function to get the user ID from the token
$isAdmin = isAdmin($userId, $token);


// If the user is not an admin, return error message
if(!$isAdmin) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Collect event data from the request
$event_name = $_POST["event_name"];
$event_date = $_POST["event_date"];
$event_location = $_POST["event_location"];

// Validate event data (you can add more validation as needed)
if (empty($event_name) || empty($event_date) || empty($event_location)) {
    echo json_encode([
        "success" => false,
        "message" => "All fields are required!"
    ]);
    die();
}

// Insert event data into the database
$sql = "INSERT INTO events (event_name, event_date, event_location) VALUES ('$event_name', '$event_date', '$event_location')";

if (mysqli_query($conn, $sql)) {
    echo json_encode([
        "success" => true,
        "message" => "Event added successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Error: " . $sql . "<br>" . mysqli_error($conn)
    ]);
}

// Close database connection
mysqli_close($conn);
?>

