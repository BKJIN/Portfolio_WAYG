<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#roader.none {
	display: none;
}

#roader.active {
	display: block;
	z-index: 9999999999999;
	opacity: 50%;
	background-color: black;
	position: absolute;
	top: 0; left: 0;
	width: 100%;
	height: 100%;
}

#roader img {
	position: fixed;
	top: 50%; left: 50%;
	width: 100px;
}
</style>
</head>
<body>
<div id="roader" class="none">
	<img src="/init/images/ajax_loader4.gif" />
</div>
</body>
</html>