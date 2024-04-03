<?php
if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

$token = $_POST['token'];

include "./database/database_connection.php";

// Include authentication helper functions
include "./helpers/auth.php";
include "./helpers/notify.php";

$user_id = getUserId($CON, $token);

if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid token!"
    ]);
    die();
}

// Find the request_id associated with the user
$sql = "SELECT request_id FROM blood_requests WHERE user_id='$user_id'";
$result = mysqli_query($CON, $sql);

if (!$result || mysqli_num_rows($result) == 0) {
    echo json_encode([
        "success" => false,
        "message" => "No requests found for this user!"
    ]);
    die();
}
$row = mysqli_fetch_assoc($result);
$requestId = $row['request_id'];

// Fetch notifications for the found request_id
$sql = "SELECT * FROM notifications WHERE request_id='$requestId' ORDER BY notification_id DESC";
$result = mysqli_query($CON, $sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch notifications!"
    ]);
    die();
}

$notifications = [];

while ($row = mysqli_fetch_assoc($result)) {
    $notifications[] = $row;
}

echo json_encode([
    "success" => true,
    "message" => "Notifications fetched successfully!",
    "notifications" => $notifications
]);
?>
