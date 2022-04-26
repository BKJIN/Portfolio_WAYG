<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta id="_csrf" name="_csrf" content="${_csrf.token }">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<link rel="stylesheet" type="text/css" href="css/notice_board.css" />
<title>WAYG</title>

</head>

<body>
<%@ include file="../includes/header.jsp" %>


<div id="main" class="container">

	<div class="d-flex justify-content-between">
		<h3 class="display-4 font-italic"><i class="fa-solid fa-bullhorn"></i></h3>
		<s:authorize access="hasRole('ROLE_ADMIN')">
			<a href="notice_board/write_view" id="write" class="btn btn-sm btn-dark float-right mt-5">글작성</a>
		</s:authorize>
	</div>
	<hr />
	
	<table id="searchTable" class="table table-hover text-center">
		<thead>
			<tr class="row mx-0">
				<th class="col-1">번호</th>
				<th class="col-2">작성자</th>
				<th class="col-4">제목</th>
				<th class="col-3">날짜</th>
				<th class="col-2">조회수</th>
			</tr>
		</thead>
		
		<tbody>
			<c:forEach items="${boardList}" var="dto">
				<tr class="row mx-0">
					<td id="bid" class="col-1">${dto.bId}</td>
					<td class="col-2">WAYG ADMIN</td>
					<td class="col-4">
						<a href="notice_board/contentView?bId=${dto.bId}" class="content_view text-dark">${dto.bTitle}</a>
					</td>
					<td class="col-3">
						<fmt:formatDate var="bDate" pattern="yyyy-MM-dd hh:mm:ss" value="${dto.bDate}" />
						${bDate}
					</td>
					<td class="col-2">${dto.bHit}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<hr />
	
</div>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/login_modal.jsp" %>
</body>
</html>
