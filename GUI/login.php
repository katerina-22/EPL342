<?php
session_start(); // Start the session

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    // Redirect to login page if accessed without POST method
    header("Location: login.html");
    exit();
}

// Retrieve username and password from POST request
$username = trim($_POST['username']);
$password = trim($_POST['password']);

// Database connection details
$servername = "mssql.cs.ucy.ac.cy";
$dbUsername = "ccleri02";
$dbPassword = "adsBjAZX";
$dbName = "ccleri02";

// Connection options
$connectionOptions = [
    "Database" => $dbName,
    "Uid" => $dbUsername,
    "PWD" => $dbPassword
];

// Establish connection
$conn = sqlsrv_connect($servername, $connectionOptions);

if ($conn === false) {
    error_log(print_r(sqlsrv_errors(), true)); // Log errors securely
    die("Connection failed. Please try again later.");
}

// Query to validate user and retrieve ID
$sql = "SELECT ID, Permission, Email FROM [USER] WHERE Username = ? AND Password = ?";
$params = [$username, $password];
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt === false) {
    error_log(print_r(sqlsrv_errors(), true)); // Log errors securely
    die("An error occurred. Please try again later.");
}

// Check if user exists
if (sqlsrv_has_rows($stmt)) {
    $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
    $userId = $row['ID'];
    $permission = $row['Permission'];
    $email = $row['Email'];

    // Save user details in the session
    $_SESSION['username'] = $username;
    $_SESSION['email'] = $email;
    $_SESSION['permission'] = $permission;

    // Query to fetch all applications for the user
    $appSql = "SELECT ID, CATEGORY_NUMBER, Status, DATE FROM APPLICATION WHERE ID = ?";
    $appParams = [$userId];
    $appStmt = sqlsrv_query($conn, $appSql, $appParams);

    if ($appStmt === false) {
        error_log(print_r(sqlsrv_errors(), true)); // Log errors securely
        die("An error occurred while fetching applications. Please try again later.");
    }

    // Fetch all rows
    $applications = [];
    while ($appRow = sqlsrv_fetch_array($appStmt, SQLSRV_FETCH_ASSOC)) {
        $applications[] = $appRow; // Append each application to the array
    }

    // Store all application data in the session
    $_SESSION['application'] = $applications;

    // Redirect based on permission and application data
    $userPages = [
        "AX" => "AX_HomePage.php",
        "AA" => "AA_HomePage.php",
        "LT" => "LT_HomePage.php",
        // Greek categories
        "ΑΧ" => "AX_HomePage.php",
        "ΑΑ" => "AA_HomePage.php",
        "ΛΤ" => "LT_HomePage.php"
    ];

    if (!empty($applications)) {
        // Redirect to the application-specific page if it exists
        $firstApp = $applications[0];
        if (isset($firstApp['Page']) && !empty($firstApp['Page'])) {
            header("Location: " . $firstApp['Page']);
            exit();
        }
    }

    // Fallback: Redirect to permission-based pages
    if (array_key_exists($permission, $userPages)) {
        header("Location: " . $userPages[$permission]);
        exit();
    } else {
        echo "<script>alert('No page found for your category!');</script>";
        echo "<script>window.location.href = 'login.html';</script>";
    }
} else {
    echo "<script>alert('Invalid username or password!');</script>";
    echo "<script>window.location.href = 'login.html';</script>";
}

// Free resources and close connection
sqlsrv_free_stmt($stmt);
sqlsrv_free_stmt($appStmt);
sqlsrv_close($conn);
?>