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

$token = $_POST['token'];

// Extract user ID from the token
$userId = getUserId($CON, $token);

// Check if user ID is valid
if (!$userId) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid user ID"
    ]);
    die();
}

if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}
// Check if donor exists for the given user ID
if (!isDonor($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "User is not a donor"
    ]);
    die();
}

// Delete donor information from the database
$sql = "DELETE FROM donors WHERE user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $userId);
$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Donor information deleted successfully"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete donor information"
    ]);
}

?>
