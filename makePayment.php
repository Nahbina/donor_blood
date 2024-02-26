<?php
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

// Include database connection
include "./database/database_connection.php";

include "./helpers/auth.php";

$token = $_POST['token'];
$user_id = getUserId($CON,$token);


if (isset($_POST['user_id'], $_POST['amount'], $_POST['details'])) {
    global $CON;
    $user_id = $_POST['user_id'];
    $amount = $_POST['amount'];
    $details = $_POST['details'];

    $sql = "select * from payment where user_id = $user_id";
    $result = mysqli_query($CON, $sql);

    if (mysqli_num_rows($result) > 0) {
        echo json_encode([
            "success" => false,
            "message" => "Payment already made, thank you!"
        ]);
        die();
    }

    $sql = "insert into payment (user_id, amount, details) values ('$user_id', '$amount', '$details')";
    $result = mysqli_query($CON, $sql);

    if (!$result) {
        echo json_encode([
            "success" => false,
            "message" => "Something went wrong"
        ]);
    } else {
        echo json_encode([
            "success" => true,
            "message" => "Payment made successfully!"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "userId, amount and details are required!"
    ]);
    die();
}
