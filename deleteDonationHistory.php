<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
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

$userId = getUserId($CON, $token);

// Check if user ID is valid
if (!$userId) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid user ID"
    ]);
    die();
}

// Check if donation history ID is provided in the request
if (!isset($_POST['donation_history_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Donation history ID not provided!"
    ]);
    die();
}

// Extract donation history ID from the request
$donationHistoryId = $_POST["donation_history_id"];

// Delete donation history data from the database
$sql = "DELETE FROM donation_history WHERE donor_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $donationHistoryId);

$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Donation history deleted successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to delete donation history!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
