<?php
session_start(); // Start the session

// Check if the user is logged in
if (!isset($_SESSION['username']) || !isset($_SESSION['email'])) {
    // Redirect to the login page if not logged in
    header("Location: login.html");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
    <div class="lt-home-page">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LT Home Page</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <script>
        // Client-side validation for better user experience
        function validateCheckApplicationForm() {
            const applicationId = document.getElementById("applicationId").value.trim();
            const comments = document.getElementById("comments").value.trim();

            if (applicationId === "") {
                alert("Please enter an Application ID.");
                return false;
            }

            if (comments.length < 10) {
                alert("Comments must be at least 10 characters long.");
                return false;
            }

            return true;
        }

        function validateDocumentUpload() {
            const fileInput = document.getElementById("file");
            if (!fileInput.files.length) {
                alert("Please select a file to upload.");
                return false;
            }
            return true;
        }
    </script>
 
</head>

<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="logo">LT Portal</div>
        <ul>
            <li><a href="#welcome-section">Welcome</a></li>
            <li><a href="#manage-orders-section">Manage Orders</a></li>
            <li><a href="#upload-documents-section">Upload Documents</a></li>
            <li><a href="#submitted-orders-section">Submitted Orders</a></li>
            <li><a href="#profile-section">Profile</a></li>
            <li><a href="login.html">Logout</a></li>
        </ul>
    </nav>

    <!-- Container -->
    <div class="container">
        <!-- Welcome Section -->
        <div class="form-container welcome-section" id="welcome-section">
           <!-- <h1>Welcome, Car Dealer!</h1> -->
            <h1>Welcome, <span id="welcome-username">
                <?php echo htmlspecialchars($_SESSION['username']); ?>
                </span>!</h1>
            <p>Manage your vehicle orders and upload required documents here.</p>
        </div>

        <!-- Manage Orders Section -->
        <div class="form-container sign-up" id="manage-orders-section">
            <form method="POST" action="manage_orders.php" onsubmit="return validateOrderForm()">
                <h1>Manage Orders</h1>
                <span>View, create, or update vehicle orders</span>

                <!-- Order Type -->
                <div class="form-group">
                    <label for="orderType">Order Type:</label>
                    <select id="orderType" name="orderType" required>
                        <option value="" disabled selected>Select Order Type</option>
                        <option value="New">New Order</option>
                        <option value="Update">Update Existing Order</option>
                        <option value="Cancel">Cancel Order</option>
                    </select>
                </div>

                <!-- Order Details -->
                <div class="form-group">
                    <label for="orderDetails">Order Details:</label>
                    <textarea id="orderDetails" name="orderDetails" rows="5" placeholder="Enter details about the order..." required></textarea>
                </div>

                <button type="submit">Submit Order</button>
            </form>
        </div>

        <!-- Upload Documents Section -->
        <div class="form-container sign-in" id="upload-documents-section">
            <h1>Upload Documents</h1>
            <form method="POST" action="upload_documents.php" enctype="multipart/form-data" onsubmit="return validateDocumentUpload()">
                <!-- Document Type -->
                <div class="form-group">
                    <label for="documentType">Document Type:</label>
                    <select id="documentType" name="documentType" required>
                        <option value="" disabled selected>Select Document Type</option>
                        <option value="Invoice">Invoice</option>
                        <option value="Vehicle Registration">Vehicle Registration</option>
                        <option value="Warranty">Warranty Document</option>
                    </select>
                </div>

                <!-- File Upload -->
                <div class="form-group">
                    <label for="file">Choose File:</label>
                    <input type="file" id="file" name="file" required>
                </div>

                <button type="submit">Upload Document</button>
            </form>
        </div>

        <!-- View Submitted Orders Section -->
        <div class="form-container profile-section" id="submitted-orders-section">
            <h1>Submitted Orders</h1>
            <table class="applications-table">
                 <!-- Collumns -->
                <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Submitted On</th>
                    </tr>
                </thead>
                <tbody>
                   <!-- db -->
                </tbody>
            </table>
        </div>

        <!-- Profile Section -->
        <div class="form-container profile-section" id="profile-section">
            <h1>My Profile</h1>
            <!-- Changing Loading... into the users info -->
            <p><strong>Username:</strong> <span id="username">
                <?php echo htmlspecialchars($_SESSION['username']); ?>
            </span></p>
            <p><strong>Email:</strong> <span id="email">
                <?php echo htmlspecialchars($_SESSION['email']); ?>
            </span></p>
            <a href="login.html" class="logout-link">Logout</a>
        </div>            
    </div>
</body>
</div>
</html>