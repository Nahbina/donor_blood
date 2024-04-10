<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include "./database/database_connection.php";
include "./helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

if (!getUserId($CON, $token)) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

if (isset($_POST['user_id'], $_POST['rating'], $_POST['created_at'])) {
    $user_id = $_POST["user_id"];
    $rating = $_POST["rating"];
    $created_at = $_POST["created_at"];
 
    $sql = "INSERT INTO ratings (user_id, rating, created_at) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "iis", $user_id, $rating, $created_at);

    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "Rating inserted successfully!"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to insert rating!"
        ]);
    }

    mysqli_stmt_close($stmt);
} else {
    echo json_encode([
        "success" => false,
        "message" => "All required rating details are not set"
    ]);
}
?>
