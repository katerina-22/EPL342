<?php
// login.php

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Retrieve the username and password from the POST request
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Simulated database of users and their credentials
    $users = [
        "ax_user" => "ax_pass",
        "aa_user" => "aa_pass",
        "lt_user" => "lt_pass"
    ];

    // Mapping of usernames to their respective homepages
    $userPages = [
        "ax_user" => "AX_HomePage.html",
        "aa_user" => "AA_HomePage.html",
        "lt_user" => "LT_HomePage.html"
    ];

    // Check if the username exists and the password matches
    if (array_key_exists($username, $users) && $users[$username] === $password) {
        // Redirect to the corresponding user's homepage
        header("Location: " . $userPages[$username]);
        exit();
    } else {
        // Invalid credentials
        echo "<script>alert('Invalid username or password!');</script>";
        echo "<script>window.location.href='login.html';</script>";
    }
} else {
    // Handle non-POST requests
    http_response_code(405);
    echo "Method Not Allowed";
}
?>
