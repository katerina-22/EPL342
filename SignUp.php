<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'] ?? '';
    $phone = $_POST['phone'] ?? '';
    $birthdate = $_POST['birthdate'] ?? '';
    $address = $_POST['address'] ?? '';
    $type = $_POST['type'] ?? '';
    $unique_id = $_POST['unique_id'] ?? '';
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    // Simulate user storage (Replace with database code)
    $usersFile = 'users.json';
    $users = file_exists($usersFile) ? json_decode(file_get_contents($usersFile), true) : [];

    // Check if the username or unique ID is already registered
    foreach ($users as $user) {
        if ($user['username'] === $username || $user['unique_id'] === $unique_id) {
            echo "Username or Unique ID is already taken. Please try again.";
            exit();
        }
    }

    // Hash the password for security
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Add new user to the users array
    $users[] = [
        'name' => $name,
        'phone' => $phone,
        'birthdate' => $birthdate,
        'address' => $address,
        'type' => $type,
        'unique_id' => $unique_id,
        'username' => $username,
        'password' => $hashedPassword
    ];

    // Save users back to the file
    file_put_contents($usersFile, json_encode($users));

    echo "Registration successful! You can now <a href='login.html'>login</a>.";
} else {
    http_response_code(405);
    echo 'Method Not Allowed';
}
?>
