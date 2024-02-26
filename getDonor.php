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

// Prepare the SQL statement with JOIN to get full names from the User table
$sql = "SELECT donors.*, users.full_name FROM donors JOIN users ON donors.user_id = users.user_id";
$stmt = mysqli_prepare($CON, $sql);

// Execute the statement
mysqli_stmt_execute($stmt);

// Get result set
$result = mysqli_stmt_get_result($stmt);

if ($result) {
    $donors = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $donors[] = $row;
    }

    echo json_encode([
        "success" => true,
        "message" => "Donors fetched successfully!",
        "donors" => $donors
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Something went wrong while fetching donors!"
    ]);
}
?>
