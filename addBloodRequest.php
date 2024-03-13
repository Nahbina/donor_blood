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

// Check if the user associated with the token is authenticated and authorized to request blood
if (!getUserId($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user is already a donor
if (isDonor($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Donors cannot request blood!"
    ]);
    die();
}

// Extract user ID from the token
$userId = getUserId($CON, $token);

// Check if required form fields are set
if (isset($_POST['donor_id'])) {
    $donorId = $_POST['donor_id'];

} else {
    echo json_encode([
        "success" => false,
        "message" => "Donor ID  is required!"
    ]);
    die();
}
// Prepare the SQL statement to insert a new blood request
$sql = "INSERT INTO blood_requests (user_id, donor_id, status, request_date) VALUES (?, ?, 'pending', NOW())";
$stmt = mysqli_prepare($CON, $sql);

// Bind parameters and execute the statement
mysqli_stmt_bind_param($stmt, "ii", $userId, $donorId);
$result = mysqli_stmt_execute($stmt);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Blood request sent successfully!"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Failed to send blood request!"
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>