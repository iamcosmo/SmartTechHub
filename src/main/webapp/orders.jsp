<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Orders</title>
    <link rel="stylesheet" type="text/css" href="styl.css" />
</head>
<%
    String userName = (String)session.getAttribute("userName");
    String userEmail = (String)session.getAttribute("userEmail");
    boolean isLoggedIn = (userName != null && !userName.isEmpty());
%>
<body>
    <header>
        <h1>Your Orders</h1>
    </header>
    <nav>
        <ul>
            <li><a href="./index.jsp">Home</a></li>
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
    <div id="order-container">
        <% 
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "SYSTEM";
            String password = "1234";

            try {
                String userId = (String) session.getAttribute("userEmail");

                // Load the JDBC driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // Establish a connection
                Connection con = DriverManager.getConnection(url, username, password);

                PreparedStatement selectStmt = con.prepareStatement("SELECT * FROM user_orders WHERE userid = ?");
                selectStmt.setString(1, userEmail);
                ResultSet resultSet = selectStmt.executeQuery();   
				
                if (request.getMethod().equals("POST")) {
                    String productIdString = request.getParameter("productId");
                    int productId = Integer.parseInt(productIdString);

                    // Check the quantity in the user_orders table
                    String checkQuantityQuery = "SELECT qty FROM user_orders WHERE userid = ? AND prodid = ?";
                    PreparedStatement checkQuantityStmt = con.prepareStatement(checkQuantityQuery);
                    checkQuantityStmt.setString(1, userEmail);
                    checkQuantityStmt.setInt(2, productId);
                    ResultSet quantityResult = checkQuantityStmt.executeQuery();

                    int currentQuantity = 0;
                    if (quantityResult.next()) {
                        currentQuantity = quantityResult.getInt("qty");
                    }

                    // If the quantity is greater than 1, decrease it by 1
                    if (currentQuantity > 1) {
                        String updateQuantityQuery = "UPDATE user_orders SET qty = ? WHERE userid = ? AND prodid = ?";
                        PreparedStatement updateQuantityStmt = con.prepareStatement(updateQuantityQuery);
                        updateQuantityStmt.setInt(1, currentQuantity - 1);
                        updateQuantityStmt.setString(2, userEmail);
                        updateQuantityStmt.setInt(3, productId);
                        updateQuantityStmt.executeUpdate();
                    } else {
                        // If the quantity is 1, delete the order
                        String deleteOrderQuery = "DELETE FROM user_orders WHERE userid = ? AND prodid = ?";
                        PreparedStatement deleteOrderStmt = con.prepareStatement(deleteOrderQuery);
                        deleteOrderStmt.setString(1, userEmail);
                        deleteOrderStmt.setInt(2, productId);
                        deleteOrderStmt.executeUpdate();
                    }  
                    checkQuantityStmt.close();
                    quantityResult.close();
                    // Redirect to the same page to refresh the order view
                    response.sendRedirect(request.getContextPath() + "/orders.jsp");
                }
                // Display the fetched order details
                while (resultSet.next()) {
        %>
                    <div class='order-item'>
                        <img src='<%= resultSet.getString("img") %>' alt='<%= resultSet.getString("item_name") %>'>
                        <div class='order-details'>
                            <p><strong>Product:</strong> <%= resultSet.getString("item_name") %></p>
                            <p><strong>Price:</strong> Rs.<%= resultSet.getDouble("price") %></p>
                            <p><strong>Quantity:</strong> <%= resultSet.getInt("qty") %></p>
                            <form action='<%= request.getContextPath() %>/orders.jsp' method='post' id='deleteForm'>
                                <input type='hidden' name='productId' value='<%= resultSet.getInt("prodid") %>'>
                                <input type='submit' value='Delete'>
                            </form>
                        </div>
                    </div>
        <%
                }

                // Close the resources
                resultSet.close();
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
</body>
</html>
