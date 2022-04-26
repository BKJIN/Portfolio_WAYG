<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<!DOCTYPE html>
<html lang="ko">
<head>
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<link rel="stylesheet" type="text/css" href="/init/css/includes/modalPost.css" />
<style>
.profile-img-s {
	border-radius: 50%;
	overflow: hidden;
}

.profile-img-s img {
	max-width: 100%;
	max-height: 100%;
}

.img-xxs {
	border-radius: 50%;
	overflow: hidden;
	text-align: center;
}

.img-xxs img {
	max-width: 100%;
	max-height: 100%;
}

</style>
</head>
<body>
<!-- modal button -->
<input type="hidden" id="modalBtn" data-toggle="modal" data-target="#modal-reg" value="modal" />

<!-- modal 창 -->
<div class="modal fade" id="modal-reg" role="dialog">
	<div class="modal-dialog modal-dialog-centered modal-xl d-block">
		<button type="button" id="modalCloseBtn" class="btn btn-lg btn-default text-white text-weight-bold display-1 float-right" data-dismiss="modal">&times;</button>
		<div class="modal-content">
			<div class="modal-body bg-light d-flex justify-content-between">
				<div class="post-img border rounded mr-2">
					<div id="demo" class="carousel slide" data-ride="carousel">
                    	<!-- The slideshow -->
                        <div class="carousel-inner Citem">
                        	<!-- 이미지 등록 -->
                        </div>
                        <!-- Left and right controls -->
                        <a class="carousel-control-prev" href="#demo" data-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </a>
                        <a class="carousel-control-next" href="#demo" data-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </a>
                    </div>
				</div>
				<ul class="list-group d-block">
					<li class="list-group-item d-flex row mx-0 mb-1">
						<div class="profile-img-s col-2 px-0 text-center">
							<img src="" alt="" />
						</div>
						
						<div class="col-10">
							<div class="nickname row mx-0">
								<b class="col-8" id="post_nick">nickname</b>
								<a href="/init/post/modify?postNo=" class="btn btn-sm col-2 text-success font-italic modifyBtn">수정</a>
								<a href="/init/post/delete.do?postNo=" class="btn btn-sm col-2 text-danger font-italic deleteBtn">삭제</a>
							</div>
							
							<div class="location"></div>
						</div>
					</li>
					
					
					<li class="list-group-item mb-1">
						<pre class="content"></pre>
						<div class="hashtag d-flex flex-wrap"></div>
					</li>
					
					<li class="list-group-item mb-1 d-flex row mx-0">
						<div class="col-4 likes">
							<c:choose>
								<c:when test ="${empty user}">
									<i class="modal-icon fa-solid fa-heart" data-num=""></i>
								</c:when>

								<c:otherwise>
									<i class="modal-icon fa-solid fa-heart modal-like" data-num=""></i>
								</c:otherwise>
							</c:choose>
							<span id="likeCount" class="ml-2"></span>
						</div>
						<div class="col-4 views">
							<i class="modal-icon fa-regular fa-circle-check"></i>
							<span class="ml-2"></span>	
						</div>
						<div class="col-4 comment_total">
							<i class="modal-icon fa-regular fa-comment-dots"></i>
							<span class="ml-2"></span>
						</div>
					</li>
					
					
					<li class="list-group-item">
                       	<input type="text" class="comment grpl" placeholder="comment" data-value="0">
                       	<button type="button" class="btn btn-sm btn-success addcomment ml-1 px-1 py-0" data-num="" role="button">
							<i class="fa-solid fa-reply"></i>
						</button>
					
						<div class="comments">
						</div>
					</li>

					<li>
						
                    </li>
				</ul>
			</div>
		</div>
	</div>
</div>

<script>

$('.profile-img-s').click(function() {
	var nickname = $('#post_nick').text();
	
	location.href = "/init/feed/otherUser?nick=" + nickname;
});


$(document).on('click', '.profile-img-xxs', function() {
	var nickname = $(this).siblings('.nickname').text();
	
	location.href = "/init/feed/otherUser?nick=" + nickname;
});

</script>
</body>
</html>
