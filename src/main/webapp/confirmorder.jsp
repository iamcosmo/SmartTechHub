<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Order</title>
    <link rel="stylesheet" type="text/css" href="styl.css" />
</head>
<body>
    <header>
        <h1>Smart Tech Hub</h1>
    </header>
    
    <div id="confirm-order-container">
        <% 
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "SYSTEM";
            String password = "1234";

            try {
                String productIdString = request.getParameter("productId");
                int productId = Integer.parseInt(productIdString);

                // Load the JDBC driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // Establish a connection
                Connection con = DriverManager.getConnection(url, username, password);

                PreparedStatement selectStmt = con.prepareStatement("SELECT * FROM smartphones WHERE id = ?");
                selectStmt.setInt(1, productId);
                ResultSet resultSet = selectStmt.executeQuery();
               

                // Display the fetched data
                if (resultSet.next()) {
        %>
                    <div class='product-details'>
                        <h3><%= resultSet.getString("model_name") %></h3>
                        <img src='<%= resultSet.getString("img") %>' alt='<%= resultSet.getString("model_name") %>' style='width: 200px; height: 280px;'>
                        <p>Rs.<%= resultSet.getDouble("price") %></p>
                        <form action="<%= request.getContextPath() %>/confirmorder.jsp" method="post">
                            <label for="quantity">Select Quantity:</label>
                            <select id="quantity" name="quantity">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <option value="<%= i %>"><%= i %></option>
                                <% } %>
                            </select>
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="submit" value="Confirm Order" id="confirm-order-btn">
                        </form>
                        <form action="<%= request.getContextPath() %>/index.jsp" method="post">
					        <input type="submit" value="Cancel Order">
					    </form>
                    </div>
        <%
                    // Check if the form is submitted
                    if (request.getMethod().equals("POST")) {
                        // Get form data
                        String quantityString = request.getParameter("quantity");
                        int quantity = Integer.parseInt(quantityString);

                        // Get user information (You might need to modify this based on your session attribute names)
                        String userId = (String)session.getAttribute("userEmail");

                        // Insert order into user_orders table
                        PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM user_orders WHERE userid = ? AND prodid = ?");
				        checkStmt.setString(1, userId);
				        checkStmt.setInt(2, productId);
				        ResultSet checkResult = checkStmt.executeQuery();
						
				        int rowsAffected=0;
				        if (checkResult.next()) {
				            // Row exists, update the quantity
				            int existingQty = checkResult.getInt("qty");
				            int newQty = existingQty + quantity;

				            // Update the quantity
				            PreparedStatement updateStmt = con.prepareStatement("UPDATE user_orders SET qty = ? WHERE userid = ? AND prodid = ?");
				            updateStmt.setInt(1, newQty);
				            updateStmt.setString(2, userId);
				            updateStmt.setInt(3, productId);
				            rowsAffected=updateStmt.executeUpdate();
							updateStmt.close();
				            //out.println("Order placed successfully! Updated quantity for existing item.");
				        } else {
				            // Row doesn't exist, insert a new row
				            PreparedStatement insertStmt = con.prepareStatement("INSERT INTO user_orders (userid, prodid, item_name, price, img, qty) VALUES (?, ?, ?, ?, ?, ?)");
				            insertStmt.setString(1, userId);
				            insertStmt.setInt(2, productId);
				            insertStmt.setString(3, resultSet.getString("model_name"));
				            insertStmt.setDouble(4, resultSet.getDouble("price"));
				            insertStmt.setString(5, resultSet.getString("img"));
				            insertStmt.setInt(6, quantity);
				            rowsAffected= insertStmt.executeUpdate();
				            insertStmt.close();
				            //out.println("Order placed successfully! New item added.");
				        }
                        
                        

                        // Close the resources
                        

                        if (rowsAffected > 0) {
        %>
                            <div class="confirmation-message">
                                <p>Order Confirmed Successfully!</p>
                            </div>
                            <script>
                                // Redirect to index.jsp after 3 seconds
                                setTimeout(function(){
                                    window.location.href = "<%= request.getContextPath() %>/index.jsp";
                                }, 1500);
                            </script>
        <%
                        } else {
        %>
                            <div class="error-message">
                                <p>Error placing order. Please try again.</p>
                            </div>
        <%
                        }
                        checkResult.close();
                        checkStmt.close();

                    }
                }
                
                // Close the resources
                resultSet.close();
                //statement.close();
                con.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </div>
</body>
</html>
