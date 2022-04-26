//메인 필터객체 생성
var mainFilter = document.querySelector('.main-filter');
//메인 필터 객체에 변화가 생겼을 때 이벤트가 실행될 수 있는 onchange이벤트 생성
mainFilter.onchange = function(){
	var subFilter = document.querySelector('.sub-filter');
	var mainOption = mainFilter.options[mainFilter.selectedIndex].innerText;
	//서브필터의 option 생성	
	var subOption = {
		allMarker : ['All Places'],
		place : ['관광명소', '숙박', '음식점', '카페', '병원', '약국', '대형마트', '편의점', '어린이집, 유치원', '학교', '학원', '주차장', '주유소, 충전소', '지하철역', '은행', '문화시설', '공공기관'],
		address : ['서울', '부산', '제주', '경기', '인천', '강원', '경상', '전라', '충청', '전남', '전북', '대전', '강원', '대구', '경북'],
		transportation : ['도보', '자가용', '고속/시외/시내버스', '지하철', '자전거', '택시', '전세/관광버스', '차량대여/렌트', '오토바이', '전동킥보드', '비행기', '선박', '기타'],
		theme : ['방문', '데이트', '가족여행', '친구들과', '맛집탐방', '비즈니스', '소개팅', '미용', '운동', '문화생활', '여가생활']
	}
	
	//메인옵션 선택에 따라 서브옵션 select
	switch(mainOption){
		case '모두보기' : 
			var subOption = subOption.allMarker;
			break;
		case '장소' : 
			var subOption = subOption.place;
			break; 
		case '지역' : 
			var subOption = subOption.address;
			break;
		case '이동수단' : 
			var subOption = subOption.transportation;
			break;
		case '테마' : 
			var subOption = subOption.theme;
			break;
	}
	
	subFilter.options.length = 0;
	
	for(var i=0; i < subOption.length; i++){ //생성된 서브옵션 수 만큼 option태그 생성
		var option = document.createElement('option');
		option.innerText = subOption[i]; // 생성된 option 태그에 서브옵션의 값 넣기
		subFilter.append(option); // 서브필터에 option태그 넣기
	}
}
//검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성
var infowindow = new kakao.maps.InfoWindow({zIndex:1});
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
    center: new kakao.maps.LatLng(37, 127), // 지도의 중심좌표
    level: 13 // 지도의 확대 레벨
};
var map = new kakao.maps.Map(mapContainer, mapOption);
map.setMaxLevel(13); //지도 확대 최대 레벨
//마커 클러스터러를 생성합니다 
var clusterer = new kakao.maps.MarkerClusterer({
    map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
    averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
    minLevel: 10, // 클러스터 할 최소 지도 레벨
    disableClickZoom: true, // 클러스터 마커를 클릭했을 때 지도가 확대 되도록 설정한다
    calculator: [10, 20, 30], // 클러스터의 크기 구분 값(10개, 20개, 30개 마다 다르게), 각 사이값마다 설정된 text나 style이 적용된다
    styles: [{ // calculator 각 사이 값 마다 적용될 스타일을 지정한다
        width : '30px', height : '30px',
        background: 'rgba(51, 204, 255, .8)',
        borderRadius: '15px',
        color: '#000',
        textAlign: 'center',
        fontWeight: 'bold',
        lineHeight: '31px'
    },
    {
        width : '40px', height : '40px',
        background: 'rgba(255, 153, 0, .8)',
        borderRadius: '20px',
        color: '#000',
        textAlign: 'center',
        fontWeight: 'bold',
        lineHeight: '41px'
    },
    {
        width : '50px', height : '50px',
        background: 'rgba(255, 51, 204, .8)',
        borderRadius: '25px',
        color: '#000',
        textAlign: 'center',
        fontWeight: 'bold',
        lineHeight: '51px'
    },
    {
        width : '60px', height : '60px',
        background: 'rgba(255, 80, 80, .8)',
        borderRadius: '30px',
        color: '#000',
        textAlign: 'center',
        fontWeight: 'bold',
        lineHeight: '61px'
    }
	]
});
 $('#filterbtn').click(function(e){
	e.preventDefault(); 
	
	var userId = $("#user_id").text(); //사용자의 id
	var value1; //plandate 컬럼 
	var value2; //plandate의 값
	
  	if($("#plandate").val() == ""){ //날짜 선택 안할 시 전체 날짜 표시를 위해 컬럼 = 1, 값 = '1' 설정
  		value1 = "1";
		value2 = "1";
	}
  	else{ //날짜를 선택하면 컬럼에 plandate, 값에 선택한 날짜 입력
  		value1 = "plandate";
  		value2 = $("#plandate").val();
  	}
	
	//서브 필터 값
	var value3 = $('.main-filter').val(); // 메인필터 값(컬럼이름)
	var subOption = $('.sub-filter').val(); 
	var value4 = subOption; //서브필터 값(컬럼의 값)
	
	switch(subOption){ // DB에는 카테고리의 code값이 들어가므로 서브옵션의 값을 code로 변경
		case "대형마트" : value4 = "MT1";
		break;
		case "편의점" : value4 = "CS2";
		break;
		case "어린이집, 유치원" : value4 = "PS3";
		break;
		case "학교" : value4 = "SC4";
		break;
		case "학원" : value4 = "AC5";
		break;
		case "주차장" : value4 = "PK6";
		break;
		case "주유소, 충전소" : value4 = "OL7";
		break;
		case "지하철역" : value4 = "SW8";
		break;
		case "은행" : value4 = "BK9";
		break;
		case "문화시설" : value4 = "CT1";
		break;
		case "중개업소" : value4 = "AG2";
		break;
		case "공공기관" : value4 = "PO3";
		break;
		case "관광명소" : value4 = "AT4";
		break;
		case "숙박" : value4 = "PO3";
		break;
		case "음식점" : value4 = "FD6";
		break;
		case "카페" : value4 = "CE7";
		break;
		case "병원" : value4 = "HP8";
		break;
		case "약국" : value4 = "PM9";
		break;
		case "All Places" : value4 = "1";
		break;
	}
	clusterer.clear(); //이전에 생성된 마커들 제거 
	
	console.log(userId, value1, value2, value3, value4);
	$.ajax({
			url : "getAllPlansMap.do",
			type : "post",
			data: {"userId" : userId, "value1" : value1, "value2" : value2, "value3" : value3, "value4" : value4},
			beforeSend: function(xhr){
	 		   	var token = $("meta[name='_csrf']").attr('content');
	 			var header = $("meta[name='_csrf_header']").attr('content');
			        xhr.setRequestHeader(header, token);
			},
			success: function(data) {
				var post = data[0];
				clusterer.clear(); //이전에 생성된 마커들 제거
		
				var markers =[]; // markers를 배열로 선언
				for (var i = 0; i < data[1].length; i++ ) {
					var marker = new kakao.maps.Marker({  //반복문에서 생성하는 marker 객체를 markers에 추가
			            position: new kakao.maps.LatLng(data[1][i].latitude, data[1][i].longitude) // 마커를 표시할 위치
			        })
					markers.push(marker);
					
				switch(data[1][i].category){ // DB에는 카테고리의 code값이 들어가므로 code를 카테고리 명으로 변경
					case "MT1" : data[1][i].category = "대형마트";
					break;
					case "CS2" : data[1][i].category = "편의점";
					break;
					case "PS3" : data[1][i].category = "어린이집, 유치원";
					break;
					case "SC4" : data[1][i].category = "학교";
					break;
					case "AC5" : data[1][i].category = "학원";
					break;
					case "PK6" : data[1][i].category = "주차장";
					break;
					case "OL7" : data[1][i].category = "주유소, 충전소";
					break;
					case "SW8" : data[1][i].category = "지하철역";
					break;
					case "BK9" : data[1][i].category = "은행";
					break;
					case "CT1" : data[1][i].category = "문화시설";
					break;
					case "AG2" : data[1][i].category = "중개업소";
					break;
					case "PO3" : data[1][i].category = "공공기관";
					break;
					case "AT4" : data[1][i].category = "관광명소";
					break;
					case "PO3" : data[1][i].category = "숙박";
					break;
					case "FD6" : data[1][i].category = "음식점";
					break;
					case "CE7" : data[1][i].category = "카페";
					break;
					case "HP8" : data[1][i].category = "병원";
					break;
					case "PM9" : data[1][i].category = "약국";
					break;
				}
				
				const feedMapObj = {
					planDtNum : data[1][i].planDtNum,
					placeName : data[1][i].placeName,
					address : data[1][i].address,
					theme : data[1][i].theme,
					category : data[1][i].category,
					transportation : data[1][i].transportation,
					post : ''
				}
					
				for( var j = 0; j < post.length; j++ ) {
					var postDt = post[j].planDtNum;
					if ( feedMapObj.planDtNum == postDt) {
						feedMapObj.post = post[j].postNo;
					}	
				}
				
				
				
				
												
				(function(marker, feedMapObj) { //이벤트 등록
					kakao.maps.event.addListener(marker, 'mouseover', function() { //마커에 마우스 올렸을 때
			            displayInfowindow(marker, feedMapObj); // displayInfowindow()에서 처리
			        });	
					
				    kakao.maps.event.addListener(marker, 'click', function() { // 마커를 클릭했을 때 인포창 닫기
			            infowindow.close();
			        }); 	
				})(marker, feedMapObj);
				};
				clusterer.addMarkers(markers); // 클러스터러에 마커들을 추가
				
				

				
			},
			error : function(data) {
				alert('필터를 다시 설정해주세요.');
			}
		});
 });
  		
