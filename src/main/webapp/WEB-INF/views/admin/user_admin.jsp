<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false" %>    
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
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<title>Insert title here</title>
<style>
html,body {
	height: 100%;
	margin: 0; 
	padding : 0;
}

body{
	padding-top: 80px;
}

#admin_ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: auto;
}

#admin-li a {
  display: block;
  color: #000;
  padding: 8px 16px;
  text-decoration: none;
  border-radius: 15px 15px 0px 0px;
}

#admin-li a.active {
  background-color: #828282;
  color: white;
}

#admin-li a:hover:not(.active) {
  background-color: #CBCBCB;
  color: white;
}

hr {
	margin-top : 0;
}

#main{
	height : 80%;
}

#user_ul{
  list-style-type: none;
  margin: 0;
  padding: 0;
  align-self: center;
}

#user_ul li{
  color: #000;
  text-decoration: none;
}

#user_ul li a{
  color: #000;
  text-align : center;
  font-weight : bold;
  text-decoration: none;
}

#user_ul li a:hover{
  background-color: #555;
  color: white;	
}

</style>
</head>
<body>

<%@ include file="../includes/header.jsp" %>
<input type="hidden" id="uemail" value=""/>
<div id="main" class="container">
	<nav class="bg-white mt-3">
		<ul id="admin_ul" class="d-flex row mx-0">
			<li id="admin-li" class="col-6">
				<a href="admin"><b class="font-italic">DashBoard</b></a>
			</li>
			
			<li id="admin-li" class="col-6">
				<a class="active" href="u_admin"><b class="font-italic">UserBoard</b></a>
			</li>
		</ul>
	</nav>
	<hr />
	<!-- 유저 검색 창 -->
	<div id="search-div" class="container px-4 d-none d-md-block mt-2">
		<div class="form-group d-flex align-items-center">
			<label for="searchNick" class="col-3 border-right mt-2 mr-3">Search Nickname</label>
			<input id="searchNick" type="text" class="form-control col-8" placeholder="회원 검색">
		</div>
		
		<hr />
		
		<!-- 유저 검색 결과 창 -->
		<div id="foundUserInfo" class="list-group-item list-group-item-action" style="display:none;">
			<button id="createUser" style="all:unset;" class="float-right"><i class="fa-solid fa-user"></i></button>
			<div class="row mx-0 d-flex align-items-start">	
				<img id="foundUserImg" class="rounded-circle col-1 mr-1" width="40" height="40">
				
				<div id="foundUserNick" class="col-5 ml-3 mt-2"></div>

				<!-- 유저 관리 창 -->
				<ul id="user_ul" class="col-5 d-flex row mx-0" style="display">
				  <li id="user-li" class="col-4">
				  	<a href="#">정보 관리</a>
				  </li>
				  
				  <li id="user-li-ban" class="col-4">
				  	<a href="#">회원 정지</a>
				  </li>
				  
				  
				  <li id="user-li-delete" class="col-4">
				  	<a href="#">회원 탈퇴</a>
				  </li>  
				</ul>
			</div>
		</div>
	</div>
	
	<!-- 유저 mypage 보일 위치 -->
	<div class="container" id="myPage"></div>
</div>

<!-- 회원탈퇴 모달 창 -->
<div class="container">
	<input id="modalBtn3" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal">
	<!-- modal창 -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회원탈퇴</h4>
				</div>
				<div class="modal-body bg-light">
					<h4>회원 탈퇴를 진행하시겠습니까?</h4>
				</div> 
				<div class="modal-footer bg-light">
					<button id="yesBtn" type="submit" class="btn btn-danger">Yes</button>
					<button id="noBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">No</button>
				</div> 
			</div>
		</div>
	</div>
</div>

<!-- 회원 정지 모달 창 -->
<div class="container">
	<input id="modalBtn2" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal2" value="modal2">
	<!-- modal창 -->
	<div class="modal fade" id="myModal2" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회원정지</h4>
				</div>
				<div class="modal-body bg-light">
					<h4>회원 정지를 진행하시겠습니까?</h4>
				</div> 
				<div class="modal-footer bg-light">
					<button  id="activateBtn" type="submit" class="btn btn-success">활성화</button>
					<button id="disabledBtn" type="submit" class="btn btn-default btn-warning">비활성화</button>
					<button id="closeBtn" type="button" class="btn btn-default btn-danger" data-dismiss="modal">Close</button>
				</div> 
			</div>
		</div>
	</div>
