<?php
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
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

// Check if the user associated with the token is authenticated and authorized to delete donors
if (!getUserId($CON, $token) || !isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if donor ID is provided in the request
if (!isset($_POST['donor_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "Donor ID not provided!"
    ]);
    die();
}

// Extract donor ID from the request
$donor_id = $_POST["donor_id"];

// Check if there are any related records in the blood_requests table
$sql_check_requests = "SELECT COUNT(*) FROM blood_requests WHERE donor_id = ?";
$stmt_check_requests = mysqli_prepare($CON, $sql_check_requests);
mysqli_stmt_bind_param($stmt_check_requests, "i", $donor_id);
mysqli_stmt_execute($stmt_check_requests);
mysqli_stmt_bind_result($stmt_check_requests, $request_count);
mysqli_stmt_fetch($stmt_check_requests);

// Close the statement
mysqli_stmt_close($stmt_check_requests);

if ($request_count > 0) {
    // Inform the user that the donor cannot be deleted due to associated blood donation requests
    echo json_encode([
        "success" => false,
        "message" => "Cannot delete donor. There are associated blood donation requests."
    ]);
} else {
    // Delete donor data from the database
    $sql = "DELETE FROM donors WHERE donor_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $donor_id); // Corrected binding parameter
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "Donor deleted successfully!"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to delete donor!"
        ]);
    }

    // Close the statement
    mysqli_stmt_close($stmt);
}
