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
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
<style>
body{margin-top:20px;}
.card {
	overflow: hidden;
}
.addedUserInfo {
	border: none;
	border-top: 1px solid rgba(0,0,0,.125);
	border-bottom: 1px solid rgba(0,0,0,.125);
	border-radius: 0;
}
#searchAndUser {
	padding-right: 0px;
	overflow-x: hidden;
	max-height:939px; 
	overflow-y:auto;
	height: expression( this.scrollHeight > 938 ? "939px" : "auto" ); /*IE에서 max-height */
}
#searchNick {
	border: none;
	border-radius: 0;
	border-bottom: 2px solid rgba(0,0,0,.125);
}
.chat-messages {
    display: flex;
    flex-direction: column;
    max-height: 800px;
    height:800px;
    overflow-y: auto;
    height: expression( this.scrollHeight > 799 ? "800px" : "auto" ); /*IE에서 max-height */
}

.chat-message-left {
    margin-right: auto;
    display: flex;
    flex-shrink: 0
}
.chat-message-right {
    margin-left: auto;
    display: inline-block;
}
.py-3 {
    padding-top: 1rem!important;
    padding-bottom: 1rem!important;
}
.px-4 {
    padding-right: 1.5rem!important;
    padding-left: 1.5rem!important;
}
.flex-grow-0 {
    flex-grow: 0!important;
}
.border-top {
    border-top: 1px solid #dee2e6!important;
}
#appOtherImg {
	height:50px;
}

#inputMsg {
	visibility: hidden;
}

#newMsg {
	width:150px;
	height:24px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>
</head>
<body>

<%@ include file="../includes/header.jsp" %>

<main class="content" style="margin-top:90px; margin-bottom:50px;">
    <div class="container p-0">
    
	<!-- modal창 -->
	<div class="modal fade" id="rmvModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WAYG</h4>
				</div>
				<div class="modal-body bg-light">
					대화방을 나가면 모든 대화내용이 삭제되며 다시 복구 할 수 없습니다.
				</div>
				<div class="modal-footer bg-light">
					<button id="agreeRmv" type="button" class="btn btn-default btn-danger">나가기</button>
					<button id="rmvCloseBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
		<div class="card">
			<div class="row g-0">
				<div id="searchAndUser" class="col-12 col-lg-5 col-xl-3">
					<div class="px-4">
						<div class="d-flex align-items-center">
							<div class="flex-grow-1">
								<input id="searchNick" type="text" class="form-control my-3" placeholder="회원 검색">
							</div>
						</div>
					</div>
					
					<a href="#" id="foundUserInfo" class="list-group-item list-group-item-action " style="display:none;">
						<button id="createChat" style="all:unset;" class="float-right"><i class="fa-solid fa-message"></i></button>
						<div class="d-flex align-items-start">
							<img id="foundUserImg" class="rounded-circle mr-1" width="40" height="40">
							<div id="foundUserNick" class="flex-grow-1 ml-3">
							</div>
						</div>
					</a>
					
					<div id="userList" class="list-group d-flex justify-content-around">
						<c:forEach items="${chatRoomList}" var="dto">
						<button class="addedUserInfo ${dto.roomId} list-group-item list-group-item-action mb-1" style="display:none; position:relative;">
							<div class="rId" style="display:none;">${dto.roomId}</div>
							<div id="addedUserLook" class="d-flex align-items-center">
								<c:choose>
									<c:when test="${fn:contains(dto.roomImg, 'nulluser.svg')}">
										<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40" alt="" />
									</c:when>
							
									<c:otherwise>
										<img src="/init/resources/profileImg/${dto.roomImg}" class="rounded-circle mr-1" width="40" height="40" alt="" />
									</c:otherwise>
								</c:choose>
								<div class="addedUserNicks flex-grow-1 ml-3">
									<b>${dto.chatRoom}</b>
									<div id="newMsg">${dto.recentMsg}</div>
								</div>
								<c:choose>
									<c:when test="${dto.newMsgNum eq 0}">
										<div id="unReadMsg" class="badge bg-success"></div>
									</c:when>
									<c:otherwise>
										<div id="unReadMsg" class="badge bg-success">${dto.newMsgNum}</div>
									</c:otherwise>
								</c:choose>
							</div>
						</button>
						</c:forEach>
					
					</div>
					<hr class="d-block d-lg-none mt-1 mb-0">
				</div>
				<div class="col-12 col-lg-7 col-xl-9 border-left px-0">
					<div id="chatroom-title" class="py-2 px-4 border-bottom bg-light">
						<div id="appOtherImg" class="d-flex align-items-center py-1">
						</div>
					</div>

					<div class="position-relative">
						<div id="msgArea" class="chat-messages p-4">
						</div>
					</div>

					<div id="inputMsg" class="flex-grow-0 py-3 px-4 border-top">
						<div class="input-group">
							<input id="msg" type="text" class="form-control" placeholder="Type your message">
							<button id="button-send" class="btn btn-primary" disabled>Send</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</main>

