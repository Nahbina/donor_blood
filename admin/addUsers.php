<?php
// Enable CORS
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";
include "../helpers/auth.php";

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Extract input data from the request body
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $full_name = $_POST['full_name'] ?? '';
    $role = $_POST['role'] ?? '';
    $user_id = $_POST['user_id'] ?? '';
    // Validate input data
    if (empty($email) || empty($password) || empty($full_name)|| empty($role) || empty($user_id)) {
        echo json_encode([
            "success" => false,
            "message" => "All fields are required"
        ]);
        exit;
    }

    // Validate email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            "success" => false,
            "message" => "Invalid email format"
        ]);
        exit;
    }

    // Hash the password securely
    $encrypted_password = password_hash($password, PASSWORD_DEFAULT);

    // Check if user with the provided email already exists
    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($result && mysqli_num_rows($result) > 0) {
        echo json_encode([
            "success" => false,
            "message" => "User with this email already exists"
        ]);
        exit;
    }

    // Insert new user into the database
    $sql = "INSERT INTO users (user_id, email, password, full_name, role) VALUES (?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "sssss", $user_id, $email, $encrypted_password, $full_name, $role);
    
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "User added successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to add user"
        ]);
    }
} else {
    // Invalid request method
    echo json_encode([
        "success" => false,
        "message" => "Only POST method is allowed"
    ]);
}
?>
