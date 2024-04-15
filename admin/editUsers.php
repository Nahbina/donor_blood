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
    $user_id = $_POST['user_id'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $full_name = $_POST['full_name'] ?? '';

    // Validate input data
    if (empty($user_id)) {
        echo json_encode([
            "success" => false,
            "message" => "User ID is required"
        ]);
        exit;
    }

    // Check if the user exists
    $user_check_sql = "SELECT * FROM users WHERE user_id = ?";
    $user_check_stmt = mysqli_prepare($CON, $user_check_sql);
    mysqli_stmt_bind_param($user_check_stmt, "i", $user_id);
    mysqli_stmt_execute($user_check_stmt);
    $user_check_result = mysqli_stmt_get_result($user_check_stmt);

    if (!$user_check_result || mysqli_num_rows($user_check_result) === 0) {
        echo json_encode([
            "success" => false,
            "message" => "User not found"
        ]);
        exit;
    }

    // Update user data
    $update_sql = "UPDATE users SET";
    $params = [];

    if (!empty($email)) {
        $update_sql .= " email = ?,";
        $params[] = $email;
    }

    if (!empty($password)) {
        $update_sql .= " password = ?,";
        $encrypted_password = password_hash($password, PASSWORD_DEFAULT);
        $params[] = $encrypted_password;
    }

    if (!empty($full_name)) {
        $update_sql .= " full_name = ?,";
        $params[] = $full_name;
    }

    // Remove trailing comma from the update SQL
    $update_sql = rtrim($update_sql, ',');

    $update_sql .= " WHERE user_id = ?";
    $params[] = $user_id;

    // Execute the update query
    $stmt = mysqli_prepare($CON, $update_sql);
    // Dynamically bind parameters based on their types
    $types = str_repeat('s', count($params) - 1) . 'i';
    mysqli_stmt_bind_param($stmt, $types, ...$params);
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "User updated successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to update user"
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
