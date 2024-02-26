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

// Retrieve token from the POST data
$token = $_POST['token'];

// Get the user ID associated with the token
$user_id = getUserId($CON, $token);

// Check if user ID is valid
if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid token!"
    ]);
    die();
}

// Prepare the SQL statement with a join to fetch full name from the user table
$sql = "SELECT bdr.*, u.full_name 
        FROM blood_donation_requests AS bdr
        INNER JOIN users AS u ON bdr.user_id = u.user_id";
$stmt = mysqli_prepare($CON, $sql);

// Execute the statement
mysqli_stmt_execute($stmt);

// Get result set
$result = mysqli_stmt_get_result($stmt);

if ($result) {
    $requests = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }

    echo json_encode([
        "success" => true,
        "message" => "Requests fetched successfully!",
        "requests" => $requests
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Something went wrong while fetching requests!"
    ]);
}
?>
