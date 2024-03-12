<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Success Page</title>
</head>
<body>
    <h2>Login Successful!</h2>
    
    <% 
        // Check if the user is logged in
        String username = (String) session.getAttribute("username");
        if (username != null && !username.isEmpty()) {
    %>
        <p>Welcome, <%= username %>!</p>
        <form action="LogoutServlet" method="post">
            <input type="submit" value="Logout">
        </form>
    <%
        } else {
    %>
        <p>Invalid session. Please login again.</p>
    <%
        }
    %>
</body>
</html>
