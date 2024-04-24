<?php

header("Access-Control-Allow-Origin: *");

// Allow the following methods from any origin
header("Access-Control-Allow-Methods: POST");

// Allow the following headers from any origin
header("Access-Control-Allow-Headers: Content-Type");

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

// Extract the token from the request
$token = $_POST['token'];

// Check if the user associated with the token is authenticated and authorized to view blood requests
$userId = getUserId($CON, $token);
if (!$userId) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Prepare and execute SQL query to retrieve blood donation requests sent by the user
$sql = "SELECT br.request_id, br.status, br.request_date, u.full_name AS donor_name, u.email AS donor_email
        FROM blood_requests br
        INNER JOIN users u ON br.donor_id = u.user_id
        WHERE br.user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $userId);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);

// Check if there are any requests
if (mysqli_stmt_num_rows($stmt) > 0) {
    // Bind result variables
    mysqli_stmt_bind_result($stmt, $requestId, $status, $requestDate, $donorName, $donorEmail);
    
    // Fetch results and store in an array
    $requests = array();
    while (mysqli_stmt_fetch($stmt)) {
        $request = array(
            "request_id" => $requestId,
            "status" => $status,
            "request_date" => $requestDate,
            "donor_name" => $donorName,
            "donor_email" => $donorEmail
        );
        $requests[] = $request;
    }
    
    // Close the statement
    mysqli_stmt_close($stmt);
    
    // Return the requests as JSON response
    echo json_encode([
        "success" => true,
        "requests" => $requests
    ]);
} else {
    // No requests found
    echo json_encode([
        "success" => true,
        "message" => "No blood donation requests found for the user."
    ]);
}

?>
