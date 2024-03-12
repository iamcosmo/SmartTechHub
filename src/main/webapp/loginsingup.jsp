<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Tech Hub</title>
    <link rel="stylesheet" type="text/css" href="styl.css" />
</head>
<body>
<%
    // JDBC connection parameters
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "SYSTEM";
    String password = "1234";

    try {
        // Load the JDBC driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establish the connection
        Connection con = null;
        con = DriverManager.getConnection(url, username, password);

        // Check if the form is submitted
        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("login") != null) {
            String email = request.getParameter("email");
            String enteredPassword = request.getParameter("password");

            // Validate user during login
            PreparedStatement loginStatement = con.prepareStatement("SELECT * FROM userdata WHERE email = ? AND password = ? ");
            loginStatement.setString(1, email);
            loginStatement.setString(2, enteredPassword);

            ResultSet loginResult = loginStatement.executeQuery();

            if (loginResult.next()) {
                // User exists, perform login actions
                String userName = loginResult.getString("name");
				String userPhone = loginResult.getString("phoneno");
				String userAddrs = loginResult.getString("address");
				String userGender = loginResult.getString("gender");
                // Store user details in session attributes
                session.setAttribute("userName", userName);
                session.setAttribute("userEmail", email);
                session.setAttribute("userPhone", userPhone);
                session.setAttribute("userGender", userGender);
                session.setAttribute("userAddrs", userAddrs);
                
                
                response.sendRedirect("./index.jsp");
            } else {
                out.println("Invalid email or password. Please try again.");
            }

            loginResult.close();
            loginStatement.close();
        }

        // Check if the form is submitted for signup
        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("signup") != null) {
            // Get user data from the form
            String name = request.getParameter("nameN");
            String email = request.getParameter("emailN");
            String gender = request.getParameter("genderN");
            String phoneNo = request.getParameter("phonenoN");
            String address = request.getParameter("addressN");
            String password2 = request.getParameter("passwordN");
            String confirmPassword = request.getParameter("confirmPassword");

            // Insert new user during signup
            if (password2.equals(confirmPassword)) {
                PreparedStatement signupStatement = con.prepareStatement("INSERT INTO userdata (name, email, password, address, gender, phoneno) VALUES (?, ?, ?, ?, ?, ?)");
                signupStatement.setString(1, name);
                signupStatement.setString(2, email);
                signupStatement.setString(3, password2);
                signupStatement.setString(4, address);
                signupStatement.setString(5, gender);
                signupStatement.setString(6, phoneNo);

                int rowsAffected = signupStatement.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("Signup successful!");
                    response.sendRedirect("./index.jsp");
                } else {
                    out.println("Signup failed. Please try again.");
                    response.sendRedirect("./index.jsp");
                }

                signupStatement.close();
            } else {
                out.println("Passwords do not match. Please try again.");
            }
        }

        // Close the connection
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred. Please try again later.");
    }
%>
<header>
    <h1>Smart Tech Hub</h1>
</header>
<nav>
    <ul>
        <li><a href="./index.jsp">Home</a></li>
        <li><a href="#">Category</a></li>
        <li><a href="#" id="wishlistLink" class="inactive">Wishlist</a></li>
    </ul>
    <% if (session.getAttribute("userName") != null) { %>
        <button id="accountBtn"><%= session.getAttribute("userName") %></button>
    <% } else { %>
        <button id="accountBtn">Account</button>
    <% } %>
</nav>
<div class="login-container">
    <div id="loginForm">
        <form method="post" action="">
            <h2>Login</h2>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required />

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required />

            <button type="submit" name="login">Login</button>
            <br>
            <p id="signupLink" style="cursor: pointer; color: blue;">Don't have an account? Sign up here!</p>
        </form>
    </div>
    <div id="signupForm" style="display: none;">
        <form method="post" action="">
            <h2>Sign Up</h2>
            <label for="nameN">Name:</label>
            <input type="text" id="nameN" name="nameN" required /><br />

            <label for="emailN">Email:</label>
            <input type="email" id="emailN" name="emailN" required /><br />

            <label for="genderN">Gender:</label>
            <input type="text" id="genderN" name="genderN" required /><br />

            <label for="phonenoN">Phone No:</label>
            <input type="text" id="phonenoN" name="phonenoN" required /><br />

            <label for="addressN">Address:</label>
            <input type="text" id="addressN" name="addressN" required /><br />

            <label for="passwordN">Password:</label>
            <input type="password" id="passwordN" name="passwordN" required /><br />

            <label for="confirmPassword">Confirm Password:</label>
            <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                required
            /><br />

            <button type="submit" name="signup">Sign Up</button>
            <br>
            <p id="loginLink" style="cursor: pointer; color: blue;">Already have an account? Login here!</p>
        </form>
    </div>
</div>
<script src="toggle.js"></script>
</body>
</html>
