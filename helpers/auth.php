<?php
// Get user ID associated with the token
function getUserId($CON, $token)
{
    $sql = "SELECT user_id FROM personal_access_token WHERE token = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "s", $token);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    if (!$result) {
        // Error handling if query fails
        return null;
    }
    $row = mysqli_fetch_assoc($result);
    return $row['user_id'] ?? null;
}

// Check if the user is an admin
function isAdmin($CON, $token)
{
    $userId = getUserId($CON, $token);
    if ($userId == null) {
        return false;
    }
    $sql = "SELECT * FROM users WHERE user_id = ? AND role = 'admin'";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    if (!$result) {
        // Error handling if query fails
        return false;
    }
    $row = mysqli_fetch_assoc($result);
    return $row ? true : false;
}

// Check if the user is a donor
function isDonor($CON, $token)
{
    $userId = getUserId($CON, $token);
    if ($userId == null) {
        return false;
    }
    $sql = "SELECT * FROM donors WHERE user_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    if (!$result) {
        // Error handling if query fails
        return false;
    }
    return mysqli_num_rows($result) > 0;
}

// Check if the user is a recipient
function isRecipient($CON, $token)
{
    $userId = getUserId($CON, $token);
    if ($userId == null) {
        return false;
    }
    $sql = "SELECT * FROM blood_donation_requests WHERE user_id = ?";
    $stmt = mysqli_prepare($CON, $sql);
    mysqli_stmt_bind_param($stmt, "i", $userId);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    if (!$result) {
        // Error handling if query fails
        return false;
    }
    return mysqli_num_rows($result) > 0;
}
?>
