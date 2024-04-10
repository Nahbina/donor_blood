<?php

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

include "./database/database_connection.php";
include "./helpers/auth.php";

$token = $_POST['token'];
$user_id = getUserId($CON, $token);

if (isset($_POST['amount'], $_POST['details'])) {
    global $CON;
    $amount = $_POST['amount'];
    $details = $_POST['details'];

    $sql = "INSERT INTO payment (user_id, amount, details, payment_date, status) 
            VALUES ('$user_id', '$amount', '$details', CURRENT_TIMESTAMP, 'Pending')";
    $result = mysqli_query($CON, $sql);

    if (!$result) {
        echo json_encode([
            "success" => false,
            "message" => "Something went wrong"
        ]);
    } else {
        // Assuming the payment was successful, update the payment status to 'Completed'
        $payment_id = mysqli_insert_id($CON); // Get the ID of the newly inserted payment
        $update_sql = "UPDATE payment SET status = 'Completed' WHERE payment_id = $payment_id";
        $update_result = mysqli_query($CON, $update_sql);

        if ($update_result) {
            echo json_encode([
                "success" => true,
                "message" => "Payment made successfully!"
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Failed to update payment status"
            ]);
        }
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Amount and details are required!"
    ]);
    die();
}
?>
