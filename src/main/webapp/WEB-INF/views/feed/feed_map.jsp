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
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3&libraries=services,clusterer,drawing"></script>
<%-- page custom css files --%>
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/feed/feed_calendar.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
<style>
#map {
	width: 100%;
}

.labels {
	font-style: italic;
	font-weight: 500;
}

#filter-title {
	font-size: 40px;
	font-weight: 400;
}

span.required {
	color: orange;
	font-weight: 400;
}



.wrap {
	padding: 0;
	margin: 0;
	border-radius: 15px;
} 

.wrap .info {
	width: 350px;
	height: 150px;
	overflow: hidden;
	background: #fff;
	border-radius: 15px;
}

.wrap .info:nth-child(1) {
	border: 0;
	box-shadow: 0px 2px 5px #888;
}

.info .title {
	padding: 5px 0 0 5px;
	box-shadow: 0px 2px 1px #888;
	height: 25%;
	border-radius: 15px;
	font-size: 18px;
	font-weight: bold;
	color: white;
}

.info .body {
	position: relative;
	overflow: hidden;
}

.info .content {
	position: relative;
	margin: 13px 0 0 90px;
	height: 75%;
}

.content .info-theme,
.content .info-address,
.content .info-category,
.content .info-transportation,
.content .info-post {
	font-size: 13px;
	color: #888;
	margin-top: -2px;
}

.content .info-post {
	margin-top: 4px;
	color: white;
	width: 90%;
}

.info .img {
	margin: 20px 5px 0px 5px;
	position: absolute;
	width: 70px;
	height: 60px;
	color: #888;
	overflow: hidden;
}

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
<script src="../js/post/mypost.js"></script>
<script>
var email = '<c:out value="${user.userEmail}" />';

</script>

</head>

<body>
<%@ include file="../includes/header.jsp" %>
	<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.username" var="user_id" />
		<div id="user_id" style="display:none">${user_id}</div> <!-- 사용자의 Id값 가져오기, 필터에서 사용-->
	</sec:authorize>


<section class="container mb-5">
	<%-- section-header --%>
	<div class="body-container">
		<%-- 1. 유저 프로필 (프로필 이미지, 정보)--%>
		<div id="feed-header" class="d-flex justify-content-start border-bottom row mx-0 flex-nowrap">
			<%-- 1- 프로필 이미지 --%>
			<div id="profile-img" class="p-3 ml-4 bg-body col-2 text-center">
				<c:choose>
					<c:when test="${fn:contains(user.userProfileImg, 'nulluser.svg')}">
						<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle" alt="" />
					</c:when>
							
					<c:otherwise>
						<img src="/init/resources/profileImg/${user.userProfileImg }" class="rounded-circle" alt="" />
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
			<li id="feed-map" class='nav-item active col-3' data-tab=''>
				<a href="../feed/feedMap" class="nav-link">
					<i class="fa-solid fa-map-location-dot"></i>
				</a>
			</li>
		
			<%-- 3- 포스트 피드 버튼 --%>			
			<li id="feed-/post" class='nav-item col-3' data-tab=''>
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
		<div class="d-flex justify-content-between mt-5 row mx-0" id="main-body">
			<div id="map" class="border rounded p-3 col-9"></div>
			
			<div class="map-filter border rounded p-2 bg-light col-3"> <!-- 필터 생성 -->
				<form id="frm" name="frm" action="insertFilter" method="post">
					<div class="form-group">
						<label for="selbox" class="labels">&nbsp;Filter 1 <span class="required">*</span></label>
						<select id="selbox" class="main-filter custom-select my-1 mr-sm-2 labels" name="value3"> <!-- 메인 필터 select창 생성 -->
							<option>Select Filter</option>
							<option value="1">모두보기</option>
							<option value="category">장소</option>
							<option value="address">지역</option>
							<option value="transportation">이동수단</option>
							<option value="theme">테마</option>
						</select>
					</div>
					
					<div class="form-group">
						<label for="subSelBox" class="mt-2 labels">&nbsp;Filter 2 <span class="required">*</span></label>
						<select id="subSelBox" class="sub-filter custom-select my-1 mr-sm-2 labels" name="value4"> <!-- 서브 필터 select창 생성, option은 script에서 생성 -->
							<option>Select Detail Filter</option>
						</select>			 
					</div>	
							
					<div class="form-group">
						<!-- <label for="plandate">날짜</label> -->
						<label for="plandate" class="labels">&nbsp;Date</label>
						<input type="date" class="form-control labels" id="plandate" name="value2" value=""/> <!-- 날짜 선택 input 생성 -->
					</div>
					
					<div class="form-group d-flex justify-content-around mt-2 row mx-0">
						<button type="submit" id="filterbtn" class="btn btn-sm btn-success col-5 mr-2">
							<i class="fa-solid fa-magnifying-glass"></i>
						</button> <!-- 필터 제출 버튼 -->
						
						<button type="reset" id="filterResetbtn" class="btn btn-sm btn-danger col-5" >
							<i class="fa-solid fa-delete-left"></i>
						</button> <!-- 필터 초기화 버튼 -->
					</div>
				</form>
			</div>
			
			
		</div>
	</div>
</section>


<script src="../js/feed/feed_map.js"></script>
<%@ include file="../includes/modalPost.jsp" %>
</body>
</html>
