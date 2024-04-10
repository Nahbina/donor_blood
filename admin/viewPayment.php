<?php

header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";

// Include authentication helper functions
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

// Check if the user associated with the token is authenticated and authorized to view payments
$user_id = getUserId($CON, $token);
if (!$user_id || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Query to retrieve payment details along with user information
$sql = "SELECT p.payment_id, p.user_id, p.amount, p.details, p.payment_date, p.status, u.full_name, u.email 
        FROM payment p
        INNER JOIN users u ON p.user_id = u.user_id";
$result = mysqli_query($CON, $sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch payment details"
    ]);
    die();
}

// Fetch payment details along with user information
$payments = [];
while ($row = mysqli_fetch_assoc($result)) {
    $payments[] = [
        "payment_id" => $row['payment_id'],
        "user_id" => $row['user_id'],
        "full_name" => $row['full_name'],
        "email" => $row['email'],
        "amount" => $row['amount'],
        "details" => $row['details'],
        "payment_date" => $row['payment_date'],
        "status" => $row['status']
    ];
}

echo json_encode([
    "success" => true,
    "payments" => $payments
]);
?>
