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

// Check if the user associated with the token is authenticated and authorized to become a donor
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
        "message" => "User has already send request"
    ]);
    die();
}

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

// Check if required form fields are set
if (isset($_POST['user_id'], $_POST['blood_type'], $_POST['location'], $_POST['mobile_Number'],$_POST['Age'], $_POST['case_Details'], $_POST['status'])) {
    // $full_name = $_POST['full_name'];
    $user_id = $_POST['user_id'];
    $Age = $_POST['Age'];
    $blood_type = $_POST['blood_type'];
    $location = $_POST['location'];
    $mobile_Number = $_POST['mobile_Number'];
  
    $case_Details = $_POST['case_Details'];
  
    $status = $_POST['status'];

    $sql = "INSERT INTO blood_donation_requests (user_id, blood_type, location, mobile_Number, Age, case_Details, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "sisssss", $user_id, $blood_type, $location, $mobile_Number,$Age, $case_Details, $status);
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "User request successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to send request"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required form fields are not set"
    ]);
}
?>
