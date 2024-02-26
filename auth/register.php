<?php
// Enable CORS
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");
// header("Access-Control-Allow-Origin: http://localhost:54427");
// header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
// header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";

// Check if required fields are set
if (isset($_POST['email'], $_POST['password'], $_POST['fullname'])) {
    // Extract input data
    $email = $_POST['email'];
    $password = $_POST['password'];
    $fullname = $_POST['fullname'];

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
            "message" => "User already exists!"
        ]);
        exit;
    }

    // Insert new user into the database
    $sql = "INSERT INTO users (email, password, full_name, role) VALUES (?, ?, ?, 'user')";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "sss", $email, $encrypted_password, $fullname);
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "User registered successfully!"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "User registration failed!"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Email, password, and fullname are required"
    ]);
}
?>
