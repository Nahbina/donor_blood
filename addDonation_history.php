<?php
/* Include database connection
include "./database/database_connection.php";

// Retrieve token from the POST data
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

// Get the user ID associated with the token
$user_id = getUserId($CON, $_POST['token']);

// Check if user ID is valid
if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid token!"
    ]);
    die();
}

// Prepare the SQL statement to fetch donation history
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