</div>

<script>

// 회원 검색
$("#searchNick").keyup(function(){
	var val = $("#searchNick").val();
	console.log(val);
	$.ajax({
		type : "get",
		url : "/init/chat/searchNick",
		data : {nick:val},
		success : function(data) {
			
			if(data.userNick != null) {
				$("#foundUserInfo").css("display","block");
				if(data.userProfileImg.indexOf('nulluser.svg') == -1) {
					$("#foundUserImg").attr("src","/init/resources/profileImg/"+data.userProfileImg);
				} else {
					$("#foundUserImg").attr("src","/init/resources/profileImg/nulluser.svg");
				}
				$("#foundUserNick").html(data.userNick);
				$("#uemail").attr("value", data.userEmail);
			} else {
				$("#foundUserInfo").css("display","none");
			}
		},error : function() {
			alert("에러입니다. 다시 시도해주세요.");
		}
	});
});

//찾은 회원 눌렀을 때 회원관리 창 보이게
$("#foundUserInfo").click(function(){
	
	if ( $('#myPage').html() != null ) {
		$('#myPage').html('');
	}
	
	$("#user_nav").toggle();
});

//회원 탈퇴 누르면 모달 창 생성
$("#user-li-delete").click(function(){
	$("#modalBtn3").trigger("click");
});

//회원 정지 누르면 모달 창 생성
$("#user-li-ban").click(function(){
	$("#modalBtn2").trigger("click");
});

//회원 탈퇴 확인 버튼 클릭 시 
$("#yesBtn").click(function(){
	
	let nick = $("#searchNick").val();
	
	$.ajax({
		type : 'post',
		url : 'deleteUser',
		data : {"nick" : nick},
		beforeSend: function(xhr){
		   	var token = $("meta[name='_csrf']").attr('content');
			var header = $("meta[name='_csrf_header']").attr('content');
	        xhr.setRequestHeader(header, token);    
		},
		success : function(data){
			console.log(data);
			alert('회원 탈퇴에 성공했습니다.');
			$("#noBtn").trigger("click");
		},
		error : function(){
			alert('회원 탈퇴에 실패했습니다.');
		}		
	});
});

//회원 비활성화 버튼 클릭 시
$("#disabledBtn").click(function(){
	
	let nick = $("#searchNick").val();
	
	$.ajax({
		type : 'post',
		url : 'banUser',
		data : {"nick" : nick},
		beforeSend: function(xhr){
		   	var token = $("meta[name='_csrf']").attr('content');
			var header = $("meta[name='_csrf_header']").attr('content');
	        xhr.setRequestHeader(header, token);    
		},
		success : function(data){
			console.log(data);
			alert('회원 계정 비활성화에 성공했습니다.');
			$("#closeBtn").trigger("click");
		},
		error : function(){
			alert('회원 계정 비활성화에 실패했습니다.');
		}		
	});
});

//회원 활성화 버튼 클릭 시
$("#activateBtn").click(function(){

	let nick = $("#searchNick").val();
	
	$.ajax({
		type : 'post',
		url : 'activateUser',
		data : {"nick" : nick},
		beforeSend: function(xhr){
		   	var token = $("meta[name='_csrf']").attr('content');
			var header = $("meta[name='_csrf_header']").attr('content');
	        xhr.setRequestHeader(header, token);    
		},
		success : function(data){
			console.log(data);
			alert('회원 계정 활성화에 성공했습니다.');
			$("#closeBtn").trigger("click");
		},
		error : function(){
			alert('회원 계정 활성화에 실패했습니다.');
		}		
	});
});

//회원 정보관리 클릭 시 mypage 생성
$("#user-li").click(function(){

	let uId = $("#uemail").val();
	console.log(uId);
	$.ajax({
		type : 'post',
		url : 'adminMyPage',
		data : {"uId" : uId},
		beforeSend: function(xhr){
		   	var token = $("meta[name='_csrf']").attr('content');
			var header = $("meta[name='_csrf_header']").attr('content');
	        xhr.setRequestHeader(header, token);    
		},
		success : function(data){
			$("#myPage").html(data);
			
			$('#feed-header').remove();
			$('.feed-tabs').remove();
		},
		error : function(){
			console.log("error");
		}		
	});
});

</script>		
		
</body>
</html>