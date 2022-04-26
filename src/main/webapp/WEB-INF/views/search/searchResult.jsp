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
<link rel="stylesheet" type="text/css" href="/init/css/search/searchResult.css" />
<link rel="stylesheet" type="text/css" href="/init/css/includes/footer.css" />
<title>Search Result</title>
<style>
section.container {
	margin-top: 5rem;
	height: auto;

}

.posts {
	width: 100%;
	height: 80%;
	flex-wrap: wrap;
	align-content: flex-start;
}

.posts .post {
	width : 24%;
	height: 24%;
}

 .posts .post-top {
	height: 80%;
	margin-bottom: 2%;
}

.posts .post-bottom {
	height: 18%;
}

img {
	object-fit: cover;
}

.profile-img img {
	border-radius: 50%;
	max-width: 100%;
	max-height: 100%;
}

.post-top {
	max-height: 320px;
	line-height: 320px;
	overflow: hidden;
}

.post-top img {
	max-width: 100%;
	max-heihgt: 100%;
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

#moreBtn {
	width: 95%;
}
</style>

<script>
var totalCount = '<c:out value="${list.size()}" />';

var posts = [];

<c:forEach items="${list}" var="result" >

var post = {
		postNo : "${result.postNo}",
		profileImg : "${result.userProfileImg}",
		titleImg : "${result.titleImage}",
		userNick : "${result.userNick}",
		likes : "${result.likes}",
		views : "${result.views}",
		comments : "${result.comments}"
}


posts.push(post);
</c:forEach>

var email = '<c:out value="${user.userEmail}" />';

</script>

</head>

<body>
<%@ include file="../includes/header.jsp" %>
<section class="container mb-4">
	<div class="posts d-flex justify-content-start mt-2">
	</div>

</section>


<%@ include file="../includes/modalPost.jsp" %>
<%@ include file="../includes/footer.jsp" %>

<script>


if ( posts.length > 20 ) {
	for (var i = 0; i < 20; i++ ) {
		var postBox = '<div class="post mr-2 mb-2" data-value="' + posts[i].postNo + '">'
			+ '<div class="post-top border rounded">'
			+ '<img src="/init/resources/images/' + posts[i].titleImg + '" alt="" />'
			+ '</div>'
			+ '<div class="post-bottom bg-light border">'
			+ '<div class="d-flex pt-1" style="height: 60%">'
			+ '<div class="profile-box col-2 px-0">'
			+ '<div id="post-profile">';
			
			if ( posts[i].userProfileImg == null || posts[i].userProfileImg =='' ) {
				postBox += '<img src=/init/resources/profileImg/nulluser.svg" />';	
			} else {
				postBox += '<img src=/init/resources/profileImg/' + posts[i].userProfileImg + '" />';
			}
			
		postBox += '</div>'
			+ '</div>'
			+ '<div class="col-10 pt-2">'
			+ '<b>' + posts[i].userNick + '</b>'
			+ '</div>'
			+ '</div>'
			+ '<div class="row mx-2 d-flex justify-content-around" style="height: 40%">'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-solid fa-heartmr-1"></i>'
			+ posts[i].likes
			+ '</div>'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-regular fa-circle-check mr-1"></i>'
			+ posts[i].views
			+ '</div>'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-solid fa-comment-dots mr-1"></i>'
			+ posts[i].comments
			+ '</div>'
			+ '</div>'
			+ '</div>'
			+ '</div>';
		$('.posts').append(postBox);

	}
	
	$('.moreBtn').removeClass('d-none');
	$('.moreBtn').attr('data-value', (Number(inx)+1));
	
} else {
	
	for (var i = 0 ; i < posts.length; i++ ) {
		
		var postBox = '<div class="post mr-2 mb-2" data-value="' + posts[i].postNo + '">'
			+ '<div class="post-top border rounded">'
			+ '<img src="/init/resources/images/' + posts[i].titleImg + '" alt="" />'
			+ '</div>'
			+ '<div class="post-bottom bg-light border">'
			+ '<div class="d-flex pt-1" style="height: 60%">'
			+ '<div class="profile-box col-2 px-0">'
			+ '<div id="post-profile">';
			
			if ( posts[i].userProfileImg == null || posts[i].userProfileImg =='' ) {
				postBox += '<img src="/init/resources/profileImg/nulluser.svg" />';	
			} else {
				postBox += '<img src="/init/resources/profileImg/' + posts[i].userProfileImg + '" />';
			}
		
		postBox += '</div>'
			+ '</div>'
			+ '<div class="col-10 pt-2">'
			+ '<b>' + posts[i].userNick + '</b>'
			+ '</div>'
			+ '</div>'
			+ '<div class="row mx-2 d-flex justify-content-around" style="height: 40%">'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-solid fa-heart mr-1"></i>'
			+ posts[i].likes
			+ '</div>'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-regular fa-circle-check mr-1"></i>'
			+ posts[i].views
			+ '</div>'
			+ '<div class="col-4 px-1">'
			+ '<i class="fa-solid fa-comment-dots mr-1"></i>'
			+ posts[i].comments
			+ '</div>'
			+ '</div>'
			+ '</div>'
			+ '</div>';
			
			$('.posts').append(postBox);
			
	}
}


