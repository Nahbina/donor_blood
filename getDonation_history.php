<?php
// Include database connection
include "./database/database_connection.php";

// Check if user_id is provided in the request
if (!isset($_POST['user_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "User ID not provided!"
    ]);
    die();
}

$user_id = $_POST['user_id'];

// Prepare the SQL statement to fetch donation history for the specific user
$sql = "SELECT * FROM donation_history WHERE user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $user_id);

// Execute the statement
mysqli_stmt_execute($stmt);

// Get result set
$result = mysqli_stmt_get_result($stmt);

if ($result) {
    $donation_history = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $donation_history[] = $row;
    }

    echo json_encode([
        "success" => true,
        "message" => "Donation history fetched successfully!",
        "donation_history" => $donation_history
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Something went wrong while fetching donation history!"
    ]);
}
?>
