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

// Get user ID associated with the token
$userId = getUserId($CON, $token);
if ($userId === null) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Check if the user associated with the token is an admin
$isAdmin = isAdmin($CON, $token);
if (!$isAdmin) {
    // Check if the user associated with the token is a donor
    $isDonor = isDonor($CON, $token);
    if (!$isDonor) {
        echo json_encode([
            "success" => false,
            "message" => "User is not a donor or admin."
        ]);
        die();
    }
}

// If the user is an admin, there's no need to fetch a donor ID
if (!$isAdmin) {
    // Fetch donor ID based on user ID
    $donorId = getDonorId($CON, $userId);

    if ($donorId === null) {
        echo json_encode([
            "success" => false,
            "message" => "Donor ID not found."
        ]);
        die();
    }
}

// Fetch donation history based on donor ID (if applicable)
if (!$isAdmin) {
    $sql = "SELECT donation_history.*, users.full_name AS requester_name, users.email AS requester_email
            FROM donation_history 
            INNER JOIN blood_requests ON donation_history.request_id = blood_requests.request_id
            INNER JOIN users ON blood_requests.user_id = users.user_id
            WHERE donation_history.donor_id = ?"; 
    $stmt = mysqli_prepare($CON, $sql);

    // Bind parameter and execute the statement
    mysqli_stmt_bind_param($stmt, "i", $donorId);
    mysqli_stmt_execute($stmt);

    // Get result
    $result = mysqli_stmt_get_result($stmt);

    // Check if there are any records
    if (mysqli_num_rows($result) > 0) {
        // Fetch and return donation history
        $donationHistory = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode([
            "success" => true,
            "donation_history" => $donationHistory
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "No donation history found for this donor."
        ]);
    }

    // Close the statement
    mysqli_stmt_close($stmt);
} else {
    // Fetch donation history for all donors (admin view)
    $sql = "SELECT donation_history.*, users.full_name AS requester_name, users.email AS requester_email
            FROM donation_history 
            INNER JOIN blood_requests ON donation_history.request_id = blood_requests.request_id
            INNER JOIN users ON blood_requests.user_id = users.user_id"; 
    $result = mysqli_query($CON, $sql);

    if ($result) {
        // Fetch and return donation history
        $donationHistory = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode([
            "success" => true,
            "donation_history" => $donationHistory
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to fetch donation history."
        ]);
    }
}

// Function to retrieve the donor ID associated with the user ID
function getDonorId($con, $userId) {
    $sql = "SELECT donor_id FROM donors WHERE user_id = ?";
    $stmt = mysqli_prepare($con, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    mysqli_stmt_bind_result($stmt, $donorId);
    mysqli_stmt_fetch($stmt);
    mysqli_stmt_close($stmt);
    return $donorId;
}

?>
