<?php
// Enable CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");


include "../database/database_connection.php";

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Query to select all users
    $sql = "SELECT * FROM users";
    $result = mysqli_query($CON, $sql);

    if ($result) {
        $users = [];

        // Fetch each user and add to the users array
        while ($row = mysqli_fetch_assoc($result)) {
            $users[] = $row;
        }

        // Return the list of users as JSON response
        echo json_encode([
            "success" => true,
            "users" => $users
        ]);
    } else {
        // Failed to execute query
        echo json_encode([
            "success" => false,
            "message" => "Failed to fetch users"
        ]);
    }
} else {
    // Invalid request method
    echo json_encode([
        "success" => false,
        "message" => "Not allowed"
    ]);
}
?>
