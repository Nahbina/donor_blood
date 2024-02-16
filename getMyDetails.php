<?php

include "./database/database_connection.php";
include "./helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$user_id = getUserId($CON, $_POST['token']);

$sql = "SELECT user_id, email, full_name, role, address FROM users WHERE user_id = '$user_id'";

$result = mysqli_query($CON, $sql);

if ($result) {
    $user = mysqli_fetch_assoc($result);

    echo json_encode([
        "success" => true,
        "message" => "User details fetched successfully!",
        "user" => $user
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Something went wrong!"
    ]);
}
?>
