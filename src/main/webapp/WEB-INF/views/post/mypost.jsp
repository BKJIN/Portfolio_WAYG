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
<%-- csrf beforesend 이용을 위한 header setting --%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="../css/post/mypost.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/feed/feed_calendar.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
<script>
var email = '<c:out value="${user.userEmail}" />';
</script>
<script src="../js/post/mypost.js"></script>
<style>
#profile-img {
	overflow: hidden;
}

#profile-img img {
	max-width: 100%;
	min-height: 100%;
}

pre.header-bio {
	overflow: auto;
}

</style>


</head>

<body>
<c:set var="totalCount" value="${list.size()}" />
<c:set var="rowCount" value="${totalCount / 4}" />
<c:set var="lastRow" value="${Math.floor(rowCount) }" />

<%@ include file="../includes/header.jsp" %>

<section class="container mb-5">
	<%-- section-header --%>
	<div class="body-container">
		<%-- 1. 유저 프로필 (프로필 이미지, 정보)--%>
		<div id="feed-header" class="d-flex justify-content-start border-bottom row mx-0 flex-nowrap">
			<%-- 1- 프로필 이미지 --%>
			<div id="profile-img" class="p-3 ml-4 bg-body col-2 text-center">
				<c:choose>
					<c:when test="${fn:contains(user.userProfileImg, 'nulluser.svg')}">
						<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle" />
					</c:when>
							
					<c:otherwise>
						<img src="/init/resources/profileImg/${user.userProfileImg }" class="rounded-circle" />
					</c:otherwise>
				</c:choose>
			</div>
			
			<%-- 2- 유저정보2 =  --%>
			<div id="profile-right" class="p-3 bg-body col-9 d-block">
				<div class="row mx-0 d-flex justify-content-around">
					<div class="col-5 text-center">
						<b>일정</b>
						<br />
						<span id="planCount">${planCount }</span>
					</div>
					
					<div class="col-5 text-center">
						<b>포스트</b>
						<br />
						<span id="postCount">${postCount }</span>
					</div>
				</div>
				
				<hr />
							
				<div class="text-left">
					<pre class="ml-3">${user.userProfileMsg }</pre>
				</div>
			</div>
		</div>

		<%-- 2. 피드 탭 메뉴 --%>		
		<ul class="feed-tabs row mx-0 flex-nowrap">
			<%-- 1- 캘린더 피드 버튼 --%>
			<li id="feed-calendar" class='nav-item col-3' data-tab=''>
				<a href="../feed" class="nav-link">
					<i class="fa-regular fa-calendar-check"></i>
				</a>
			</li>
			
			<%-- 2- 맵 피드 버튼 --%>
			<li id="feed-map" class='nav-item col-3' data-tab=''>
				<a href="../feed/feedMap" class="nav-link">
					<i class="fa-solid fa-map-location-dot"></i>
				</a>
			</li>
		
			<%-- 3- 포스트 피드 버튼 --%>			
			<li id="feed-post" class='nav-item active col-3' data-tab=''>
				<a href="../post/mypost" class="nav-link">
					<i class="fa-solid fa-images"></i>
				</a>
			</li>
			
			<%-- 4- 유저 정보 피드 버튼 --%>			
			<li id="feed-info" class='nav-item col-3' data-tab=''>
				<a href="../feed/feedInfo" class="nav-link">
					<i class="fa-solid fa-gear"></i>
				</a>
			</li>
		</ul>

		<%-- section-body --%>
		<div class="d-flex justify-content-between mt-5" id="main-body">
			<div id="feedPost" class="col-12">
				<div id="postBox">
				<c:choose>
					<c:when test="${rowCount > 0 && rowCount <= 1}">
						<div class="posts mt-2">
							<c:forEach items="${list}" var="post">
								<div class="post mr-2" data-value="${post.postNo}">
									<div class="post-top border rounded">
										<img class="titleimg" src="../images/${post.titleImage}"/>
									</div>
								</div>
							</c:forEach>
						</div>		
					</c:when>
					
					
					<c:when test="${rowCount > 1}">
						<c:forEach begin="0" end="${lastRow}" var="row">
								<c:choose>
									<c:when test="${row < lastRow}">
										<div class="posts mt-2">
											<c:forEach begin="${(row*4) }" end="${((row+1)*4) - 1}" var="index">
												<div class="post mr-2"  data-value="${list.get(index).postNo}">
													<div class="post-top border rounded">
														<img class="titleimg" src="../images/${list[index].titleImage}"/>
													</div>
												</div>
											</c:forEach>
										</div>
									</c:when>
									
									<c:otherwise>
										<c:if test="${rowCount > lastRow}">
											<div class="posts mt-2">
											<c:forEach begin="${row*4 }" end="${totalCount - 1}" var="index">
												<div class="post mr-2"  data-value="${list.get(index).postNo}">
													<div class="post-top border rounded">
														<img class="titleimg" src="images/${list.get(index).titleImage}"/>
													</div>
												</div>
											</c:forEach>
											</div>
										</c:if>
									</c:otherwise>
								</c:choose>
						</c:forEach>
					</c:when>
					
					<c:when test="${totalCount == 0 }">
						<div class="mt-5">
							<h1 class="display-4 text-center">
								<i class="fa-regular fa-face-dizzy text-warning"></i>
							</h1>
			
							<p class="display-4 text-center font-italic" style="font-size: 35px; font-weight: 500;">아직 작성된 포스트가 없습니다.</p>
						</div>
						<br />
						<hr />
					</c:when>
				</c:choose>
				
				</div>
			
				<c:if test="${ lastRow >= 3 }">
					<button type="button" class="btn btn-dark mt-3" data-currIndex="0" data-maxindex="${Math.floor(rowCount/3)}" id="moreBtn">더보기</button>
				</c:if>
				
			</div>
			
		</div>
	</div>
</section>

<%@ include file="../includes/modalPost.jsp" %>
<%@ include file="../includes/footer.jsp" %>
<script>
</script>

</body>
</html>