<%@ include file="../includes/footer.jsp" %>

<script>
/* function check() {
	console.log("1");
} */
$(document).ready(function() {
	var userInfo;
	$("#searchNick").keyup(function(){
		var val = $("#searchNick").val();
		$.ajax({
			type : "get",
			url : "searchNick",
			data : {nick:val},
			success : function(data) {
				console.log(data)
				if(data.userNick != null) {
					$("#foundUserInfo").css("display","block");
					if(data.userProfileImg.indexOf('nulluser.svg') == -1) {
						$("#foundUserImg").attr("src","/init/resources/profileImg/"+data.userProfileImg);
					} else {
						$("#foundUserImg").attr("src","/init/resources/profileImg/nulluser.svg");
					}
					$("#foundUserNick").html(data.userNick);
					userInfo = {userNick:data.userNick, userImg:data.userProfileImg}
				} else {
					$("#foundUserInfo").css("display","none");
				}
			},error : function() {
				alert("에러입니다. 다시 시도해주세요.");
			}
		});
	});
	
	$("#createChat").click(function() {
		$.ajax({
			type : "POST",
			url : "croom",
			data: {subNick: userInfo.userNick, subImg: userInfo.userImg},
			beforeSend: function(xhr){
		    	var token = $("meta[name='_csrf']").attr('content');
		    	var header = $("meta[name='_csrf_header']").attr('content');
		    	xhr.setRequestHeader(header, token);
		    },
			success: function(data) {
				if(data.search("existRoom") > -1) {
					alert("이미 채팅방이 존재 합니다.");
				}
				else {
					location.reload();
				}
				
			},error: function() {
				alert("채팅방 생성 에러입니다. 다시 시도해 주세요.");
			}
			
		});
	});
	
	var uId = "${uId}";
	console.log(uId)
	if("${chatRoomList}" != null) {
		$(".addedUserInfo").css("display","block");
	} 
	
	var sockJs = new SockJS("/init/chat");
	var stomp = Stomp.over(sockJs);
	
	var roomId;
	var pubId;
	var pubImg;
	var pubNick;
	var subId;
	var subImg;
	var subNick;
	
	stomp.connect({}, function(){
		console.log("STOMP Connection");
		
		stomp.subscribe("/sub/chat/" + uId, function(chat) {
			console.log("실시간 알림 받음");
			var content = JSON.parse(chat.body);
			var str = '';
			var msg;
			var one	= 1;
			
			if(content.m_pubMsg == null) {
				msg = content.m_subMsg;
			} else {
				msg = content.m_pubMsg;
			}
			
			if($(".addedUserInfo." + content.m_roomId).children("div:first").html() == content.m_roomId) {
  				$(".addedUserInfo." + content.m_roomId).find("#newMsg").html(msg);
  				$(".addedUserInfo." + content.m_roomId).find("#unReadMsg").html(+$(".addedUserInfo." + content.m_roomId).find("#unReadMsg").html() + one);
			} else {
				if(uId == content.m_pubId) {
					str = '<button class="addedUserInfo ' + content.m_roomId + ' list-group-item list-group-item-action mb-1">'
					str += '<div class="rId" style="display:none;">' + content.m_roomId + '</div>'
					str += '<div id="addedUserLook" class="d-flex align-items-center">'
					if(content.m_subImg.indexOf('nulluser.svg') == -1) {
						str += '<img src="/init/resources/profileImg/' + content.m_subImg + '" class="rounded-circle mr-1" width="40" height="40">'
					} else {
						str += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
					}
					str += '<div class="addedUserNicks flex-grow-1 ml-3">'
					str += '<b>' + content.m_subNick + '</b>'
					str += '<div id="newMsg">' + msg + '</div>'
					str += '</div>'
					str += '<div id="unReadMsg" class="badge bg-success">' + 1 + '</div>'
					str += '</div>'
					str += '</button>'
					$("#userList").append(str);
				} else {
					str = '<button class="addedUserInfo ' + content.m_roomId + ' list-group-item list-group-item-action mb-1">'
					str += '<div class="rId" style="display:none;">' + content.m_roomId + '</div>'
					str += '<div id="addedUserLook" class="d-flex align-items-center">'
					if(content.m_pubImg.indexOf('nulluser.svg') == -1) {
						str += '<img src="/init/resources/profileImg/' + content.m_pubImg + '" class="rounded-circle mr-1" width="40" height="40">'
					} else {
						str += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
					}
					str += '<div class="addedUserNicks flex-grow-1 ml-3">'
					str += '<b>' + content.m_pubNick + '</b>'
					str += '<div id="newMsg">' + msg + '</div>'
					str += '</div>'
					str += '<div id="unReadMsg" class="badge bg-success">' + 1 + '</div>'
					str += '</div>'
					str += '</button>'
					$("#userList").append(str);
				}
			}
			
		});
		
		$(document).on("click",".addedUserInfo",function(){
		//$(".addedUserInfo").click(function(){
			$(".addedUserInfo").attr("disabled",true);
			//$(".addedUserInfo").not(this).css("display","block");
			$("#inputMsg").css("visibility", "visible");
			$("#searchAndUser").css("visibility","hidden");
			$("#msgArea").empty();
			$.ajax({
				type: "POST",
				url : "room",
				data: {roomId:$(this).children("div:first").html()},
				beforeSend: function(xhr){
			    	var token = $("meta[name='_csrf']").attr('content');
			    	var header = $("meta[name='_csrf_header']").attr('content');
			    	xhr.setRequestHeader(header, token);
			    },
			    success: function(data) {
			    	console.log("채팅방 입장 성공");
			    	
			    	pubId = data.cdto.pubId;
			    	pubImg = data.cdto.pubImg;
			    	pubNick = data.cdto.pubNick;
			    	subId = data.cdto.subId;
			    	subImg = data.cdto.subImg;
			    	subNick = data.cdto.subNick;
			    	roomId = data.cdto.roomId;
			    	
			    	if(uId == pubId) {
			    		var otherImg = subImg;
			    		var str = '';
			    		str = '<div class="position-relative">';
			    		if(otherImg.indexOf('nulluser.svg') == -1) {
							str += '<img src="/init/resources/profileImg/' + otherImg + '" class="rounded-circle mr-1" width="40" height="40">'
						} else {
							str += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
						}
						str += '</div>';
			    		str += '<div class="flex-grow-1 pl-3">';
						str += '<strong>' + subNick + '</strong>';
						str += '</div>';
						str += '<button class="exitRoom mr-3" style="all:unset; cursor:pointer;">'
						str += '<i class="fa-solid fa-list" style="font-size:2rem"></i>';
						str += '</button>'
						str += '<button class="removeRoom" style="all:unset; cursor:pointer;" data-toggle="modal" data-target="#rmvModal" value="modal">'
						str += '<i class="fa-solid fa-person-walking-dashed-line-arrow-right" style="font-size:2rem"></i>';
						str += '</button>'
						$("#appOtherImg").empty().append(str);
			    	} else {
			    		var otherImg = pubImg;
			    		var str = '';
			    		str = '<div class="position-relative">';
			    		if(otherImg.indexOf('nulluser.svg') == -1) {
							str += '<img src="/init/resources/profileImg/' + otherImg + '" class="rounded-circle mr-1" width="40" height="40">'
						} else {
							str += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
						}
						str += '</div>';
			    		str += '<div class="flex-grow-1 pl-3">';
						str += '<strong>' + pubNick + '</strong>';
						str += '</div>';
						str += '<button class="exitRoom mr-3" style="all:unset; cursor:pointer;">'
						str += '<i class="fa-solid fa-list" style="font-size:2rem"></i>';
						str += '</button>'
						str += '<button class="removeRoom" style="all:unset; cursor:pointer;" data-toggle="modal" data-target="#rmvModal" value="modal">'
						str += '<i class="fa-solid fa-person-walking-dashed-line-arrow-right" style="font-size:2rem"></i>';
						str += '</button>'
						$("#appOtherImg").empty().append(str);
			    	}
			    	
			   		for(var i = 0; i < data.mdtos.length; i++) {
			   			var str = '';
						var str1 = '';
						
			   			if(uId == data.mdtos[i].m_pubId) {
							if(data.mdtos[i].m_pubMsg != null) {
			   					str = '<div class="chat-message-right">';
								str += '<div class="bg-light rounded py-2 px-3" style="text-align:right;">';
								str += data.mdtos[i].m_pubMsg;
								str += '</div>';
								str += '</div>';
								str += '<div class="text-muted small text-nowrap pb-4" style="text-align:right;">' + data.mdtos[i].m_sendTime + '</div>';
								$("#msgArea").append(str);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
							if(data.mdtos[i].m_subMsg != null) {
								str1 = '<div class="chat-message-left pb-4">';
								str1 += '<div>';
								if(data.mdtos[i].m_subImg.indexOf('nulluser.svg') == -1) {
									str1 += '<img src="/init/resources/profileImg/' + data.mdtos[i].m_subImg + '" class="rounded-circle mr-1" width="40" height="40">'
								} else {
									str1 += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
								}
								str1 += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str1 += '</div>';
								str1 += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
								str1 += '<div class="font-weight-bold mb-1">' + data.mdtos[i].m_subNick + '</div>';
								str1 += data.mdtos[i].m_subMsg;
								str1 += '</div>';
								str1 += '</div>';
								$("#msgArea").append(str1);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
						} else {
							if(data.mdtos[i].m_subMsg != null) {
								str = '<div class="chat-message-right">';
								str += '<div class="bg-light rounded py-2 px-3" style="text-align:right;">';
								str += data.mdtos[i].m_subMsg;
								str += '</div>';
								str += '</div>';
								str += '<div class="text-muted small text-nowrap pb-4" style="text-align:right;">' + data.mdtos[i].m_sendTime + '</div>';
								$("#msgArea").append(str);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
							if(data.mdtos[i].m_pubMsg != null) {
								str1 = '<div class="chat-message-left pb-4">';
								str1 += '<div>';
								if(data.mdtos[i].m_pubImg.indexOf('nulluser.svg') == -1) {
									str1 += '<img src="/init/resources/profileImg/' + data.mdtos[i].m_pubImg + '" class="rounded-circle mr-1" width="40" height="40">'
								} else {
									str1 += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
								}
								str1 += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str1 += '</div>';
								str1 += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
								str1 += '<div class="font-weight-bold mb-1">' + data.mdtos[i].m_pubNick + '</div>';
								str1 += data.mdtos[i].m_pubMsg;
								str1 += '</div>';
								str1 += '</div>';
								$("#msgArea").append(str1);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
						}
			   		}
			    	
			    	stomp.subscribe("/sub/chat/room/" + roomId, function(chat) {
						console.log("메세지 받음");
						var content = JSON.parse(chat.body);
						var str = '';
						var msg;
						var img;
						var nick;
						
						if(content.m_pubMsg == null) {
							msg = content.m_subMsg;
						} else {
							msg = content.m_pubMsg;
						}
						
						if(uId == pubId) {
							img = content.m_subImg;
							nick = content.m_subNick;
						} else {
							img = content.m_pubImg;
							nick = content.m_pubNick;
						}
						
						if(uId == content.m_sendId) {
							str = '<div class="chat-message-right">';
							str += '<div class="bg-light rounded py-2 px-3" style="text-align:right;">';
							str += msg;
							str += '</div>';
							str += '</div>';
							str += '<div class="text-muted small text-nowrap pb-4" style="text-align:right;">' + content.m_sendTime + '</div>';
							$("#msgArea").append(str);
							$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
						}
						else {
							str = '<div class="chat-message-left pb-4">';
							str += '<div>';
							if(img.indexOf('nulluser.svg') == -1) {
								str += '<img src="/init/resources/profileImg/' + img + '" class="rounded-circle mr-1" width="40" height="40">'
							} else {
								str += '<img src="/init/resources/profileImg/nulluser.svg" class="rounded-circle mr-1" width="40" height="40">'
							}
							str += '<div class="text-muted small text-nowrap mt-2">' + content.m_sendTime + '</div>';
							str += '</div>';
							str += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
							str += '<div class="font-weight-bold mb-1">' + nick + '</div>';
							str += msg;
							str += '</div>';
							str += '</div>';
							$("#msgArea").append(str);
							$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
						}
						
						$.ajax({
							type: "POST",
							url : "resetUnreadMsg",
							data: {roomId:content.m_roomId, pubId:content.m_pubId, subId:content.m_subId},
							beforeSend: function(xhr){
						    	var token = $("meta[name='_csrf']").attr('content');
						    	var header = $("meta[name='_csrf_header']").attr('content');
						    	xhr.setRequestHeader(header, token);
						    },
						    success: function(data) {
						    	
						    }, error : function() {
								alert("서버에러로 안읽은 메세지 갯수를 초기화하지 못했습니다.");
						    }
						});
			
					});
		
			    },error: function() {
			    	alert("채팅방 입장 에러입니다. 다시 시도해주세요.");
			    }
			});		
				
		});	
			
	});
	
	$(document).on("click",".exitRoom",function(){
		location.reload();
	});
	
	$("#agreeRmv").click(function(){
		if(uId == pubId) {
		$.ajax({
			type : "POST",
			url: "rmvRoomByPub",
			data: {roomId:roomId},
			beforeSend: function(xhr){
		    	var token = $("meta[name='_csrf']").attr('content');
		    	var header = $("meta[name='_csrf_header']").attr('content');
		    	xhr.setRequestHeader(header, token);
		    },
		    success: function(data) {
		    	location.reload();
		    },
		    error: function() {
		    	alert("채팅방 나가기 에러입니다. 다시 시도해주세요.");
		    }
			
		});
			
		} else {
			$.ajax({
				type : "POST",
				url: "rmvRoomBySub",
				data: {roomId:roomId},
				beforeSend: function(xhr){
			    	var token = $("meta[name='_csrf']").attr('content');
			    	var header = $("meta[name='_csrf_header']").attr('content');
			    	xhr.setRequestHeader(header, token);
			    },
			    success: function(data) {
			    	location.reload();
			    },
			    error: function() {
			    	alert("채팅방 나가기 에러입니다. 다시 시도해주세요.");
			    }
				
			});
		}
	});
	
	$("#button-send").on("click", function(e){
		$("#msg").focus();
		var msg = document.getElementById("msg");
		var today = new Date();
		var sendTime = today.toLocaleString();
		
		if(uId==pubId) {
		stomp.send('/pub/chat/message', {}, JSON.stringify({m_roomId: roomId, m_pubId: pubId, m_pubNick: pubNick, m_subId: subId, m_subNick: subNick, m_sendTime: sendTime, m_pubImg: pubImg, m_subImg: subImg, m_sendId: uId, m_pubMsg: msg.value }));
		} else {
		stomp.send('/pub/chat/message', {}, JSON.stringify({m_roomId: roomId, m_pubId: pubId, m_pubNick: pubNick, m_subId: subId, m_subNick: subNick, m_sendTime: sendTime, m_pubImg: pubImg, m_subImg: subImg, m_sendId: uId, m_subMsg: msg.value }));
		}
		msg.value = '';
	});
	
	$('#msg').keypress(function(event){
		if ( event.which == 13 ) {
	     	$('#button-send').click();
	        return false;
	     }
	});
	
	$("#msg").keyup(function(){
		if($("#msg").val()=='')
			$("#button-send").attr("disabled",true);
		else
			$("#button-send").attr("disabled",false);
	});
				
});
</script>
</body>
</html>