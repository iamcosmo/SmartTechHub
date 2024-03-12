<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
            <li><a href="./index.jsp">Home</a></li>
            <li><a href="#">Category</a></li>
            <% if (isLoggedIn) { %>
            <li><a href="<%= request.getContextPath() %>/orders.jsp">Orders</a></li>
        <% } %>
            <li><a href="#" id="wishlistLink" class="inactive">Wishlist</a></li>
        </ul>
        <% if (session.getAttribute("userName") != null) { %>
            <button><%= session.getAttribute("userName") %></button>
        <% } else { %>
            <button>Account</button>
        <% } %>
    </nav>

    <div class="user-details">
        <h2>User Information</h2>
        <p><strong>Name:</strong> <%= session.getAttribute("userName") %></p>
        <p><strong>Email:</strong> <%= session.getAttribute("userEmail") %></p>
        <p><strong>Phone No:</strong> <%= session.getAttribute("userPhone") %></p>
        <p><strong>Address:</strong> <%= session.getAttribute("userAddrs") %></p>
        <p><strong>Gender:</strong> <%= session.getAttribute("userGender") %></p>       
        
    </div>
    <div class="logout-container">
    <form action="./logout.jsp" method="post">
        <input type="submit" value="Logout">
    </form>
	</div>

</body>
</html>