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
        "message" => "User is already a donor"
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
if (isset($_POST['user_id'], $_POST['blood_type'], $_POST['birth_date'], $_POST['last_donation_date'], $_FILES['avatar'], $_POST['phoneNumber'])) {
    // $full_name = $_POST['full_name'];
    $user_id = $_POST['user_id'];
    $blood_type = $_POST['blood_type'];
    $birth_date = $_POST['birth_date'];
    $last_donation_date = $_POST['last_donation_date'];
    $avatar = $_FILES['avatar'];
    $phoneNumber = $_POST['phoneNumber'];
    $avatar_name = $avatar['name'];
    $avatar_tmp_name = $avatar['tmp_name'];
    $avatar_size = $avatar['size'];
    $ext = pathinfo($avatar_name, PATHINFO_EXTENSION);

    // Validate file type and size
    if (!in_array($ext, ["jpg", "jfif", "png"])) {
        echo json_encode([
            "success" => false,
            "message" => "Only image files (jpg, jfif, png) are allowed!"
        ]);
        die();
    }
    if ($avatar_size > 1000000) {
        echo json_encode([
            "success" => false,
            "message" => "Image size should be less than 10MB!"
        ]);
        die();
    }

    // Move uploaded file to the images directory
    $avatar_name = uniqid() . "." . $ext;
    if (!move_uploaded_file($avatar_tmp_name, "./images/" . $avatar_name)) {
        echo json_encode([
            "success" => false,
            "message" => "Image upload failed!"
        ]);
        die();
    }

    // Insert user as donor into the database using prepared statement
    $avatar_path = "images/" . $avatar_name; // Concatenate the folder name with the file name
    $sql = "INSERT INTO donors (user_id, blood_type, birth_date, last_donation_date, avatar, phoneNumber) VALUES ( ?, ?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "sissss", $user_id, $blood_type, $birth_date, $last_donation_date, $avatar_path, $phoneNumber);
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "User became a donor successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to become a donor"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required form fields are not set"
    ]);
}
?>
