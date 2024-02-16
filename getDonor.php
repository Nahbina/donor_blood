<?php

if (!isset($_POST['token'])) {
    echo json_encode([
        "success" => false,
        "message" => "Token not found!"
    ]);
    die();
}

include "./database/connection.php";
include "./helpers/auth.php";

$token = $_POST['token'];

// if (!isRecepient($token)) {
//     echo json_encode([
//         "success" => false,
//         "message" => "You are not authorized!"
//     ]);
//     die();
// }

global $CON;

if (isset($_POST['DonorName'], $_POST['phoneNumber'], $_POST['blood_type'], $_FILES['address'], $_POST['avatar'],)) {

    $name = $_POST['DonorName'];
    $phoneNumber = $_POST['phoneNumber'];
    $blood_type = $_POST['blood_type'];
    $address = $_POST['address'];
    $avatar = $_FILES['avatar'];
   
    $avatar_name = $avatar['name'];
    $avatar_tmp_name = $avatar['tmp_name'];
    $avatar_size = $avatar['size'];

    // $hospital_Id = getUserId($token);

    $ext = pathinfo($avatar_name, PATHINFO_EXTENSION);

    if ($ext != "jpg" && $ext != "jfif" && $ext != "png") {
        echo json_encode([
            "success" => false,
            "message" => "Only image files are allowed!"
        ]);
        die();
    }

    if ($avatar_size > 1000000) {
        echo json_encode([
            "success" => false,
            "message" => "Image size should be less than 1MB!"
        ]);
        die();
    }

    $avatar_name = uniqid() . "." . $ext;

    if (!move_uploaded_file($avatar_tmp_name, "./images/" . $avatar_name)) {
        echo json_encode([
            "success" => false,
            "message" => "Image upload failed!"
        ]);
        die();
    }





    $sql = "INSERT INTO donors (DonorName, phoneNumber, blood_type, address, avatar) VALUES ('$name', '$phone_Name','$blood_type '$address', '$user_id', 'images/$avatar_name' )";

    $result = mysqli_query($CON, $sql);

    if (!$result) {
        echo json_encode([
            "success" => false,
            "message" => "Donor not added!"
        ]);
        die();
    } else {
        echo json_encode([
            "success" => true,
            "message" => "Donor added successfully!"
        ]);
        die();
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "name, phone_Number, blood_type, address, avatar are required!"
    ]);
    die();
}
