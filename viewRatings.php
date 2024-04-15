<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods:POST");
header("Access-Control-Allow-Headers: Content-Type");

include "./database/database_connection.php"; // Include your database connection file
include "./helpers/auth.php";

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

// Extract the token from the request
$token = $_POST['token'];

// Validate the token and retrieve the user ID
$user_id = getUserId($CON, $token);
if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "Unauthorized access!"
    ]);
    die();
}

// Query to select ratings along with user information
$sql = "SELECT ratings.*, users.full_name, users.email 
        FROM ratings 
        INNER JOIN users ON ratings.user_id = users.user_id";

$result = mysqli_query($CON, $sql);

if ($result) {
    $ratings = [];
    // Fetch each row from the result set and store it in an array
    while ($row = mysqli_fetch_assoc($result)) {
        $ratings[] = $row;
    }

    // Return the ratings data as JSON
    echo json_encode([
        "success" => true,
        "ratings" => $ratings
    ]);
} else {
    // If the query fails, return an error message
    echo json_encode([
        "success" => false,
        "message" => "Failed to fetch ratings from the database"
    ]);
}

// Close the database connection
mysqli_close($CON);
?>
