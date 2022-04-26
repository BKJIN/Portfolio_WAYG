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
<!-- KAKAO API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" type="text/css" href="/init/css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="/init/css/feed/feed_calendar.css" />
<link rel="stylesheet" type="text/css" href="/init/css/feed/feed_user_info.css" />
<link rel="stylesheet" type="text/css" href="/init/css/includes/footer.css" />
<title>Insert title here</title>

<script>
var myNick = '<c:out value="${myPageInfo.userNick}" />';
var gender = '<c:out value="${myPageInfo.userGender}" />';
var myPst = '<c:out value="${myPageInfo.userPst}" />';
var myAddr1 = '<c:out value="${myPageInfo.userAddress1}" />';
var myAddr2 = '<c:out value="${myPageInfo.userAddress2}" />';
</script>
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
<%@ include file="../includes/header.jsp" %>
<section class="container mb-5">
	<%-- section-header --%>
	<div class="body-container">
		<%-- 1. 유저 프로필 (프로필 이미지, 정보)--%>
		<div id="feed-header" class="d-flex justify-content-start border-bottom row mx-0 flex-nowrap">
			<%-- 1- 프로필 이미지 --%>
			<div id="profile-img" class="p-3 ml-4 bg-body col-2 text-center">
				<c:choose>
					<c:when test="${fn:contains(fileName, 'nulluser.svg')}">
						<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle" alt="" />
					</c:when>
							
					<c:otherwise>
						<img src="/init/resources/profileImg/${fileName}" class="rounded-circle" alt="" />
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
					<pre class="ml-3 header-bio">${myPageInfo.userProfileMsg}</pre>
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
			<li id="feed-post" class='nav-item col-3' data-tab=''>
				<a href="../post/mypost" class="nav-link">
					<i class="fa-solid fa-images"></i>
				</a>
			</li>
			
			<%-- 4- 유저 정보 피드 버튼 --%>			
			<li id="feed-info" class='nav-item active col-3' data-tab=''>
				<a href="../feed/feedInfo" class="nav-link">
					<i class="fa-solid fa-gear"></i>
				</a>
			</li>
		</ul>

		<%-- section-body --%>
		<div class="d-flex justify-content-between mt-5" id="main-body">
			<div class="container" style="margin-bottom:20px;">
				<!-- 회원정보 변경완료시, 비밀번호 변경시 모달 -->
				<!-- modal button -->
				<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal">
				<!-- modal창 -->
				<div class="modal fade" id="myModal" role="dialog">
					<div class="modal-dialog modal-dialog-centered modal-sm text-center">
						<div class="modal-content">
							<div class="modal-header bg-light">
								<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WAYG</h4>
							</div>
							<div class="modal-body bg-light">
								<form action="chkPwForMdf" id="chkPwForMdf" method="post" style="display:none">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
									<div class="form-group">
										<label for="curPw">Current password</label>
										<input type="password" class="form-control" id="curPw" name="crpw" autocomplete="off"/>
										<div class="form-group" style="visibility:hidden; color:red; font-size:14px;" id="curPwError">현재 비밀번호가 일치하지 않습니다.</div>
									</div>
									<input type="submit" value="확인" class="btn btn-sm btn-primary"/>
								</form>
								<form action="modifyPw" id="modifyPwForm" method="post" style="display:none">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
									<div class="form-group">
										<label for="newPw">New password</label>
										<input type="password" class="form-control"  id="newPw" name="npw" autocomplete="off" maxlength="16"/>
										<div class="newPw-validation validation">
										</div>
									</div>
									<div class="form-group">
										<label for="cfrmPw">Confirm new password</label>
										<input type="password" class="form-control"  id="cfrmPw" name="cfpw" autocomplete="off" maxlength="16" readonly/>
										<div class="cfrmPw-validation validation">
										</div>
									</div>
									<input type="submit" value="비밀번호 변경" class="btn btn-sm btn-primary"/>
								</form>
							</div>
						</div>
					</div>
				</div>
				
				<!-- 회원탈퇴시 모달 -->
				<!-- modal button -->
				<input id="resigModalBtn" type="hidden" class="btn" data-toggle="modal" data-target="#resigModal" value="modal">
				<!-- modal창 -->
				<div class="modal fade" id="resigModal" role="dialog">
					<div class="modal-dialog modal-dialog-centered modal-sm text-center">
						<div class="modal-content">
							<div class="modal-header bg-light">
								<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WAYG</h4>
							</div>
							<div class="modal-body bg-light">
								<form action="chkPwForResig" id="chkPwForResig" method="post">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
									<div class="form-group">
										<label for="resigPw">Password</label>
										<input type="password" class="form-control" id="resigPw" name="rgPw" autocomplete="off" required/>
										<div class="form-group" style="visibility:hidden; color:red; font-size:12px;" id="resigPwError">비밀번호가 일치하지 않습니다.</div>
									</div>
									<input type="submit" value="확인" class="btn btn-sm btn-primary"/>
								</form>
							</div>
							<div class="modal-footer bg-light">
								<button id="agreeResig" type="button" class="btn btn-default btn-danger" style="display:none">확인</button>
								<button id="resigCloseBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
				
				
				
				<form action="/init/feed/add_PrfImg?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
					<div class="d-flex justify-content-center">
						<c:choose>
							<c:when test="${fn:contains(fileName, 'nulluser.svg')}">
								<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle" width="100" height="100" />
							</c:when>
							
							<c:otherwise>
								<div id="prfImgArea">
									<img src="/init/resources/profileImg/${fileName}" class="rounded-circle" width="100" height="100">
									<s:authorize access="!hasRole('ROLE_ADMIN')">
										<a href="/init/feed/eraseImg" class="eraseImg"><i class="fa-solid fa-eraser"></i></a>
									</s:authorize>
									<s:authorize access="hasRole('ROLE_ADMIN')">
										<a id="adminEraseImg" class="eraseImg"><i class="fa-solid fa-eraser"></i></a>
									</s:authorize>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					<s:authorize access="!hasRole('ROLE_ADMIN')">
						<div class="d-flex justify-content-center mt-1">
							<label for="prfImg" id="imgBtn" class="btn btn-sm btn-dark mt-1" style="width: 100px;" >
								<i class="fa-solid fa-camera-retro"></i>
							</label>
						</div>
					</s:authorize>
					<input type="file" class="form-control" id="prfImg" name="pImg" accept="image/*" onchange="clicksubmit()" style="display:none;">
					<button id="submitImg" type="submit" class="btn btn-primary" style="display:none;">submit</button>
				</form>
				
				<hr />

				<div class="form-group row mx-0">
					<label for="inputUserNick" class="mt-2 col-2 border-right">Nickname</label>
					<input id="inputUserNick" type="text" value="${myPageInfo.userNick}" class="form-control ml-5 col-9" onkeyup="checkNickName()" autocomplete="off" maxlength="20" readonly>
					<div class="userNick-validation validation" style="text-align:center;"></div>
				</div>
				
				<hr />			
				
				<div class="form-group row mx-0">
					<label for="userProfileMsg" class="mt-2 col-2 border-right">BIO</label>
					<textarea class="form-control rounded ml-5 col-9" id="userProfileMsg" name="uPrfMsg" rows="5" maxlength="300" readonly>${myPageInfo.userProfileMsg}</textarea>
				</div>
				
				<hr />
				
				<div class="form-group row mx-0">
					<label for="userEmail" class="mt-2 col-2 border-right">E-mail</label>
					<input type="text" class="form-control ml-5 col-9" id="userEmail" name="uEmail" value="${myPageInfo.userEmail}" readonly>
				</div>
				
				<hr />
				
				<div class="form-group row mx-0">
					<label for="userBirth" class="mt-2 col-2 border-right">Birth</label>
					<input type="text" class="form-control  ml-5 col-9" id="userBirth" name="uBirth" value="${myPageInfo.userBirth}" readonly>
				</div>
				
				<hr />
				
				<div class="form-group row mx-0">
					<label for="btn-group" class="mt-2 col-2 border-right">Gender</label>
					
					<div class="btn-group btn-group-toggle ml-5 col-3 row mx-0" data-toggle="buttons">
						<label id="male" class="btn btn-outline-defalut border-white">
							<input type="radio" id="male" name="uGender" autocomplete="off" value="MALE" disabled><i class="fa-solid fa-mars"></i>
						</label>
						<label id="female" class="btn btn-outline-defalut border-white">
							<input type="radio" id="female" name="uGender" autocomplete="off" value="FEMALE" disabled><i class="fa-solid fa-venus"></i>
						</label>
					</div>
				</div>
					
				<hr />
					
				<div class="form-group row mx-0">
					<label for="userAddr1" class="mt-2 col-2 border-right">Post-code</label>
						<div class="form-inline mb-2">
							<div class="input-group rounded">
								<input type="text" class="form-control ml-5" id="userPst" name="uPst" value="${myPageInfo.userPst}" onfocus="clickSerachPst()" disabled> <!-- readonly속성은 onfocus가 먹힘 -->
								<span class="input-group-btn">
									<button type="button" id="searchPst" class="btn btn-sm btn-dark" onclick="serchPostCode()" style="display:none;"><i class="fa-brands fa-sistrix"></i></button>
								</span>
							</div>
						</div>
					<span id="guide" style="color:#999;display:none"></span>
				</div>
				
				<hr />
				
				<div class="form-group row mx-0">
					<label for="userAddr1" class="mt-2 col-2 border-right">Address</label>
					<input type="text" class="form-control ml-5 col-9" id="userAddr1" name="uAddr1" onfocus="clickSerachPst()" value="${myPageInfo.userAddress1}" disabled>
				</div>	
				
				<hr />
				
				<div class="form-group row mx-0">
					<label for="userAddr2" class="mt-2 col-2 border-right">Address2</label>
					<input type="text" class="form-control ml-5 col-9" id="userAddr2" name="uAddr2" value= "${myPageInfo.userAddress2}" maxlength="50" readonly>
				</div>
				
				<hr />
				
				<div class="d-flex justify-content-end">
					<s:authorize access="hasRole('ROLE_ADMIN')">			
						<button type="button" id="adminModifyInfo" class="btn btn-dark border-white"><i class="fa-solid fa-screwdriver-wrench"></i></button>
						<button type="button" id="adminModified" class="btn btn-dark border-white" style="display:none"><i class="fa-solid fa-screwdriver-wrench"></i></button>
					</s:authorize>
					<s:authorize access="!hasRole('ROLE_ADMIN')">
						<button type="button" id="modifyInfo" class="btn btn-primary border-white"><i class="fa-solid fa-user-plus"></i></button>
						<button type="button" id="modified" class="btn btn-success border-white" style="display:none"><i class="fa-solid fa-user-check"></i></button>
						<button type="button" id="modifyPw" class="btn btn-warning border-white"><i class="fa-solid fa-key text-white"></i></button>
						<button type="button" id="resigBtn" class="btn btn-danger border-white"><i class="fa-solid fa-user-xmark"></i></button>
					</s:authorize>
				</div>
				<input type="hidden" id="uemail" value=""/>
			</div>
		</div>
	</div>
</section>
<%-- custom javascript files --%>
<script src="/init/js/feed/feed_user_info.js"></script>
</body>
</html>