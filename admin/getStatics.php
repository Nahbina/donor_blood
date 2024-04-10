<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Include database connection
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

// Check if the user associated with the token is authenticated and authorized
if (!isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Initialize variables
$no_of_events = 0;
$totalIncome = 0;
$totalBloodRequests = 0;
$totalDonors = 0;
$totalUsers = 0;
$totalUniqueDonors = 0; // Variable to store the count of unique donors

// Fetch stats
$sql = "SELECT COUNT(*) AS totalEvents FROM events";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $no_of_events = $row['totalEvents'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total events!"
    ]);
    die();
}

$sql = "SELECT SUM(amount) AS totalIncome FROM payment";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $totalIncome = $row['totalIncome'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total income!"
    ]);
    die();
}

$sql = "SELECT COUNT(*) AS totalBloodRequests FROM blood_requests";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $totalBloodRequests = $row['totalBloodRequests'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total blood requests!"
    ]);
    die();
}

$sql = "SELECT COUNT(*) AS totalDonors FROM donors";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $totalDonors = $row['totalDonors'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total donors!"
    ]);
    die();
}

// Fetch count of unique donors based on blood types (A-, B-, AB-, O-)
$sql = "SELECT COUNT(*) AS totalUniqueDonors FROM (SELECT DISTINCT blood_type FROM donors WHERE blood_type IN ('A-', 'B-', 'AB-', 'O-')) AS unique_donors";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $totalUniqueDonors = $row['totalUniqueDonors'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total unique donors!"
    ]);
    die();
}

$sql = "SELECT COUNT(*) AS totalUsers FROM users WHERE role = 'user'";
$result = mysqli_query($CON, $sql);
if ($result) {
    $row = mysqli_fetch_assoc($result);
    $totalUsers = $row['totalUsers'];
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch total users!"
    ]);
    die();
}

echo json_encode([
    "success" => true,
    "message" => "Stats fetched successfully!",
    "stats" => [
        "no_of_events" => $no_of_events,
        "totalIncome" => $totalIncome,
        "totalBloodRequests" => $totalBloodRequests,
        "totalDonors" => $totalDonors,
        "totalUsers" => $totalUsers,
        "totalUniqueDonors" => $totalUniqueDonors // Include count of unique donors
    ]
]);
?>