$('.post').click(function() {
	var postNo = $(this).attr("data-value");
	console.log(postNo);
	
	addview(postNo);
	
	$('#modalBtn').trigger('click');
	$.ajax({
           url:"/init/post/getlist.do",
           type:"post",
           data:{
           	postNo : postNo,
			email : email
		},
		
		beforeSend: function(xhr){
 		   	var token = $("meta[name='_csrf']").attr('content');
 			var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
		},
 		success:function(data){
 			$('#modalBtn').trigger('click');
            
 			// data parsing
			var userEmail = data.email;
 			var userNick=data.userNick;
            var userProfileImg = data.userProfileImg;
            var likes = data.likes;
            var content = data.content;
            var comment_total = data.comments;
            var views = data.views;
			var postDt = data.postDt;
            var images = data.images.split('/');
            var postNo = data.postNo;
            var heartCheck =data.heartCheck;
            var hashtag;
			
			if( userProfileImg != null ) {
				$('.profile-img-s img').attr("src", "/init/resources/profileImg/" + userProfileImg);
			} else {
				$('.profile-img-s img').attr("src", "/init/resources/profileImg/nulluser.svg");
			}
			
			
			
			if ( userEmail == email ) {
				$('.modifyBtn').css('display', 'inline-block');
				$('.modifyBtn').attr('href', $('.modifyBtn').attr('href')+postNo)
				$('.deleteBtn').css('display', 'inline-block');
				$('.deleteBtn').attr('href', $('.deleteBtn').attr('href')+postNo)
			} else {
				$('.modifyBtn').css('display', 'none');
				$('.deleteBtn').css('display', 'none');
			}


            if (data.hashtag != null) {
            	hashtag = data.hashtag.split('#');
            }
            // image carousel setting
           	for( var i = 0; i < images.length-1 ; i++ ){
           	    if ( i == 0 ) {
                   	$('.Citem').html('<div class="carousel-item active"><img src="/init/images/'+images[i]+'"></div>');
                } else {
                	$('.Citem').append('<div class="carousel-item"><img src="/init/images/'+images[i]+'"></div>');
                }
            }
							
            if ( postDt != null ) {
               	for ( var i = 0; i < postDt.length; i++ ) {
					console.log(postDt[i].location);
	
           			var item = '<div class="mr-1 px-1 location-item border bg-light rounded">'
							 + '<i class="fa-solid fa-location-dot text-primary"></i>&nbsp;'
						 	 + postDt[i].location
						 	 + '&nbsp</div>';

               		if( i == 0 ) {
			   			$('.location').css('height', '28px');
			   			$('.location').css('display', 'flex');
			   			$('.location').css('flex-wrap', 'nowrap');
            			$('.location').append(item);
               		} else {
               			$('.location').append(item);
               		}
               	}
            }
               
               // heart 확인해서 좋아요 누른 게시물은 active 부여
           	if( heartCheck == 1 ) {
           		$('i.modal-like').addClass('active');
           	}
           	
            if ( hashtag != null) {
			   	for ( var i = 1; i < hashtag.length; i++ ) {

					var item = '<div class="mr-1 px-1 hashtag-item border bg-light rounded font-italic">'
							 + '#&nbsp;' + hashtag[i]
						 	 + '&nbsp</div>';

               		if( i == 1 ) {
               			$('div.hashtag').html(item);
               		} else {
               			$('div.hashtag').append(item);
               		}
               	}
            }
            
            $(".nickname>b").html(userNick);
            $(".content").html(content);
            $(".comment_total span").html(comment_total);
            $('.likes span').html(likes);
            $('.likes i.modal-like').attr('data-num', postNo);
            $('button.addcomment ').attr('data-num', postNo);
            $(".views span").html(views);
           	
 		},
 		error: function(data) {
 			console.log("ajax1 처리 실패");
 		}
	});
	getComments(postNo, email);
});


