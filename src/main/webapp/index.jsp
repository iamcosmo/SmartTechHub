<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SmartTechHub-JSP</title>
<link rel="stylesheet" type="text/css" href="styl.css" />
</head>
<body>
<%
    String userName = (String)session.getAttribute("userName");
    String userEmail = (String)session.getAttribute("userEmail");
    boolean isLoggedIn = (userName != null && !userName.isEmpty());
%>
<header>
        <h1>Smart Tech Hub</h1>
</header>
    <nav>
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Category</a></li>
            <% if (isLoggedIn) { %>
            <li><a href="<%= request.getContextPath() %>/orders.jsp">Orders</a></li>
        <% } %>
            <li><a href="#" id="wishlistLink" class="inactive">WishList</a></li>
        </ul>
        <% if (session.getAttribute("userName") != null) { %>
        <button id="accountBtn"><%= userName%></button>
    <% } else { %>
        <button id="accountBtn">Account</button>
    <% } %>
    </nav>
     <div id="product-container">
        <% 
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
	        String username = "SYSTEM";
	    	String password = "1234";

            try {
                // Load the JDBC driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // Establish a connection
                Connection con = null;
                con = DriverManager.getConnection(url, username, password);

                // Create a statement
                Statement statement = con.createStatement();

                // Execute a query
                ResultSet resultSet = statement.executeQuery("SELECT * FROM smartphones");

                // Display the fetched data
                while (resultSet.next()) {
                    out.println("<div class='product'>");
                    out.println("<h3>" + resultSet.getString("model_name") + "</h3>");
                    out.println("<img src='" + resultSet.getString("img") + "' alt='" + resultSet.getString("model_name") + "' style='width: 200px; height: 280px;'>");
                    out.println("<p>Rs." + resultSet.getDouble("price") + "</p>");
                    out.println("<div class='product-buttons'>");
                    //out.println("<button onclick='addToCart(" + resultSet.getInt("id") + ")' class='button-style'>Add to Cart</button>");
                    if (isLoggedIn) {
                        out.println("<form action='" + request.getContextPath() + "/confirmorder.jsp' method='get'>");
                        out.println("<input type='submit' value='Add to Cart'>");
                        out.println("<input type='hidden' name='productId' value='" + resultSet.getInt("id") + "'>");
                        out.println("<input type='submit' value='Buy Now' class='button-style'>");
                        out.println("</form>");
                    } else {
                        // Display a message when the user clicks "Buy Now" and is not logged in
                        out.println("<button onclick='addToCart(" + resultSet.getInt("id") + ")' class='button-style'>Add to Cart</button>");
                        out.println("<button onclick='showLoginMessage()' class='button-style'>Buy Now</button>");
                    }
                    out.println("</div>");                
                    out.println("</div>");
                }

                // Close the resources
                resultSet.close();
                statement.close();
                con.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </div>
    <%
    // Add a script block for redirection based on login status
    if (isLoggedIn) {
%>
    <script>
        var accountBtn = document.getElementById("accountBtn");
        accountBtn.addEventListener("click", function() {
            // Redirect to the account.jsp page
            window.location.href = "./account.jsp";
        });
    </script>
<%
    } else {
%>
    <script>
        var accountBtn = document.getElementById("accountBtn");
        accountBtn.addEventListener("click", function() {
            // Redirect to the login page
            window.location.href = "./loginsingup.jsp";
        });
    </script>
<%
    }
%>
<script>
function showLoginMessage() {
    alert('Please log in to buy this item.');
}
</script>
</body>
</html>