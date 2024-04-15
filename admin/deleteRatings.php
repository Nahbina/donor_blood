<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";
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

// Check if the user associated with the token is authenticated and authorized to delete users
if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

if (!isset($_POST['user_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "User ID not provided!"
    ]);
    die();
}

// Extract user ID from the request
$user_id = $_POST["user_id"];
// Delete ratings from the database for the given user ID
$sql = "DELETE FROM ratings WHERE user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $user_id); // Use $user_id here instead of $userId
$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Ratings deleted successfully"
    ]);
} else {
    // Log the error
    error_log("Failed to delete ratings: " . mysqli_error($CON));
    
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete ratings"
    ]);
}

mysqli_stmt_close($stmt);
mysqli_close($CON);
?>
