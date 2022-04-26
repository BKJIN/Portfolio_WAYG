<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="/init/css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="/init/css/main.css" />
<link rel="stylesheet" type="text/css" href="/init/css/includes/footer.css" />

<style type="text/css">
.pageDiv{
	text-align: center;

}
.notice{
	margin-top: 5%;
	font-family: cursive;
}
.errorImg{
	width: 60%;
}
.errorHome{
	font-size: 300%;
}
a{
	color: black;
}

</style>
<title>Index</title>

</head>

<body>

<%@ include file="../includes/header.jsp" %>
<section class="container mb-4 ">
	<div class="pageDiv">
		<a href="/init"><img class="errorImg" src="/init/images/500page.png"></a>
	</div>

</section>

<%@ include file="../includes/footer.jsp" %>





</body>
</html>