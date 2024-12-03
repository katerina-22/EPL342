# EPL342
# **Portal for Road Transport, Vehicle Dealers, and Users**

## **Overview**
This project is a web-based system designed to cater to the needs of three types of users:
1. **Road Transport Department Officers (LT):** Manage and verify applications related to road transport.
2. **Car Dealers (AA):** Submit and manage vehicle orders and upload required documents.
3. **Regular Users (AX):** Apply for grants and track their application status.

The system includes user registration, login, and tailored dashboards for each user type.

---

## **Technologies Used**
1. **Frontend:**
   - HTML5, CSS3
   - JavaScript 

2. **Backend:**
   - PHP for server-side logic

3. **Database:**
   - MySQL for data storage and management

4. **SQL Files Included:**
   - `Create_Table.sql` – Contains SQL queries for table creation.
   - `Alter_Table.sql` – Contains queries for table modifications.
   - `USER.sql` – Contains user-related queries.
   - `APPLICATION.sql` – Application-related SQL queries.
   - `VEHICLE_ORDER.sql` – Vehicle order SQL queries.
   - `DOCUMENTS.sql` – Document upload SQL queries.

---

## **Features**
### **1. User Roles**
- **LT (Road Transport Department Officers):**
  - Verify applications.
  - View uploaded supporting documents.
  - Access a profile section.

- **AA (Car Dealers):**
  - Submit and manage vehicle orders.
  - Upload necessary documents (e.g., invoices, registrations).
  - View submitted orders.

- **AX (Regular Users):**
  - Submit applications for grants.
  - Track application statuses.
  - Manage personal profiles.

---

### **2. Authentication**
- **Sign Up:**
  - Users can register by providing details such as name, phone, birthdate, address, user type (AX/AA/LT), and a unique ID.
- **Login:**
  - Secure login functionality with username and password.
- **Logout:**
  - Ensures secure session handling.

---

### **3. Navigation**
Each user role is provided with an intuitive navigation bar that:
- Links to their respective sections.
- Includes a "Logout" option.

---

## **File Descriptions**
### **HTML Files**
- `SignUp.html`: User registration form for all user roles.
- `login.html`: Login page with options for redirection.
- `AA_HomePage.html`: Dashboard for car dealers.
- `AX_HomePage.html`: Dashboard for regular users.
- `LT_HomePage.html`: Dashboard for road transport department officers.

### **PHP Files**
- `SignUp.php`: Handles registration logic.
- `login.php`: Processes user login.
- `logout.php`: Handles user logout securely.

### **CSS Files**
- `style.css`: Provides styling for all pages, including navigation, forms, and dashboards.

---

## **Database**
### **Tables**
1. **USER:** Stores user details (username, password, type, etc.).
2. **VEHICLES:** Stores vehicle data.
3. **VEHICLE_ORDER:** Handles vehicle orders submitted by dealers.
4. **APPLICATION:** Tracks applications submitted by regular users.
5. **DOCUMENTS:** Stores details of uploaded documents.
6. **CRITERIA_FOR_VALIDATION:** Validation rules for applications.
7. **SUBSIDY_CATEGORIES:** Different subsidy types available.

### **SQL Scripts**
- **`Create_Table.sql`**: Creates the database structure.
- **`Alter_Table.sql`**: Modifications and updates to the schema.
- **`Insert_Into.sql`**: Contains sample data inserts for testing.

---

## **Setup Instructions**
1. **Prerequisites:**
   - Install a web server (e.g., XAMPP, WAMP) with PHP and MySQL.
   - A browser to access the portal.

2. **Steps:**
   - Clone or download the project files into the web server's root directory.
   - Import the provided SQL scripts into MySQL.
   - Update database credentials in the PHP files (if necessary).
   - Launch the application in a browser via `localhost`.

---

## **Contributors**
This project was developed for managing and automating tasks related to road transport, car dealerships, and user services. Further contributions are welcome!

--- 