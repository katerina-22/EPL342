<?php
session_start(); // Start the session

// Check if the user is logged in
if (!isset($_SESSION['username']) || !isset($_SESSION['email'])) {
    header("Location: login.html");
    exit();
}

// Retrieve user and application data
$username = $_SESSION['username'];
$email = $_SESSION['email'];
$applications = isset($_SESSION['application']) ? $_SESSION['application'] : [];

// Debugging: Uncomment the following line to view session data during testing
// echo "<pre>"; print_r($applications); echo "</pre>";
?>

<!DOCTYPE html>
<html lang="en">
<div class="ax-home-page">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AX Home Page</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="logo">AX Portal</div>
        <ul>
            <li><a href="#welcome-section">Welcome</a></li>
            <li><a href="#submit-application-section">Submit Application</a></li>
            <li><a href="#my-applications-section">My Applications</a></li>
            <li><a href="#profile-section">Profile</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </nav>

    <!-- Container -->
    <div class="container">
        <!-- Welcome Section -->
        <div class="form-container welcome-section" id="welcome-section">
            <h1>Welcome, <span id="welcome-username">
                <?php echo htmlspecialchars($username); ?>
                </span>!</h1>
            <p>Apply for grants and track your application status here.</p>
        </div>

        <!-- Submit Application Section -->
        <div class="form-container sign-up" id="submit-application-section">
            <form method="POST" action="submit_application.php">
                <h1>Submit Application</h1>
                <span>Fill in the details below</span>

                <!-- Application Type -->
                <div class="form-group">
                    <label for="applicationType">Application Type:</label>
                    <select id="applicationType" name="applicationType" required>
                        <option value="" disabled selected>Select Application Type</option>
                        <option value="Type1">Γ1</option>
                        <option value="Type1">Γ2</option>
                        <option value="Type1">Γ3</option>
                        <option value="Type1">Γ4</option>
                        <option value="Type1">Γ5</option>
                        <option value="Type1">Γ6</option>
                        <option value="Type1">Γ7</option>
                        <option value="Type1">Γ8</option>
                        <option value="Type1">Γ10</option>
                        <option value="Type1">Γ11</option>
                        <option value="Type1">Γ12</option>
                        <option value="Type1">Γ13</option>
                        <option value="Type1">Γ14</option>
                    </select>
                </div>

                <!-- Application Details -->
                <div class="form-group">
                    <label for="details">Application Details:</label>
                    <textarea id="details" name="details" rows="5" placeholder="Enter details about your application..." required></textarea>
                </div>

                <button type="submit">Submit Application</button>
            </form>
        </div>

        <!-- My Applications Section -->
        <div class="form-container sign-in" id="my-applications-section">
            <h1>My Applications</h1>
            <table class="applications-table">
                <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Submitted On</th>
                    </tr>
                </thead>
                <tbody>
                   <? php print_r($applications);
                   ?>
                </tbody>
            </table>
        </div>

        <!-- Profile Section -->
        <div class="form-container profile-section" id="profile-section">
            <h1>My Profile</h1>
            <p><strong>Username:</strong> <span id="username">
                <?php echo htmlspecialchars($username); ?>
            </span></p>
            <p><strong>Email:</strong> <span id="email">
                <?php echo htmlspecialchars($email); ?>
            </span></p>
            <a href="logout.php" class="logout-link">Logout</a>
        </div>
    </div>
</body>
</div>
</html>