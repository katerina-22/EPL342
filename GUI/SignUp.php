<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'] ?? '';
    $phone = $_POST['phone_number'] ?? '';
    $birthdate = $_POST['birthdate'] ?? '';
    $address = $_POST['address'] ?? '';
    $type = $_POST['role_type'] ?? '';
    $unique_id = $_POST['id'] ?? '';
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    // Database credentials
    $serverName = "mssql.cs.ucy.ac.cy"; // Replace with your server name
    $connectionOptions = [
        "Database" => "canton05",      // Replace with your database name
        "Uid" => "canton05",           // Replace with your username
        "PWD" => "zBUMVpE4"            // Replace with your password
    ];

    // Establish database connection
    $conn = sqlsrv_connect($serverName, $connectionOptions);

    // Check connection
    if ($conn === false) {
        die("Connection failed: " . print_r(sqlsrv_errors(), true));
    }

    // Check if the username or unique ID is already registered
    $sql = "SELECT * FROM [user] WHERE username = ? OR id = ?";
    $params = [$username, $unique_id];
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("Query failed: " . print_r(sqlsrv_errors(), true));
    }

    if (sqlsrv_has_rows($stmt)) {
        echo "Username or Unique ID is already taken. Please try again.";
        sqlsrv_free_stmt($stmt);
        sqlsrv_close($conn);
        exit();
    }

    sqlsrv_free_stmt($stmt);

    // Hash the password for security
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Insert the new user into the database
    $sqlInsert = "INSERT INTO [user] ([name], [phone_number], [birthdate], [address], [role_type], [id], [username], [password]) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $params = [$name, $phone, $birthdate, $address, $type, $unique_id, $username, $hashedPassword];
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("Error inserting data: " . print_r(sqlsrv_errors(), true));
    }

    echo "Registration successful! You can now <a href='login.html'>login</a>.";

    // Free statement and close connection
    sqlsrv_free_stmt($stmt);
    sqlsrv_close($conn);
} else {
    http_response_code(405);
    echo 'Method Not Allowed';
}
?>