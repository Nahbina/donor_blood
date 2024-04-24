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

$token = $_POST['token'];

// Extract user ID from the token
$userId = getUserId($CON, $token);

// Check if user ID is valid
if (!$userId) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid user ID"
    ]);
    die();
}

// Check if user is authenticated and an admin
if (!isAdmin($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if required form fields are set
if (isset($_POST['blood_type'], $_POST['birth_date'], $_POST['last_donation_date'], $_POST['phoneNumber'], $_POST['Address'])) {
    $blood_type = $_POST['blood_type'];
    $birth_date = $_POST['birth_date'];
    $last_donation_date = $_POST['last_donation_date'];
    $phoneNumber = $_POST['phoneNumber'];
    $Address = $_POST['Address'];

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

    // Update donor information excluding avatar
    $sql = "UPDATE donors SET blood_type = ?, birth_date = ?, last_donation_date = ?, phoneNumber = ?, Address = ? WHERE donor_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "sssssi", $blood_type, $birth_date, $last_donation_date, $phoneNumber, $Address, $donor_id);

    // Execute the prepared statement
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "Donor information updated successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to update donor information: " . mysqli_error($CON)
        ]);
    }

    // Close the statement
    mysqli_stmt_close($stmt);
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required form fields are not set"
    ]);
}
?>
