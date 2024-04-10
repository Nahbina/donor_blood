<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include "./database/database_connection.php";
include "./helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

$userId = getUserId($CON, $token);
if ($userId == null) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user is a donor
$sql = "SELECT * FROM donors WHERE user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $userId);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$row = mysqli_fetch_assoc($result);
$isDonor = !empty($row); // Check if donor record exists
$donorId = null; // Initialize donor ID
if ($row) {
    $donorId = $row['donor_id']; // Retrieve donor ID if available
}
mysqli_stmt_close($stmt);

// Retrieve blood requests based on user type
if ($isDonor) {
    // If the user is a donor, retrieve blood requests they received
    $sql = "SELECT * FROM blood_requests WHERE donor_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $donorId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $requests = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }
    mysqli_stmt_close($stmt);

    $message = empty($requests) ? "No blood requests found for the donor." : "Blood requests received by the donor fetched successfully!";
} else {
    // If the user is not a donor, retrieve blood requests they sent as a requester
    $sql = "SELECT * FROM blood_requests WHERE user_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $requests = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }
    mysqli_stmt_close($stmt);

    $message = empty($requests) ? "No blood requests found for the user." : "Blood requests sent by the user fetched successfully!";
}

echo json_encode([
    "success" => true,
    "message" => $message,
    "requests" => $requests
]);

mysqli_close($CON);
?>
