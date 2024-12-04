<?php
// login.php
session_start(); // Start the session

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Retrieve username and password from POST request
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Database connection details
    $servername = "mssql.cs.ucy.ac.cy";
    $dbUsername = "canton05";
    $dbPassword = "zBUMVpE4";
    $dbName = "canton05";

    // Connection options
    $connectionOptions = [
        "Database" => $dbName,
        "Uid" => $dbUsername,
        "PWD" => $dbPassword
    ];

    // Establish connection
    $conn = sqlsrv_connect($servername, $connectionOptions);

    if ($conn === false) {
        die(print_r(sqlsrv_errors(), true)); // Display detailed error message
    }

    // Prepare and execute the query
    $sql = "SELECT Permission FROM [USER] WHERE Username = ? AND Password = ?";
    $params = [$username, $password];
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die(print_r(sqlsrv_errors(), true));
    }

    // Check results
    if (sqlsrv_has_rows($stmt)) {
        $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
        $permission = $row['Permission'];

        //
        // Store user info in the session
        $_SESSION['username'] = $row['Username'];
        $_SESSION['email'] = $row['Email'];
        $_SESSION['permission'] = $permission;
        //

        // Map user categories to pages
        $userPages = [
            "ΑΧ" => "AX_HomePage.html",
            "ΑΑ" => "AA_HomePage.html",
            "ΛΤ" => "LT_HomePage.html"
        ];

        // Redirect to the appropriate page
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
    sqlsrv_close($conn);
} else {
    // Handle non-POST requests
    http_response_code(405);
    echo "Method Not Allowed";
}
?>