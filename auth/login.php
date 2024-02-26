<?php
// Enable CORS
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");

include "../database/database_connection.php";

session_start(); // Start the session

if (isset($_POST['email'], $_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($result) {
        if (mysqli_num_rows($result) == 0) {
            echo json_encode([
                "success" => false,
                "message" => "User does not exist!"
            ]);
            die();
        }

        $row = mysqli_fetch_assoc($result);
        $hashed_password = $row['password'];

        if (!password_verify($password, $hashed_password)) {
            echo json_encode([
                "success" => false,
                "message" => "Incorrect email or password!"
            ]);
            die();
        }

        // Generate a secure random token
        $token = bin2hex(random_bytes(32));
        $userId = $row['user_id'];
        $role = $row['role'];

        // Store the token in the database
        $sql = "INSERT INTO personal_access_token (user_id, token) VALUES (?, ?)";
        $stmt = mysqli_prepare($CON, $sql);
        mysqli_stmt_bind_param($stmt, "ss", $userId, $token);
        $result = mysqli_stmt_execute($stmt);

        if ($result) {
            // Set session variables
            $_SESSION['user_id'] = $userId;
            $_SESSION['role'] = $role;

            echo json_encode([
                "success" => true,
                "message" => "User logged in successfully!",
                "token" => $token,
                "role" => $role
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "User login failed!"
            ]);
        }
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Something went wrong!"
        ]);
        die();
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Email and password are required!"
    ]);
}

// Close the session
session_write_close();
?>
