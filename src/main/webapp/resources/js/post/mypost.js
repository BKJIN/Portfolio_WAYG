$(document).ready(function() {
	for (var i = 0; i < 3; i++ ) {
		$('.posts').eq(i).addClass('active');
	}
	
	let postNo = "";
	$(".post").click(function(){
		postNo = $(this).attr("data-value");
		
		$('#modalBtn').trigger('click');
		
		$.ajax({
	           url:"getlist.do",
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
	            var userProfileImg2 = data.userProfileImg;
	            var likes = data.likes;
	            var content = data.content;
	            var comment_total = data.comments;
	            var views = data.views;
				var postDt = data.postDt;
	            var images = data.images.split('/');
	            var postNo = data.postNo;
	            var heartCheck =data.heartCheck;
	            var hashtag;
				
		
				/*if ( userProfileImg2 === '' || userProfileImg2 === null ) {
					$('.profile-img-s img').attr('src', '/init/resources/profileImg/nulluser.svg');
				} else {
					$('.profile-img-s img').attr('src', '/init/resources/profileImg/'+ userProfileImg2);

				}*/
				
				if ( userProfileImg2.indexOf('nulluser.svg') == -1) {
					$('.profile-img-s img').attr('src', '/init/resources/profileImg/'+ userProfileImg2);
				} else {
					$('.profile-img-s img').attr('src', '/init/resources/profileImg/nulluser.svg');
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
	                   	$('.Citem').html('<div class="carousel-item active"><img src="../images/'+images[i]+'"></div>');
	                } else {
	                	$('.Citem').append('<div class="carousel-item"><img src="../images/'+images[i]+'"></div>');
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
		getComments(postNo);
	});
});

$(document).on('click', '.modal-like', function(){
	var element = $(this);
	postNo = $(this).attr('data-num');
	modalLike(element, postNo);
});

function modalLike(element, postNo) {
	$.ajax({
    	url :'addLike.do',
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

$(document).on('click', '.addcomment', function () {
	console.log('진입');
	
	postNo = $(this).attr('data-num');
	let content = $('input.comment').val();
	let grpl = $('.grpl').attr('data-value');
	
	if( content == '' ) {
		return false;
	}
	
	$.ajax({
		url : 'addcomments.do',
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

function getComments(postNo) {
	let comments ="";
	$.ajax({
        url:"getcomments.do",
        data:{postNo:postNo},
        type:"post",
		beforeSend: function(xhr){
	 	  	var token = $("meta[name='_csrf']").attr('content');
	 		var header = $("meta[name='_csrf_header']").attr('content');
		    xhr.setRequestHeader(header, token);
		},
        success:function(data){
			
	       	for(var i=0; i<data.length; i++){
		
				var upimg = data[i].userProfileImg;

				comments += '<div class="comment-block row mx-0 my-1 d-flex">';
				comments +=	'<div class="profile-img-xxs col-1 px-0">';
				comments +=	'<div class="img-xxs">';
				
				/*if ( upimg === '' || upimg === null ) {
					comments += '<img src="/init/resources/profileImg/nulluser.svg"/>';
				} else {
					comments += '<img src="/init/resources/profileImg/' + upimg + '" />';
				}*/
				
				if ( upimg.indexOf('nulluser.svg') == -1) {
					comments += '<img src="/init/resources/profileImg/' + upimg + '" />';
				} else {
					comments += '<img src="/init/resources/profileImg/nulluser.svg"/>';
				}
				
				comments +=	'</div>';
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
					url : 'addReplyComments.do',
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
					url : 'deleteReplyComments.do',
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
}

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

$('#moreBtn').click(function() {
	console.log('진입');
	var curridx = Number($(this).attr('data-currIndex'))+1;
	var maxidx = $(this).attr('data-maxindex');
	var total = $('.posts').length;
	var nextidx= Number(curridx)*3;

	$('#main-body').css('height', 'auto');
	
	if ( curridx < maxidx ) {	
		for( var i = nextidx; i < Number(nextidx)+3; i++ ) {
			$('.posts').eq(i).addClass('active');
		}
		$(this).attr('data-currIndex', Number(curridx)+1);
		
	} else if (curridx == maxidx ) {
		for( var i = nextidx; i < total; i++ ) {
			$('.posts').eq(i).addClass('active');
		}
		$(this).css('display', 'none');
	}
});



function deleteCheck(){
    if(confirm("삭제하시겠습니까?")){
        return true;
    } else {
    	$(".delete").attr('href','post/list');
        return false;
    }
}
