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

$userId = getUserId($CON, $token);
if ($userId == null) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user is an admin
if (isAdmin($CON, $token)) {
    $sql = "SELECT * FROM blood_requests";
    $result = mysqli_query($CON, $sql);

    if (!$result) {
        echo json_encode([
            "success" => false,
            "message" => "Failed to fetch blood requests: " . mysqli_error($CON)
        ]);
        die();
    }

    $requests = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }

    if (empty($requests)) {
        echo json_encode([
            "success" => true,
            "message" => "No blood requests found.",
            "requests" => []
        ]);
    } else {
        echo json_encode([
            "success" => true,
            "message" => "Blood requests fetched successfully!",
            "requests" => $requests
        ]);
    }
} else {
    // Retrieve the donor ID
    $sql = "SELECT donor_id FROM donors WHERE user_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $row = mysqli_fetch_assoc($result);
    mysqli_stmt_close($stmt);

    if (!$row) {
        echo json_encode([
            "success" => false,
            "message" => "Donor ID not found for the user!"
        ]);
        die();
    }

    $donorId = $row['donor_id'];

    // Retrieve blood requests for the donor
    $sql = "SELECT * FROM blood_requests WHERE donor_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $donorId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $requests = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $requests[] = $row;
    }
    mysqli_stmt_close($stmt);

    if (empty($requests)) {
        echo json_encode([
            "success" => true,
            "message" => "No blood requests found for the donor.",
            "requests" => [],
            "donor_id" => $donorId
        ]);
    } else {
        echo json_encode([
            "success" => true,
            "message" => "Blood requests fetched successfully!",
            "requests" => $requests
        ]);
    }
}

mysqli_close($CON);
?>
