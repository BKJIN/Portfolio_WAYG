<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

<!-- KAKAO API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- css -->
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<link rel="stylesheet" type="text/css" href="../css/join/join.css" />
<title>WAYG</title>

</head>
<body>
<%@ include file="../includes/roader.jsp" %>
<%@ include file="../includes/header.jsp" %>

<div class="container" style="margin-top:90px; margin-bottom:50px;">
	<!-- 회원가입 성공시 모달 -->
	<!-- modal button -->
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal">
	<!-- modal창 -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;JOIN</h4>
				</div>
				<div class="modal-body bg-light">
					<h4>WELCOME!</h4>
				</div>
				<div class="modal-footer bg-light">
					<button id="closeBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 회원 가입 창 -->	
	<h1 class="text-center mb-4 display-4">WAYG</h1>
	
	
	<form id="joinForm" action="join" method="post" name="joinForm">
		<div id="agreements" class="mb-5">
			<div class="conditions border px-2">
				<h5><strong>WAYG 개인정보 수집 동의 요청서</strong></h5><br/>
				&nbsp;1. 위치를 기반으로 한 서비스 사용시 현재 위치를 설정하여 원하는 데이터를 제공하기 위한 목적으로 회원님의 현재 실시간 위치 정보를 요청할 수 있으며,
				  이는 위에 언급된 기능 이외에 다른 목적으로는 사용되지 않습니다.<br/><br/>
				&nbsp;2. 타 사이트 계정 사용한 소셜 로그인시 WAYG 서비스 이용을 위한 추가 정보(거주지 주소, 생년월일, 성별)를 별도로 기입하여야 합니다.<br/><br/>
				&nbsp;3. 생성한 일정은 특정 카테고리별로 수치화되어 WAYG를 이용하는 다른 회원들에게 제공됩니다. 이는 어느 계정에서 생성한 일정인지는 공개되지 않으며,<br/>
				 후기로 등록한 포스트를 게시했을 시에는 타인에게 공개될 수 있습니다. 
			</div>
			
			<div class="checkBox d-flex justify-content-end">
				<p class="font-italic mt-3 mr-5">WAYG에서 요청하는 개인정보 수집에 동의하시겠습니까?</p>
				<div class="form-check-inline">
					<input type="radio" name="agreements" class="form-check-input" value="agree" id="agree" />
					<label class="form-check-label" for="flexCheckChecked">
						동의
					</label>
				</div>
				
				<div class="form-check-inline">
					<input type="radio" name="agreements" class="form-check-input" value="disagree" id="disagree" checked/>
					<label class="form-check-label" for="flexCheckChecked">
						비동의
					</label>
				</div>
			</div>
		</div>
		<div id="userinfo">
		    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
		
			<h1 class="mb-4 d-inline display-4" id="form-title">USER INFO</h1><p class="ml-2 d-inline font-italic text-secondary"><span class="required">*</span>로 표시된 부분은 필수 입력 사항입니다.</p>
			
			<hr />
		
			<div class="form-group row mx-0">
				<label for="userEmail" class="mt-2 col-2 border-right">E-mail <span class="required">*</span></label>
				<div class="col-8">
					<input type="text" class="userEmail form-control" id="userEmail" name="uEmail" placeholder="EMAIL" onkeyup="checkEmail()" autocomplete="off" maxlength="30">
					<div class="userEmail-validation validation mt-1">
					</div>
				</div>
				<button type="button" id="mailCheck" class="btn btn-sm btn-dark ml-1 col-1" disabled="true"><i class="fa-solid fa-at"></i></button>
				
			</div>

			<div class="form-group row mx-0 d-none" id="mailCheck">
				<label for="emailCert" class="mt-2 col-2 border-right">Certification <span class="required">*</span></label>
				<div class="col-10">
					<input type="number" class="mailCheck form-control" id="emailCert" name="emailCert" placeholder="PIN" maxlength="6" required>
				</div>
			</div>
			
			<hr />
			
			<div class="form-group row mx-0">
				<label for="userPw1" class="mt-2 col-2 border-right">Password <span class="required">*</span></label>
				<div class="col-10">
					<input type="password" class="userPw1 form-control" id="userPw1" name="uPw1" placeholder="PASSWORD" maxlength="16">
					<div class="userPw1-validation validation">
					</div>
				</div>
			</div>	
			
			<div class="form-group row mx-0">
				<label for="userPw2" class="mt-2 col-2"></label>
				<div class="col-10">
					<input type="password" class="userPw2 form-control" id="userPw2" name="uPw2" placeholder="CONFIRRM PASSWORD" maxlength="16" readonly="readonly">
					<div class="userPw2-validation validation">
					</div>
				</div>
			</div>	
			
			<hr />
			
			<div class="form-group row mx-0">
				<label for="userNickName" class="mt-2 col-2 border-right">Nickname <span class="required">*</span></label>
				<div class="col-10">
					<input type="text" class="userNickName form-control" id="userNickName" name="uNickName" placeholder="NICKNAME" onkeyup="checkNickName()" autocomplete="off" maxlength="20">
	  				<div class="userNickName-validation validation">
		  			</div>		
		  		</div>
			</div>	
			
			<hr />
			
			<div class="form-group row mx-0">
				<label for="userBirth" class="mt-2 col-2 border-right">Birth <span class="required">*</span></label>
				<div class="col-10">
					<input type="text" class="userBirth form-control" id="userBirth" name="uBirth" placeholder="EX:19970501" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" autocomplete="off" maxlength="8">
					<div class="userBirth-validation validation">
					</div>
				</div>
			</div>
			
			<hr />
			
			<div class="form-group row mx-0">
				<label for="btn-group" class="mt-2 col-2 border-right">Gender <span class="required">*</span></label>
				
				<div class="btn-group btn-group-toggle col-3 row mx-0" data-toggle="buttons">
					<label id="male" class="btn btn-outline-defalut border-white active">
						<input type="radio" name="uGender" autocomplete="off" value="MALE" checked><i class="fa-solid fa-mars"></i>
					</label>
					<label id="female" class="btn btn-outline-defalut border-white ">
						<input type="radio" name="uGender" autocomplete="off" value="FEMALE"><i class="fa-solid fa-venus"></i>
					</label>
				</div>
			</div>	
			
			<hr />
			
			<div class="form-group row mx-0">
				<label for="userAddr1" class="mt-2 col-2 border-right">Post-code <span class="required">*</span></label>
					<div class="form-inline mb-2 ml-2">
						<div class="input-group">
							<input type="text" class="form-control bg-white mr-2" id="userPst" name="uPst" placeholder="POSTCODE" onfocus="clickSerachPst()" readonly>
							<span class="input-group-btn">
								<button type="button" id="searchPst" class="btn btn-sm btn-dark" onclick="serchPostCode()"><i class="fa-brands fa-sistrix"></i></button>
							</span>
						</div>
					</div>
				<span id="guide" style="color:#999;display:none"></span>
			</div>
			
			<div class="form-group row mx-0">
				<label for="userAddr1" class="mt-2 col-2 border-right">Address <span class="required">*</span></label>
				<input type="text" class="form-control bg-white ml-2" id="userAddr1" name="uAddr1" placeholder="ADDRESS1" onfocus="clickSerachPst()" readonly>
			</div>
				
			<div class="form-group row mx-0 pb-3">
				<label for="userAddr2" class="mt-2 col-2 border-right">ADDRESS2</label>
				<input type="text" class="form-control ml-2" id="userAddr2" name="uAddr2" placeholder="ADDRESS2" maxlength="50">
			</div>		
		
			<hr />
		
			<div class="d-flex justify-content-end">
				<button type="submit" class="btn btn-primary border-white">가입</button>
				<button type="button" id="goback" class="btn btn-danger border-white">취소</button>
			</div>
		</div>
	</form>
</div>
    
<%@ include file="../includes/footer.jsp" %>

<script src="../js/join/join.js"></script>

<script>

// 메일 인증
$('#mailCheck').click(function() {
	
	var height = $(document).height();
	$('#roader').css('height', height);
	$('#roader').removeClass('none');
	$('#roader').addClass('active');
	
	
	var mail = $('input#userEmail').val();
	$('#userEmail').attr('readonly', true);
	$('div#mailCheck').removeClass('d-none');
	
	$.ajax({
		url: "/init/mail/joinCert",
		type: "get",
		data: {email : mail},
		contentType: 'json',
		beforeSend: function(xhr){
 		   	var token = $("meta[name='_csrf']").attr('content');
 			var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
		},
		success: function(data) {
			$('#roader').addClass('none');
			$('#roader').removeClass('active');

			var pinNum = data;
			
			$('input.mailCheck').keyup(function() {
				if( $(this).val() == pinNum ) {
					
					alert('메일 인증에 성공했습니다.');
					$('div#mailCheck').remove();
					$('#mailCheck').attr('disabled', true);
					$('#userEmail-validation').text('메일 인증이 완료되었습니다.');
				}
			});
			
		},
		error: function() {
			console.log('실패');
		}
	});
});

</script>

</body>
</html>