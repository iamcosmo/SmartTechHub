<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <link rel="stylesheet" type="text/css" href="styl.css" />
</head>
<body>

<%
    // Clear session attributes
    session.removeAttribute("userName");
    session.removeAttribute("userEmail");
    session.removeAttribute("userAddrs");
    session.removeAttribute("userGender");

    // Invalidate the session
    session.invalidate();
%>

<h2>You have been successfully logged out.</h2>
<p>Redirecting to the home page...</p>

<script>
    setTimeout(function(){
        window.location.href = "<%= request.getContextPath() %>/index.jsp";
    }, 2000); // Redirect after 3 seconds
</script>

</body>
</html>
