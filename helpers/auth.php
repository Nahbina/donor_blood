<?php
function getUserId($CON, $token)
{
    $sql = "SELECT * FROM personal_access_token WHERE token = '$token'";
    $result = mysqli_query($CON, $sql);
    if (!$result) {
        // Error handling if query fails
        return null;
    }
    $num = mysqli_num_rows($result);
    if ($num == 0) {
        return null;
    } else {
        $row = mysqli_fetch_assoc($result);
        return $row['user_id'];
    }
}


function isAdmin($CON, $token)
{
    $userId = getUserId($CON, $token);
    if ($userId == null) {
        return false;
    }
    $sql = "SELECT * FROM users WHERE user_id = '$userId' AND role = 'admin'";
    $result = mysqli_query($CON, $sql);
    if (!$result) {
        // Error handling if query fails
        return false;
    }
    $row = mysqli_fetch_assoc($result);
    return $row ? true : false;
}
?>

