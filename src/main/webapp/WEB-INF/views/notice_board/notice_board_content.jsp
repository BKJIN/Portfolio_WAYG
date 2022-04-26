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
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<link rel="stylesheet" type="text/css" href="../css/notice_board.css" />
<script src="../js/notice_board.js"></script>
<title>WAYG</title>
</head>

<body>

<%@ include file="../includes/header.jsp" %>

<div id="main" class="container">
	<h3 class="display-4 font-italic"><i class="fa-solid fa-bullhorn"></i></h3>
	<hr />
	
	<form action="modify?bId=${content_view.bId}" method="post" class="mb-4" id="frm">
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
		
		<div class="form-group d-none">
			<label for="uId">content#</label>
			<input type="text" class="form-control col-9 ml-3" id="uId" name="bId" value="${content_view.bId}" readonly/>
		</div>

		<hr />

		<div class="form-group row mx-0">
			<label for="title"  class="col-2 mt-2"><strong>Title</strong></label>
			<input type="text" class="form-control col-9 ml-3" id="title" name="bTitle" value="${content_view.bTitle }"/>
		</div>
		
		<hr />
		
		<div class="form-group row mx-0">
			<label for="uname" class="col-2 mt-2"><strong>Writer</strong></label>
			<input type="text" class="form-control col-9 ml-3" id="uname" name="bName" value="WAYG ADMIN" readonly/>
		</div>
		
		<hr />
		
		<div class="form-group row mx-0">
			<label for="hit" class="col-2 mt-2"><strong>Views</strong></label>
			<input type="text" class="form-control col-9 ml-3" id="hit" name="bHit" value="${content_view.bHit}" readonly/>
		</div>

		<hr />

		<div class="form-group row mx-0">
			<label for="content" class="col-2 mt-2 mb-4"><strong>Content</strong></label>
			<textarea class="form-control col-9 ml-3" id="content" name="bContent" rows="10">${content_view.bContent }</textarea>
		</div>
		
		<hr />
		
		<a href="../notice_board" id="goback" class="btn btn-sm btn-secondary">목록</a>	
		<s:authorize access="hasRole('ROLE_ADMIN')">
			<a href="delete?bId=${content_view.bId}" id="delBtn" class="btn btn-sm btn-danger float-right mr-2">삭제</a>
			<button type="submit" id="modDoBtn" class="btn btn-sm btn-success d-none float-right mr-2">수정</button>
			<a href="" id="modBtn" class="btn btn-sm btn-success float-right mr-2">수정</a>
		</s:authorize>
	</form>
</div>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/login_modal.jsp" %>
<script>

</script>

</body>
</html>