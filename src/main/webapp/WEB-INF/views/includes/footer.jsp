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
<title>footer</title>

<style>
#sendBtn {
	padding-x: 2px;
	font-size: 20px;
	height: 17%;
}

.contact-input {
	background-color: transparent;
	border: none;
	border-radius: 0;
	border-bottom: 1px solid white;
	color: white;
}

textarea.contact-input {
	height: 150px;
	resize: none;
	border: 1px 0px 1px 0px solid white;
	color: white;
}
</style>
</head>

<body>
<footer class="bg-dark d-flex justify-content-center">
	<form action="" class="container row mx-0 mt-2">
		<b class="display-4 text-warning col-1"><i class="fa-solid fa-q"></i></b>
		<input type="text" name="subject" class="form-control col-11 mt-4 contact-input" placeholder="여러분의 의견을 보내주세요." required/>
	
		<input type="text" name="mail" class="form-control col-10 mt-1 ml-3 mr-5 contact-input" placeholder="Your email address" required/>
		<button type="submit" id="sendQnABtn" class="btn btn-sm btn-info ml-2 col-1 p-0"><i class="fa-regular fa-envelope"></i></button>

		<textarea name="content" class="form-control contact-input" id="" cols="30" rows="2" placeholder="Contact Us-*" required></textarea>
	</form>
</footer>

<script>

$('button#sendQnABtn').click(function(e) {
	e.preventDefault();
	
	var subject = $('input[name=subject]').val();
	var mail = $('input[name=mail]').val();
	var content = $('input[name=content]').val();
	
	$('#roader').css('display', 'block');
	
	$.ajax({
		url: "/init/mail/contactus",
		type: "get",
		data: {
			subject : subject,
			usermail : mail,
			content : content
		},
		
		beforeSend: function(xhr){
 		   	var token = $("meta[name='_csrf']").attr('content');
 			var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
		},
		
		success : function() {
			$('#roader').css('display', 'none');
			alert('메일 전송이 완료되었습니다. 감사합니다.');
		},
		error : function() {
			$('#roader').css('display', 'none');
			alert('서버 문제로 메일 전송에 실패했습니다. 죄송합니다.');
		}
	})
})
</script>

</body>
</html>