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

// // Check if the user is a donor
// if (!isDonor($CON, $token)) {
//     echo json_encode([
//         "success" => false,
//         "message" => "Only donors can view request blood!"
//     ]);
//     die();
// }

// Retrieve the donor ID directly from the database
$sql = "SELECT donor_id FROM donors WHERE user_id = ?";
$stmt = mysqli_prepare($CON, $sql);

if (!$stmt) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to prepare statement: " . mysqli_error($CON)
    ]);
    die();
}

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "i", $userId);
if (!mysqli_stmt_execute($stmt)) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to execute statement: " . mysqli_error($CON)
    ]);
    die();
}

$result = mysqli_stmt_get_result($stmt);
$row = mysqli_fetch_assoc($result);

if (!$row) {
    echo json_encode([
        "success" => false,
        "message" => "Donor ID not found for the user!"
    ]);
    die();
}

$donorId = $row['donor_id'];

// Prepare the SQL statement to get blood requests for the donor
$sql = "SELECT * FROM blood_requests WHERE donor_id = ?";
$stmt = mysqli_prepare($CON, $sql);

if (!$stmt) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to prepare statement: " . mysqli_error($CON)
    ]);
    die();
}

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "i", $donorId);
if (!mysqli_stmt_execute($stmt)) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to execute statement: " . mysqli_error($CON)
    ]);
    die();
}

$result = mysqli_stmt_get_result($stmt);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to get result set: " . mysqli_error($CON)
    ]);
    die();
}

$requests = [];
while ($row = mysqli_fetch_assoc($result)) {
    $requests[] = $row;
}

if (empty($requests)) {
    echo json_encode([
        "success" => true,
        "message" => "No blood requests found for the donor.",
        "requests" => [],
        "donor_id" => $donorId
    ]);
} else {
    echo json_encode([
        "success" => true,
        "message" => "Blood requests fetched successfully!",
        "requests" => $requests
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
