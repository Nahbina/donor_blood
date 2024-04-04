<!-- <?php

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

// Retrieve the user's blood donation requests
$sql = "SELECT blood_requests.*, users.full_name AS donor_name FROM blood_requests JOIN users ON blood_requests.donor_id = users.user_id WHERE blood_requests.user_id = ?";
$stmt = mysqli_prepare($CON, $sql);
mysqli_stmt_bind_param($stmt, "i", $userId);
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
        "message" => "You have no blood donation requests.",
        "requests" => []
    ]);
} else {
    echo json_encode([
        "success" => true,
        "message" => "Blood donation requests fetched successfully!",
        "requests" => $requests
    ]);
}

mysqli_close($CON);
?> -->
