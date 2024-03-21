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

// Prepare the SQL statement to get blood requests for the donor
$sql = "SELECT * FROM blood_requests WHERE donor_id = ?";
$stmt = mysqli_prepare($CON, $sql);

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "i", $userId);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if ($result) {
    $requests = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }
    echo json_encode([
        "success" => true,
        "message" => "Blood requests fetched successfully!",
        "requests" => $requests
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch blood requests!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
