<?php
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");
// Include database connection
include "./database/database_connection.php";
include "./helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$user_id = getUserId($CON, $_POST['token']);

$sql = "SELECT user_id, full_name, email, role FROM users WHERE user_id = '$user_id'";

$result = mysqli_query($CON, $sql);

if ($result) {
    $user = mysqli_fetch_assoc($result);

    echo json_encode([
        "success" => true,
        "message" => "User details fetched successfully!",
        "user" => $user
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Something went wrong!"
    ]);
}
?>
