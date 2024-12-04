<?php
session_start();

if (isset($_SESSION['user_id'])) {
    echo json_encode([
        "username" => $_SESSION['username'],
        "email" => $_SESSION['email'],
        "registered_on" => $_SESSION['registered_on']
    ]);
} else {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
}
?>
