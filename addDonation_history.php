<?php
// Include database connection
include "./database/database_connection.php";

// Check if donor ID is provided
if (!isset($_POST['donor_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Donor ID not provided!"
    ]);
    die();
}

$donorId = $_GET['donor_id'];

// Prepare SQL statement to fetch donation history based on donor ID
$sql = "SELECT * FROM donation_history WHERE donor_id = ?";
$stmt = mysqli_prepare($CON, $sql);

// Bind parameter and execute the statement
mysqli_stmt_bind_param($stmt, "i", $donorId);
mysqli_stmt_execute($stmt);

// Get result
$result = mysqli_stmt_get_result($stmt);

// Check if there are any records
if (mysqli_num_rows($result) > 0) {
    // Fetch and return donation history
    $donationHistory = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode([
        "success" => true,
        "donation_history" => $donationHistory
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "No donation history found for this donor."
    ]);
}

// Close the statement
mysqli_stmt_close($stmt);
?>