function displayInfowindow(marker, feedMapObj) { //인포윈도우 생성
	var content ='';
	
	content +=  '<div class="wrap">';
    content += '<div class="info">'; 
	content += '<div class="title bg-info">';
	content += '<img src="../images/marker.png" width="25px" height="25px" background-color="white">&nbsp;&nbsp;&nbsp;';
	content += feedMapObj.placeName;
	content += '</div>';
	content += '<div class="body">';
	content += '<div class="img">';
	content += '<img src="../images/infowindow-logo.png">';
	content += '</div>';
	content += '<div class="content" style="height: 150px">';
	content += '<div class="info-address">' + '주소 : ' + feedMapObj.address + '</div>';
	content += '<div class="info-theme">' + '목적 : ' + feedMapObj.theme + '</div>';
	
	if ( feedMapObj.category == null ) {
		feedMapObj.category = '준비 중';
	}
	
	content += '<div class="info-category">' + '장소 : ' + feedMapObj.category + '</div>';
	
	if ( feedMapObj.transportation != null ) {
		content += '<div class="info-transportation">' + '이동수단 : ' + feedMapObj.transportation + '</div>';
	}
	
	if ( feedMapObj.post != '' ) {
		content += '<button type="button" class="btn btn-xl btn-primary post_link info-post" style="width: 90%;" data-num="'+ feedMapObj.post + '">';
		content += '<i class="fa-brands fa-instagram"></i>';
		content += '</button>';
	}
	content += '</div>';
	content += '</div>';
	content += '</div>';
	content += '</div>';

	infowindow.setContent(content);
	infowindow.open(map, marker);
	
	$('div.wrap').parent().parent().css('border', 'none');
	$('div.wrap').parent().parent().css('background-color', 'transparent');
 }