function getComments(postNo, email) {
	let comments ="";
	$.ajax({
	    url:"/init/post/getcomments.do",
	    data:{postNo:postNo},
	    type:"post",
		beforeSend: function(xhr){
	 	  	var token = $("meta[name='_csrf']").attr('content');
	 		var header = $("meta[name='_csrf_header']").attr('content');
		    xhr.setRequestHeader(header, token);
		},
	    success:function(data){
	
	       	for(var i=0; i<data.length; i++){
				comments += '<div class="comment-block row mx-0 my-1 d-flex">';
				comments +=	'<div class="profile-img-xxs col-1 px-0">';
				comments +=	'<div class="img-xxs">';
				if ( data[i].userProfileImg != null ) {
					comments +=	'<img src="/init/resources/profileImg/' + data[i].userProfileImg + '" />';					
				} else {
					comments +=	'<img src="/init/resources/profileImg/nulluser.svg" />';
				}
				comments += '</div>';
				comments +=	'</div>';
				comments +=	'<span class="col-3 pl-1 nickname" style="font-size: 14px; font-weight: 600;">' + data[i].userNick + '</span>';
	           	comments += '<span class="col-6 px-0 comment-text" style="font-size: 13px;">'+data[i].content+'</span>';
					
				if(email!=="" && email!==null && email!=="null"){
					comments += '<span class="replyClick col-1 px-0" data-count="0" style="font-size: 5px; cursor : pointer;">답글</span>';
				}
				if(email===data[i].email){
					comments += '<i class="fa-solid fa-x deleteRe" style="font-size:5px; color:red; cursor : pointer;" data-no="'+data[i].commentNo+'"></i><br/>';
				}
	
				comments += '<div class="form-group replyform col-12 row mx-0">';
				comments += '<input type="text" class="col-10 recomment" data-grp="'+data[i].grp+'" data-grpl="'+data[i].grpl+'" data-grps="'+data[i].grps+'" placeholder="recomment">';
				comments += '<button type="button" class="btn btn-sm btn-success addreplyComment ml-1 px-1 py-0" data-num="" role="button">'
				comments += '<i class="fa-solid fa-reply"></i>'
				comments += '</button>';
				comments += '</div>';
				comments += '</div>';
				comments += '</div>';
	        }
	           	
			$('.comments').html(comments);
	
			$('.replyClick').click(function () { //re댓글 작성
				var count = $(this).attr('data-count');
				if ( count == 0 ) {
					$('.replyform').css('display', 'none');
					$('.replyClick').attr('data-count', 0);
					$(this).siblings('.replyform').css('display', 'flex');
					$(this).attr('data-count', Number(count)+1);
				} else {
					$(this).siblings('.form-group').css('display', 'none');
					$(this).attr('data-count', 0);
				}
			});
				
			$('.addreplyComment').click(function () {
				let content ='<b class="font-italic">@' + $(this).parent().siblings('span.nickname').text() + "</b>&nbsp;&nbsp;" + $(this).siblings('.recomment').val();
				let grp = $(this).siblings('.recomment').attr('data-grp');
				let grpl = $(this).siblings('.recomment').attr('data-grpl');
				let grps = $(this).siblings('.recomment').attr('data-grps');
				console.log(email);
	
				$.ajax({
					url : '/init/post/addReplyComments.do',
					type : 'post',
					data : {postNo : postNo,
							content : content,
							grp : grp,
							grpl : grpl,
							grps : grps,
							email : email},
					beforeSend: function(xhr){
				 	  	var token = $("meta[name='_csrf']").attr('content');
				 		var header = $("meta[name='_csrf_header']").attr('content');
			 		    xhr.setRequestHeader(header, token);
			 		},
			 		success : function () {
			 			console.log('success');
			 			getComments(postNo);
					},
					error : function () {
						console.log('ERROR');
					}
				});
			});
	
			
			$('.deleteRe').click(function () { //re댓글 삭제
				let target = $(this);
				let commentNo = $(this).attr('data-no');
			
				$.ajax({
					url : '/init/post/deleteReplyComments.do',
					type : 'post',
					data : {commentNo : commentNo},
					beforeSend: function(xhr){
				 	  	var token = $("meta[name='_csrf']").attr('content');
				 		var header = $("meta[name='_csrf_header']").attr('content');
			 		    xhr.setRequestHeader(header, token);
			 		},
			 		success : function () {
			 			console.log('success');
			 			getComments(postNo);
					},
					error : function () {
						console.log('ERROR');
					}
					
				});
			});
	 	},
	 	error:function(){
	    	console.log("ajax 처리 실패");
	 	}
	});



};


