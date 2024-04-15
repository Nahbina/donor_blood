<?php
// Enable CORS
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
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

// Check if the user exists
$user_check_sql = "SELECT * FROM users WHERE user_id = ?";
$user_check_stmt = mysqli_prepare($CON, $user_check_sql);
mysqli_stmt_bind_param($user_check_stmt, "i", $user_id);
mysqli_stmt_execute($user_check_stmt);
$user_check_result = mysqli_stmt_get_result($user_check_stmt);

if (!$user_check_result || mysqli_num_rows($user_check_result) === 0) {
    echo json_encode([
        "success" => false,
        "message" => "User not found"
    ]);
    exit;
}

// Delete the user
$delete_sql = "DELETE FROM users WHERE user_id = ?";
$delete_stmt = mysqli_prepare($CON, $delete_sql);
mysqli_stmt_bind_param($delete_stmt, "i", $user_id);
$delete_result = mysqli_stmt_execute($delete_stmt);

if ($delete_result) {
    echo json_encode([
        "success" => true,
        "message" => "User deleted successfully"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete user"
    ]);
}
?>
