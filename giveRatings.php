<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include "./database/database_connection.php";
include "./helpers/auth.php";

// Check if token is provided
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    exit(); // Use exit() instead of die() for consistency
}

// Extract the token from the request
$token = $_POST['token'];

// Check if the user associated with the token is authenticated
$user_id = getUserId($CON, $token);
if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    exit(); // Use exit() instead of die() for consistency
}

// Check if rating and comment are provided
if (!isset($_POST['rating'], $_POST['comment'])) {
    echo json_encode([
        "success" => false,
        "message" => "All required rating details are not set"
    ]);
    exit(); // Use exit() instead of die() for consistency
}

// Extract rating and comment from the request
$rating = $_POST["rating"];
$comment = $_POST['comment'];
$created_at = date('Y-m-d H:i:s'); // Get the current date and time in MySQL format

// Prepare and execute the SQL query to insert rating
$sql = "INSERT INTO ratings (user_id, rating, created_at, comment) VALUES (?, ?, ?, ?)";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "iiss", $user_id, $rating, $created_at, $comment);
$result = mysqli_stmt_execute($stmt);

// Check if the query execution was successful
if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Rating inserted successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to insert rating!"
    ]);
}

mysqli_stmt_close($stmt); // Close the prepared statement
?>