$(document).on('click', '.modal-like', function(){
	var element = $(this);
	postNo = $(this).attr('data-num');
	modalLike(element, postNo);
});



function modalLike(element, postNo) {
	$.ajax({
		url :'/init/post/addLike.do',
	 	data : {
	    	postNo : postNo,
	        email : email
	    },
	 	type : 'post',
	 	beforeSend: function(xhr){
	    	var token = $("meta[name='_csrf']").attr('content');
	    	var header = $("meta[name='_csrf_header']").attr('content');
	    	xhr.setRequestHeader(header, token);
	 	},
		success : function(info) {
	    	if ( info == 'add' ) {
	       		element.addClass('active');
	       		element.siblings('#likeCount').text(Number(element.siblings('#likeCount').text())+1);
	    	} else {
	       		element.removeClass('active');
	       		element.siblings('#likeCount').text(Number(element.siblings('#likeCount').text())-1);
			    }
	    	console.log('하트날리기 성공');   
		},
		
	 	error : function () {
	    	console.log('하트날리기 실패');
		}
	});
};


function addview(postNo){
	//console.log(postNo);
	$.ajax({
		url :'/init/post/addView.do',
		data : {
			postNo : postNo,
			email : email
			},
		type : 'post',
		beforeSend: function(xhr){
	 	   	var token = $("meta[name='_csrf']").attr('content');
	 		var header = $("meta[name='_csrf_header']").attr('content');
 		    xhr.setRequestHeader(header, token);
 		},
		success : function () {
		},
		error : function () {
			//console.log('failed view up');
		}
	})
};


$(document).on('click', '.addcomment', function () {
	console.log('진입');
	
	postNo = $(this).attr('data-num');
	let content = $('input.comment').val();
	let grpl = $('.grpl').attr('data-value');
	
	if( content == '' ) {
		return false;
	}
	
	$.ajax({
		url : '/init/post/addcomments.do',
		type : 'post',
		data : {postNo : postNo,
				content : content,
				grpl : grpl,
				email : email},
		beforeSend: function(xhr){
	 	  	var token = $("meta[name='_csrf']").attr('content');
	 		var header = $("meta[name='_csrf_header']").attr('content');
			    xhr.setRequestHeader(header, token);
			},
			success : function () {
				console.log('success');
				getComments(postNo);
			
				$('.comment').val('');
				
				console.log($('.comment-block').length);
				
				$('div.comment_total>span').text(Number($('.comment-block').length)+1);
		},
		error : function () {
			console.log('ERROR');
		}
		
	});
});



$(document).on('hidden.bs.modal', '#modal-reg', function() {
	console.log('진입');
	$(".nickname b").html('');
	$(".content").html('');
	$('.hashtag').children('span').remove();
	$(".comment_total span").html('');
	$('.likes span').html('');
	$('.likes i.modal-like').attr('data-num', '');
	$('button.addcomment ').attr('data-num', '');
	$(".views span").html('');
	$('i.modal-like').removeClass('active');
	$('.Citem').children('div.carousel-item').remove();
	$('div.location').children('div.location-item').remove();
	$('div.location').removeAttr('style');
	$('.comments').children('div.comment-block').remove();
	
	$('a.modifyBtn').attr('href', 'modify?postNo=');
	$('a.deleteBtn').attr('href', 'delete.do?postNo=');
});




	
</script>
</body>
</html>
