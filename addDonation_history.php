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

// Get user ID associated with the token
$userId = getUserId($CON, $token);
if ($userId == null) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Prepare the SQL statement to fetch donation history
$sql = "SELECT * FROM donation_history WHERE donor_id = ?";
$stmt = mysqli_prepare($CON, $sql);

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "i", $userId);
mysqli_stmt_execute($stmt);

// Fetch the results
$result = mysqli_stmt_get_result($stmt);
$donationHistory = mysqli_fetch_all($result, MYSQLI_ASSOC);

// Close the statement
mysqli_stmt_close($stmt);

echo json_encode([
    "success" => true,
    "donation_history" => $donationHistory
]);
?>
