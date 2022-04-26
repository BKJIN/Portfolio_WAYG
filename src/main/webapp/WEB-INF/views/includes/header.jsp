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
<title>header</title>
</head>

<body>
<nav class="navbar navbar-default fixed-top border-bottom bg-white">
	<div class="container">
		<div class="navbar-header">
			<a href="/init" class="navbar-brand">
				<img src="/init/images/logo.png" id="logo" />
			</a>
		</div>
		
		<div>
			<div class="input-group border rounded bg-light">
				<div class="input-group-btn">
		    		<button type="button" class="btn btn-default mr-1 keywordView">keyword</button>
		        	<button type="button" class="btn btn-default dropdown-toggle mr-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="caret"></span></button>
		        	<ul class="dropdown-menu">
		          		<li class="keyword" value="NickName">NickName</li>
		          		<li class="keyword" value="Location">Location</li>
		          		<li class="keyword" value="Hashtag">Hashtag</li>
		        	</ul>
		      	</div>
				<input type="text" class="form-control bg-light mr-1 searchVal" size="30" aria-label="000" placeholder="search...">
				<s:authorize access="isAnonymous()">
	    			<a href="#" class="btn btn-default mr-1 anFeed"><i class="fa-brands fa-sistrix"></i></a>
	    		</s:authorize>
	    		
	    		<s:authorize access="isAuthenticated()">
	    			<a href="#" class="btn btn-default mr-1 search"><i class="fa-brands fa-sistrix"></i></a>
	    		</s:authorize>	     	
		    </div>
		</div>
		
		<ul class="nav navbar">
			<li class="mr-4 notice_board">
				<a href="/init/notice_board">
					<i class="menu-icon fa-regular fa-rectangle-list"></i>
				</a>
			</li>
		
		
		
			<li class="mr-4 /init/feed">
				<s:authorize access="isAnonymous()">
					<a href="/init/feed" class="anFeed">
						<i class="menu-icon fa-regular fa-circle-user"></i>
					</a>
				</s:authorize>
				
				<s:authorize access="isAuthenticated()">
					<a href="/init/feed" id="loginFeed">
						<i class="menu-icon fa-regular fa-circle-user"></i>
					</a>
				</s:authorize>
			</li>
			
			<li class="mr-4 notice">
				<a href="" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<i class="menu-icon fa-regular fa-bell"></i>
				</a>
				<s:authorize access="isAuthenticated()">
	        	<ul class="dropdown-menu">
	        		<c:forEach begin="1" end="10" var="i">
			          	<li class="list-group-item">
			          		alarm${i}
			          	</li>
		          	</c:forEach>
	        	</ul>
	        	</s:authorize>
				
			</li>
			
			<li class="mr-4 msg">
				<s:authorize access="isAnonymous()">
					<a href="/init/chat/messages" class="anFeed">
						<i class="menu-icon fa-regular fa-comment-dots"></i>
					</a>
				</s:authorize>
				
				<s:authorize access="isAuthenticated()">
					<a href="/init/chat/messages">
						<i class="menu-icon fa-regular fa-comment-dots"></i>
					</a>
				</s:authorize>
			</li>
			
			<s:authorize access="hasRole('ROLE_ADMIN')">
				<li class="mr-4 msg">
					<a href="/init/admin">
						<i class="menu-icon fa-solid fa-screwdriver-wrench"></i>
					</a>
				</li>
			</s:authorize>	
		</ul>
		
	</div>
			
<script>
$(document).ready(function(){
	let keyword = '';
	let searchVal = '';
	
	
	$('.anFeed').click(function(e){
		e.preventDefault();
		$('#loginModalBtn').trigger('click');
	});
	
	$('.keyword').click(function () {
		$('.keywordView').text($(this).attr('value'));
		keyword = $(this).attr('value');
		
	});
	
	$('.search').click(function () {
		
		searchVal = $('.searchVal').val();
		
		if(keyword==''){
			alert('검색하실 키워드를 선택해주세요 ! ')
			
		}else if(searchVal==''){
			alert('검색어를 입려해주세요 ! ')
		}else{
			$(this).attr('href','/init/search/search?keyword='+keyword+'&searchVal='+searchVal);
			
	
		}
	});
});
</script>
</nav>
</body>
</html>