//마커 클러스터러에 클릭이벤트를 등록합니다
//마커 클러스터러를 생성할 때 disableClickZoom을 true로 설정하지 않은 경우
//이벤트 헨들러로 cluster 객체가 넘어오지 않을 수도 있습니다
kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
	
// 현재 지도 레벨에서 1레벨 확대한 레벨
 var level = map.getLevel()-1;
	
// 지도를 클릭된 클러스터의 마커의 위치를 기준으로 확대합니다
 map.setLevel(level, {anchor: cluster.getCenter()});
});

$(document).on('click', 'button.post_link', function(e) {
	e.preventDefault();
	var postNo = $(this).attr('data-num');

	$.ajax({
		url : 'getMapPost.do',
		type: 'post',
		data: {postNo : postNo},
		beforeSend: function(xhr){
 		   	var token = $("meta[name='_csrf']").attr('content');
 			var header = $("meta[name='_csrf_header']").attr('content');
	        xhr.setRequestHeader(header, token);
	    },
		success: function(data) {
				$('#modalBtn').trigger('click');
	            infowindow.close();
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

				if ( userEmail == email ) {
					$('.modifyBtn').css('display', 'inline-block');
					$('.modifyBtn').attr('href', '/init/post/' + $('.modifyBtn').attr('href')+postNo)
					$('.deleteBtn').css('display', 'inline-block');
					$('.deleteBtn').attr('href', '/init/post/' + $('.deleteBtn').attr('href')+postNo)
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
		error : function() {
			
		}
	});
	getComments(postNo);
});

$('.modal-like').on('click', function(){
	console.log('진입');
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



function getComments(postNo) {
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
				comments +=	'<div class="img-xxs border"></div>';
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

	$('a.modifyBtn').attr('href', 'init/post/modify?postNo=');
    $('a.deleteBtn').attr('href', 'init/post/delete.do?postNo=');
});

function deleteCheck(){
    if(confirm("삭제하시겠습니까?")){
        return true;
    } else {
    	$(".delete").attr('href','post/list');
        return false;
    }
}
