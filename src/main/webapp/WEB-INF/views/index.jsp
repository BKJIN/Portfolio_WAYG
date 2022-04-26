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
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="/init/css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="/init/css/main.css" />
<link rel="stylesheet" type="text/css" href="/init/css/includes/footer.css" />
<title>WAYG</title>
<style>
.profile-img {
	border-radius: 50%;
	overflow: hidden;
}
.profile-img img {
	max-width: 100%;
}
.post-top {
	max-height: 320px;
	line-height: 320px;
	overflow: hidden;
}

.post-top img {
	max-width: 100%;
}
.profile-box{
	height: 100%;
}
#post-profile {
	text-align: center;
	margin-left: 4px;
	border-radius: 50%;
	width: 35px;
	height: 35px;
	overflow: hidden;
}
#post-profile img {
	max-width: 100%;
	max-height: 100%;
}

</style>

<script>
<c:if test="${not empty user}">
	var email = '<c:out value="${user.userEmail}" />';
</c:if>
</script>
</head>

<body>
<%@ include file="includes/roader.jsp" %>
<%@ include file="includes/header.jsp" %>
<c:set var="profileImg" value="${user.userProfileImg}" />
<section class="container">
	<div class="main-body-top d-flex justify-content-between mb-3">
		<div id="map" class="map border rounded p-2"></div>
		<div class="right ml-2">
			<div class="user-info border rounded mb-2 p-1">
				<div class="user-info-top d-flex row mx-0">
					<s:authorize access="isAnonymous()">				
						<div class="profile-img col-3">
							<i class="user-info-icon fa-solid fa-masks-theater"></i>
						</div>
						
						<div class="d-block col-9">
							<div class="nickname">
								<p class="h5 font-italic ml-2">Anonymous</p>
							</div>
							<div class="row mx-0">
								<a href="#" class="text-secondary font-italic col-10 px-1 findInfo">Find your info <i class="fa-regular fa-circle-question"></i></a>
								<button type="button" id="loginBtn" class="logx-btn btn btn-primary btn-sm col-2">
									<i class="fa-solid fa-lock"></i>
								</button>
							</div>
						</div>
						
					</s:authorize>
					
					<s:authorize access="isAuthenticated()">			
						<div class="profile-img px-0 col-3">
							<c:choose>
								<c:when test="${fn:contains(user.userProfileImg, 'nulluser.svg')}">
									<s:authorize access="hasRole('ROLE_USER')">
									<img src="/init/resources/profileImg/nulluser.svg" alt="" />
									</s:authorize>
									<s:authorize access="hasRole('ROLE_ADMIN')">
									<img src="/init/resources/profileImg/admin_default.png" alt="" />
									</s:authorize>
								</c:when>
							
								<c:otherwise>
									<img src="/init/resources/profileImg/${user.userProfileImg }" alt="" />
								</c:otherwise>
							</c:choose>
						</div>
						<div class="d-block col-9">
							<div class="nickname">
								<p class="h5 font-italic ml-2">${user.userNick}</p>
							</div>
							<div class="row mx-0">
								<a href="feed" class="text-dark font-italic col-3 px-1">FEED</a>
								<a href="post/mypost" class="text-dark font-italic col-3 px-1">POST</a>
								<a href="feed/feedInfo" class="text-dark font-italic col-3 px-1">INFO</a>
								<form method="post" action="logout" class="col-2">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									<button type="submit" id="logoutBtn" class="logx-btn btn btn-danger btn-sm"><i class="fa-solid fa-lock-open"></i></button>
								</form>
							</div>
						</div>
					</s:authorize>
					
				</div>
			</div>
			<div class="map-filter border rounded p-2 bg-light">
				<div class="d-inline">
					<i class="fa-solid fa-filter text-info ml-3" style="font-size: 25px"></i>
				</div>

				
				<hr />

			
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
					
					<s:authorize access="isAnonymous()">
					<div class="form-group d-flex justify-content-end row mx-0">
							<button type="submit" id="filterbtn" class="btn btn-success col-2 mr-2 d-none">
								<i class="fa-solid fa-magnifying-glass"></i>
							</button> <!-- 필터 제출 버튼 -->
							
							<a href="" type="button" id="filterbtn" class="btn btn-success col-2 mr-2 anFeed">
								<i class="fa-solid fa-magnifying-glass"></i>
							</a> <!-- 필터 제출 버튼 -->
						
						<a href="" type="reset" id="filterResetbtn" class="btn btn-danger col-2 anFeed" >
							<i class="fa-solid fa-delete-left"></i>
						</a> <!-- 필터 초기화 버튼 -->
					</div>
					</s:authorize>
					
					<s:authorize access="isAuthenticated()">
					<div class="form-group d-flex justify-content-end row mx-0">
					
						<button type="submit" id="filterbtn" class="btn btn-success col-2 mr-2">
							<i class="fa-solid fa-magnifying-glass"></i>
						</button> <!-- 필터 제출 버튼 -->
						
						<button type="reset" id="filterResetbtn" class="btn btn-danger col-2" >
							<i class="fa-solid fa-delete-left"></i>
						</button> <!-- 필터 초기화 버튼 -->
					</div>
					</s:authorize>
				</form>
			</div>
		</div>
	</div>
	
	<c:set var="lastestPosts" value="${post.size() }" />
	<c:set var="bestLikePosts" value="${likeList.size() }" />
	<c:set var="bestViewPosts" value="${viewList.size() }" />
	
	<div class="main-body-bottom mb-5 mt-3">
		<div class="recommand recommand-1 mt-4 mb-2">
			<div class="recommand-icon text-primary d-flex justify-content-between">
				<i class="btn1 fa-regular fa-clock"></i>
				<s:authorize access="isAuthenticated()">
				<a href="/init/search/lastest" class="text-primary">
					<i class="btn2 fa-regular fa-circle-right"></i>
				</a>
				</s:authorize>
			</div>
			<div class="posts d-flex justify-content-between mt-2">
			<c:choose>
				<c:when test="${lastestPosts > 3}">
					<c:forEach items="${post}" var="post" begin="0" end="3" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${post.postNo }"">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${post.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(post.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${post.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${post.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${post.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${post.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${post.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				
				<c:otherwise>
					<c:forEach items="${post}" var="post" begin="0" end="${lastestPosts }" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${post.postNo }">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${post.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(post.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${post.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${post.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${post.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${post.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${post.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					
					<c:forEach begin="${lastestPosts }" end="3" >
						<div class="nullPost mr-2">
							<div class="post-top border rounded">
								<img src="" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile" class="border">
										
										</div>
									</div>
									<div class="col-10 pt-2">
										<b></b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>			
			</div>
		</div>

		
		<div class="recommand recommand-2 mb-2 mt-5">
			<div class="recommand-icon text-danger d-flex justify-content-between">
				<i class="btn1 fa-regular fa-heart"></i>
				<s:authorize access="isAuthenticated()">
				<a href="/init/search/bestLikes" class="text-danger">
					<i class="btn2 fa-regular fa-circle-right"></i>
				</a>
				</s:authorize>
			</div>	
			<div class="posts d-flex justify-content-between mt-2">
			<c:choose>
				<c:when test="${bestLikePosts > 3}">
					<c:forEach items="${likeList}" var="likeList" begin="0" end="3" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${likeList.postNo }" data-email="${likeList.email }">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${likeList.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(likeList.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${likeList.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${likeList.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${likeList.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${likeList.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${likeList.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				
				<c:otherwise>
					<c:forEach items="${likeList}" var="likeList" begin="0" end="${bestLikePosts }" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${likeList.postNo }" data-email="${likeList.email }">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${likeList.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(likeList.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${likeList.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${likeList.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${likeList.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${likeList.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${likeList.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					
					<c:forEach begin="${bestLikePosts }" end="3" >
						<div class="nullPost mr-2">
							<div class="post-top border rounded">
								<img src="" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile" class="border"></div>
									</div>
									<div class="col-10 pt-2">
										<b></b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
			</div>
		</div>
		
		<div class="recommand recommand-3 mb-2 mt-5">
			<div class="recommand-icon text-success d-flex justify-content-between">
				<i class="btn1 fa-regular fa-thumbs-up"></i>
				<s:authorize access="isAuthenticated()">
				<a href="/init/search/bestViews" class="text-success">
					<i class="btn2 fa-regular fa-circle-right"></i>
				</a>
				</s:authorize>
			</div>
			<div class="posts d-flex justify-content-between mt-2">			
			<c:choose>
				<c:when test="${bestViewPosts > 3}">
					<c:forEach items="${viewList}" var="viewList" begin="0" end="3" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${viewList.postNo}" data-email="${viewList.email }">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${viewList.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(viewList.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${viewList.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${viewList.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${viewList.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${viewList.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${viewList.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				
				<c:otherwise>
					<c:forEach items="${viewList}" var="viewList" begin="0" end="${bestViewPosts }" >
						<s:authorize access="isAnonymous()">
						<div class="anFeed mr-2">
						</s:authorize>
						<s:authorize access="isAuthenticated()">
						<div class="post mr-2" data-value="${viewList.postNo}" data-email="${viewList.email }">
						</s:authorize>
							<div class="post-top border rounded">
								<img src="/init/resources/images/${viewList.titleImage}" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile">
											<c:choose>
												<c:when test="${fn:contains(viewList.userProfileImg, 'nulluser.svg')}">
													<img src="/init/resources/profileImg/nulluser.svg" alt="" />
												</c:when>
							
												<c:otherwise>
													<img src="/init/resources/profileImg/${viewList.userProfileImg }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-10 pt-2">
										<b>${viewList.userNick}</b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										${viewList.likes}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										${viewList.views}
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										${viewList.comments}
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					
					<c:forEach begin="${bestViewPosts }" end="3" >
						<div class="nullPost mr-2">
							<div class="post-top border rounded">
								<img src="" alt="" />
							</div>
							
							<div class="post-bottom bg-light border">
								<div class="d-flex pt-1" style="height: 60%">
									<div class="profile-box col-2 px-0">
										<div id="post-profile" class="border"></div>
									</div>
									<div class="col-10 pt-2">
										<b></b>
									</div>
								</div>
									
									
								<div class="row mx-2 d-flex justify-content-around" style="height: 40%">
									<div class="col-4 px-1">
										<i class="fa-solid fa-heart"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-regular fa-circle-check"></i>
										
									</div>
									
									<div class="col-4 px-1">
										<i class="fa-solid fa-comment-dots"></i>
										
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
			</div>
		</div>
	</div>
</section>
<%@ include file="includes/login_modal.jsp" %>
<%@ include file="includes/modalPost.jsp" %>
<%@ include file="includes/footer.jsp" %>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3&libraries=clusterer"></script>

<script src="/init/js/index.js"></script>

<script>

$('#loginBtn').click(function() {
	$('#loginModalBtn').trigger('click');
});

<c:if test='${not empty error}'>
	$('#loginError').css('visibility','visible');
	$('#loginModalBtn').trigger('click');
</c:if>

</script>

</body>
</html>
