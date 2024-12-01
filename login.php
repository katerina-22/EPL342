<?php
// Start the session
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Simulate a database lookup for user type
    // Replace this with actual database query
    $userType = ""; // LT, AA, AX, based on username

    // Dummy user data for example
    if ($username === "lt_user" && $password === "lt_pass") {
        $userType = "LT";
    } elseif ($username === "aa_user" && $password === "aa_pass") {
        $userType = "AA";
    } elseif ($username === "ax_user" && $password === "ax_pass") {
        $userType = "AX";
    }

    if (!empty($userType)) {
        // Store user type in session
        $_SESSION['userType'] = $userType;

        // Redirect based on user type
        if ($userType === "LT") {
            header("Location: LT_HomePage.html");
        } elseif ($userType === "AA") {
            header("Location: AA_HomePage.html");
        } elseif ($userType === "AX") {
            header("Location: AX_HomePage.html");
        }
        exit();
    } else {
        // Handle invalid credentials
        echo "Invalid username or password.";
    }
} else {
    http_response_code(405);
    echo "Method Not Allowed";
}
?>
