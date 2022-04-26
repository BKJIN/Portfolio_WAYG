var markers = [];
var plans = [];
var polylines=[];
var clusterer;

var mapContainer = document.getElementById('map'), 
	mapOption = { 
	    center : new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표 
	    level : 4 // 지도의 확대 레벨 
	};

// 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});


function makeMarker(data, map) {
	
	var imageSrc = 'images/marker.png', // 마커이미지의 경로    
	    imageSize = new kakao.maps.Size(50, 50), // 마커이미지의 크기입니다
		imageOption = {offset: new kakao.maps.Point(10, 50)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
		
	var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption); //마커 이미지 옵션을 markerImage객체에 담기
	
	for (var i = 0; i < data.length; i++ ) {
		var placeName = data[i].placeName;
		var address= data[i].address;
		var theme = data[i].theme;
		var category = parseCategory(data[i].category);
		var transportation = data[i].transportation;
		var position;
		
		var marker = new kakao.maps.Marker({
							image: markerImage,
		            		position: new kakao.maps.LatLng(data[i].latitude, data[i].longitude) // 마커를 표시할 위치
		        		});
		
		(function(marker, placeName, address, theme, category, transportation) { //이벤트 등록
			kakao.maps.event.addListener(marker, 'mouseover', function() { //마커에 마우스 올렸을 때
	        	displayInfowindow(marker, placeName, address, theme, category, transportation, map); // displayInfowindow()에서 처리
	    	});
	
	    	kakao.maps.event.addListener(marker, 'mouseout', function() { // 마커에 마우스 치웠을 때 인포창 닫기
	        	infowindow.close();
	    	});
		})(marker, placeName, address, theme, category, transportation);

		// planDay, marker, polyline으로 이루어진 planObject 생성
		var planObject = {
			day: data[i].planDay,
			mapMarker: marker,
		};
	
		// planObject를 markers 배열에 담음
		markers.push(planObject);
	}
	
}


function parseCategory(category) {
	
	switch(category) { // DB에는 카테고리의 code값이 들어가므로 code를 카테고리 명으로 변경
		case "MT1" : category = "대형마트";
		break;
		case "CS2" : category = "편의점";
		break;
		case "PS3" : category = "어린이집, 유치원";
		break;
		case "SC4" : category = "학교";
		break;
		case "AC5" : category = "학원";
		break;
		case "PK6" : category = "주차장";
		break;
		case "OL7" : category = "주유소, 충전소";
		break;
		case "SW8" : category = "지하철역";
		break;
		case "BK9" : category = "은행";
		break;
		case "CT1" : category = "문화시설";
		break;
		case "AG2" : category = "중개업소";
		break;
		case "PO3" : category = "공공기관";
		break;
		case "AT4" : category = "관광명소";
		break;
		case "PO3" : category = "숙박";
		break;
		case "FD6" : category = "음식점";
		break;
		case "CE7" : category = "카페";
		break;
		case "HP8" : category = "병원";
		break;
		case "PM9" : category = "약국";
		break;
	};
	
	return category;
}

//마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function dayMap(planDay, map, clusterer) {
	
	// 클러스터를 초기화시킴
	clusterer.clear();
	
	// 생성된 polyline이 있는 경우 초기화
	if ( polylines.length != 0 ) {
		polylines[0].setMap(null);
		polylines.splice(0, 1);
	}
	
	var linePath = [];
	var dayMarkers = [];
	var count = 0;
	
	for ( var i = 0; i < markers.length; i++ ) {
		// markers2에서 planday가 같은 객체를 찾음
		if( markers[i].day == planDay ) {
			// 같은 planDay로 찾은 첫번째 마커일 때
			if ( count == 0 ) {
				var moveLatlon;
				
				// marker의 좌표가 0(null)인 경우 맵 중심 좌표 지정
				if ( markers[i].mapMarker.getPosition().getLat() == 0 ) {
					moveLatlon = new kakao.maps.LatLng(37.566826, 126.9786567);
				
				// 맵의 중심 좌표를 제일 첫번째 마커의 위치로 지정
				} else {
					moveLatlon = new kakao.maps.LatLng(markers[i].mapMarker.getPosition().getLat(), markers[i].mapMarker.getPosition().getLng());
				}
				
				// 위에서 지정된 좌표로 맵 중심 이동
				map.panTo(moveLatlon);
			}
			// 맵에 마커를 생성
			markers[i].mapMarker.setMap(map);
			
			// 선으로 연결할 마커를 순서대로 linePath 배열에 추가
			linePath.push(new kakao.maps.LatLng(markers[i].mapMarker.getPosition().getLat(), markers[i].mapMarker.getPosition().getLng()));
			
			// 클러스터를 표시할 배열에 마커 추가
			dayMarkers.push(markers[i].mapMarker);
			
			// count++
			count++;
		} else {
			
			// planDay가 같지 않은 마커는 보이지 않게 함
			markers[i].mapMarker.setMap(null);
		}
	}
	
	// linePath 배열 순서대로 선으로 연결
    var polyline = new kakao.maps.Polyline({
		path : linePath,
		strokeWeight : 3,
		strokeColor : 'blue',
		strokeStyle : 'solid'
	});
	
	// polyline 생성 후 polylines에 추가
	polylines.push(polyline);
	
	// polyline을 맵에 생성
	polyline.setMap(map);
	
	// 클러스터로 표시할 마커를 추가
	clusterer.addMarkers(dayMarkers);
}

function displayInfowindow(marker, placeName, address, theme, category, transportation, map) { //인포윈도우 생성

	if ( category == null || category == '' ) {
		category = '준비중';
	}


	var content = '<div class="wrap">' + 
    	       '<div class="info">' + 
	           '<div class="title bg-info">' + 
	     	   '<img src="/init/images/marker.png" width="25px" height="25px" background-color="white">&nbsp;&nbsp;&nbsp;' + 
	     		placeName + 
	            '</div>' + 
	            '<div class="body">' + 
	            '<div class="img">' +
	            '<img src="/init/images/infowindow-logo.png">' +
	            '</div>' + 
	            '<div class="content">' + 
	            '<div class="address">' + '주소 : ' + address + '</div>' +
	            '<div class="category">' + '장소 : ' + category + '</div>' +
				'<div class="theme">' + '테마 : ' + theme + '</div>' +
				'<div class="transportation">' + '교통수단 : ' + transportation + '</div>' +
	            '</div>' + 
	            '</div>' + 
	            '</div>' + 
	         	'</div>' +    
	       		'</div>'; 

	infowindow.setContent(content);
	infowindow.open(map, marker);
	
	$('div.wrap').parent().parent().css('border', 'none');
	$('div.wrap').parent().parent().css('background-color', 'transparent');
}


$(document).ready(function() {

	
	// 맵을 생성하기 전에 빈 객체로 생성
	var map;

	/* ---------------------------- Feed Calendar Page Init ---------------------------- */
	// fullcalendar load
	var Calendar = FullCalendar.Calendar;
		
	// calendar를 보여줄 domElement
	var calendarEl = document.getElementById('calendar');

	var events = [];

	// dateclick에서 쓰일 count 변수
	var count = 0;
	
	// calendar 초기 세팅
	var calendar = new Calendar(calendarEl, {

		// 국가(언어) 설정
		locale: 'ko',
		
		// 헤더 툴바 설정
		headerToolbar: {
	    	left: 'prev', // 왼쪽 (한달 전, 한달 후, 오늘로 이동 버튼)
	    	center: 'title', // 가운데 (년 월 표시)
	    	right: 'today,next' // 오른쪽 (월단위 지도, 주단위 지도, 일단위 지도)
	  	},

		// 월별 달력 생성
	  	initialView: 'dayGridMonth',
		dayMaxEventRows: true,
		dayMaxEvents: true,
		
		views: {
			dayGrid: {
				dayMaxEventRows: 3,
				dayMaxEvents: 3
			}
		},
	
		// 달력 날짜 클릭시
		dateClick: function(info) {
			// validation 문제 없을 시 클릭카운트++
			count++;

			if ( count == 1 ) {
				// 첫번째 클릭시 startDate로 입력
				$('#startDate').val(info.dateStr);
				
			} else {
				// 두번째 클릭시 endDate로 입력
				$('#endDate').val(info.dateStr);
				
				// 클릭 카운트를 0으로 초기화
				count = 0;
			}
		},

		// 생성되어있는 event를 클릭했을 때 내용 (PlanMst 수정 or 삭제 및 PlanDt 조회하는 modal창 trigger)
		eventClick: function(info) {
			// info는 해당 이벤트가 가지고 있는 데이터 값
			// event 블럭을 클릭하면 endDate를 캘린더에 표시된 날짜로 출력 (endDate.date - 1)
			var eventEndDate = strToDate(info.event.endStr);
			eventEndDate.setDate(eventEndDate.getDate() - 1);
			eventEndDate = dateToStr(eventEndDate);
			
			// 해당 일정의 db를 가져옴
			$.ajax({
				url: 'feed/modify_modal.do',
				type: 'post',
				// event가 가지고 있는 planNum을 data로 보냄
				data: info.event.id,
				contentType: 'application/json; charset=UTF-8',
				beforeSend: function(xhr){
		 		   	var token = $("meta[name='_csrf']").attr('content');
		 			var header = $("meta[name='_csrf_header']").attr('content');
	 		        xhr.setRequestHeader(header, token);
	 		    },
				success: function(data) {
					// modal창을 띄우고 각 input에 현재 db에 저장된 value를 뿌려줌
			    	$('#detailModalBtn').trigger('click');
					$('.modal-header #plan-name').text(info.event.title);
					$('#modal-planNum').val(info.event.id);
					$('#modal-planName').val(info.event.title);
					$('#modal-startDate').val(info.event.startStr);
					$('#modal-endDate').val(eventEndDate);
					$('#modal-eventColor').val(info.event.backgroundColor);
					$('#modal-originDateCount').val(info.event.extendedProps.dateCount);
					$('.modal-body .detail-days').attr('data-count', info.event.extendedProps.dateCount);
					$('#btn-detail').attr('href', '/init/plan/detail_modify?planNum=' + info.event.id);
					$('#btn-posting').attr('href', '/init/post/posting?planNum=' + info.event.id);
					// modal창에 ajax로 가져온 data를 활용하여 plan_dt list를 만들고 정보를 뿌려주는 메서드
					modifyModal(data, Number(info.event.extendedProps.dateCount));
					
				},
				error : function() {
					alert('일시적인 오류로 수정에 실패하였습니다. 문제가 지속될 시 게시판으로 문의해주시면 감사하겠습니다.');
				}
			});
		}
	});

	// 캘린더를 만듦
	calendar.render();	
	// getAllPlans() 메서드 호출 : 모든 일정을 가져와서 이벤트 블럭을 생성
	getAllPlans();


	// 일정 생성(Create 버튼 눌렀을 때)
	$('#submit').click(function() {
		// 각각의 form에 입력된 값을 변수에 저장
		var planName = $('#planName').val();
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		
		// startDate와 endDate의 차이를 구해서 dataCount 값을 input에 추가
		var start = strToDate(startDate);
		var end = strToDate(endDate);
		var dateCount = ((end - start) / (1000*60*60*24)) + 1;
		$('#dateCount').val(dateCount);
		
		// validation method 실행
 		var validation = planMstValidations(planName, startDate, endDate, dateCount);

		// validation 결과가 참이면 최종 컨펌 후 submit
		if ( validation == true ) {
			if( confirm('선택한 일자로 일정을 만들까요?') == true ) {
				$('#frm').submit();
			} else {
				return false;
			}
		} else {
			return false;
		}
		
	});
	
	$('#detailModal').on('shown.bs.modal', function() { //모달 창이 켜지면 지도 생성
		$('#plan-day').text('DAY 1');
		
		// 이미 생성된 지도가 있으면 생성하지 않음
		map = new kakao.maps.Map(mapContainer, mapOption);
		
		clusterer = new kakao.maps.MarkerClusterer({
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

		var planDay = 'day1';
		
		makeMarker(plans, map);
		
		if ( plans[0].latitude != null ) { 		
			
			dayMap(planDay, map, clusterer);
		}
	});

	
	$('#detailModal').on('hidden.bs.modal', function() {
		// modal창을 띄우기 전에 직전에 클릭한 event의 정보를 초기화 시킴
		if( $('.modal-header #planName').val() != "" ) {
			$('.plan-details div[id^=details]:nth-child(n+3)').remove();
					
			for(var i = 1; i <= 10; i++ ) {
				$('.planDt' + i + ' .placeName').text('');
				$('.planDt' + i + ' .startTime').text('');
				$('.planDt' + i + ' .endTime').text('');
			}
			
			$('#plan-day').text('DAY 1');
			$('#prev-btn').attr('data-index', 0);
			$('#next-btn').attr('data-index', 2);
		}
		
		$('#map').children('div').remove();
		$('#map').removeAttr('style');
		
		markers = [];
		plans = [];
		polylines= [];
		clusterer = null;

	});
	
	
	// modal창에 상세일정 표시 부분에 previous 버튼 클릭 시
	$('#prev-btn').click(function() {
		// 버튼에 부여한 data-index 값(= .active인 탭 박스에 index - 1) 을 가져옴
		var index = $(this).attr('data-index');
		
		// index < 1  ==  첫 번째 탭 박스가 active일 경우 작동하지 않음
		if ( index < 1 ) {
			return false;
		
		// 첫 번째 날짜의 상세일정 페이지가 아닌 경우
		} else {
			
			// 현재 보여지는 탭 박스의 .active 제거
			$('#details' + (Number(index)+1)).removeClass('active');
			// 다음에 보여질 탭 박스의 .active 추가
			$('#details' + index).addClass('active');
			// planDay가 몇인지 표시 
			$('#plan-day').text('DAY ' + index);
			// data-index 변경 : prev = .active 탭 박스 인덱스의 -1 // next = .active 탭 박스 인덱스의 +1 
			$(this).attr('data-index', Number(index)-1);
			$('#next-btn').attr('data-index', Number(index)+1);
		}
		
		dayMap('day'+index, map, clusterer);
		
	});
	
	// modal창에 상세일정 표시 부분에 next 버튼 클릭 시
	$('#next-btn').click(function() {
		// 버튼에 부여한 data-index 값(= .active인 탭 박스에 index - 1) 을 가져옴
		var index = Number($(this).attr('data-index'));
		// index < 2  ==  첫 번째 탭 박스가 .active, index가 총 상세 일정의 개수보다 클 경우 == 마지막 탭 박스가 .active
		if ( index < 2 || index > $(this).parent().attr('data-count')) {
			return false;
		} else {
			// 현재 보여지는 탭 박스의 .active 제거
			$('#details' + Number(index-1)).removeClass('active');
			// 다음에 보여질 탭 박스의 .active 추가
			$('#details' + index).addClass('active');
			// planDay가 몇인지 표시 
			$('#plan-day').text('DAY ' + index);
			// data-index 변경 : prev = .active 탭 박스 인덱스의 -1 // next = .active 탭 박스 인덱스의 +1 
			$(this).attr('data-index', Number(index)+1);
			$('#prev-btn').attr('data-index', Number(index)-1);
			
		}
	
		dayMap('day'+index, map, clusterer);
	});
	
	


	// planMst 수정버튼 (modal창)	
	$('#btn-modify').click(function(e) {
		e.preventDefault();
		// 각각의 form에 입력된 값을 변수에 저장
		var planName = $('#modal-planName').val();
		var startDate = $('#modal-startDate').val();
		var endDate = $('#modal-endDate').val();
		
		// startDate와 endDate의 차이를 구해서 dataCount 값을 newDateCount input에 추가
		var start = strToDate(startDate);
		var end = strToDate(endDate);
		var dateCount = ((end - start) / (1000*60*60*24)) + 1;
		$('#modal-newDateCount').val(dateCount);
		
		// validation method 실행
		var validation = planMstValidations(planName, startDate, endDate, dateCount);
		
		// validation false이면 submit 안됨
		if ( validation == false ) {
			return false;
		
		// validation 결과가 true이면 원래의 일정과 날짜가 달라진 경우 확인
		} else {
			// last Validation : 수정 전 dateCount 값을 가져옴
			var originDates = $('#modal-originDateCount').val();
			
			// case 1 : 원래의 일정보다 짧아진 경우
			if ( originDates < dateCount ) {
				if( confirm('원래 일정(' + originDates + '일)보다 긴 ' + dateCount + '일를 지정했습니다. 수정할까요?') == false ) {
					return false;
				}
			}
			
			// case 2 : 원래 일정보다 길어진 경우
			else if ( originDates > dateCount ) {
				if( confirm('원래 일정(' + originDates + '일)보다 짧은 ' + dateCount + '일을 지정했습니다. 수정할까요? (새로운 일정 수를 초과하는 상세 일정은 모두 삭제됩니다.)')  == false ) {
					return false;
				}
			
			}
			
			// 5th Validation : 마지막 확인 절차
			else {
				if( confirm('일정을 수정할까요?') == false ) {
					return false;
				}
			}
			
			$.ajax({
				url: 'feed/modify_plan.do',
				type: 'post',
				data: $('#modify_form').serialize(),
				success: function() {
					$('#modalCloseBtn').trigger('click');
					// 캘린더에 표시되어있는 모든 일정을 삭제
					calendar.removeAllEvents();
					// 다시 모든 일정을 불러옴
					getAllPlans();
				},
				error: function() {
					alert('일시적인 오류로 수정에 실패하였습니다. 문제가 지속될 시 게시판으로 문의해주시면 감사하겠습니다.');
				}
			});
		}

	});
	
	// modal에서 일정 삭제 버튼 클릭시
	$('#btn-delete').click(function() {
		// planNum을 가져옴
		var planNum = $('#modal-planNum').val();

		// 최종 확인 후 submit
		if( confirm('모든 상세 일정도 함께 삭제됩니다. 삭제할까요?') == false ) {
			return false;
		}
		
		$.ajax({
			url: "feed/delete_plan.do",
			type: "post",
			data: planNum,
			contentType: 'application/json; charset=UTF-8',
			beforeSend: function(xhr){
	 		   	var token = $("meta[name='_csrf']").attr('content');
	 			var header = $("meta[name='_csrf_header']").attr('content');
 		        xhr.setRequestHeader(header, token);
 		    },
			success: function() {
				$('#modalCloseBtn').trigger('click');
				// 캘린더에 표시되어있는 모든 일정을 삭제
				calendar.removeAllEvents();
				// 다시 모든 일정을 불러옴
				getAllPlans();
			},
			error : function() {
				alert('일시적인 오류로 삭제에 실패하였습니다. 문제가 지속될 시 게시판으로 문의해주시면 감사하겠습니다.');
			}
		});
	});
	
	//feed tab 메뉴 각각의 요소 클릭했을 때,
	$('.nav-link').click(function(e) {
		// feed일 때는 feed 페이지로 재진입, 아닐때는 get방식 ajax호출해서 #main-body에 html 뿌림
		if ( $(this).attr('href') != 'feed' ) {
			//e.preventDefault();
			var url = $(this).attr('href');
			console.log(url);
			// 현재 active로 되어있는 tab menu의 active 클래스를 삭제
			$(this).parent().siblings('.active').removeClass('active');
			
			// 클릭된 요소에 active 클래스 부여
			$(this).parent().addClass('active');
			
			
			// 해당되는 페이지 jsp 파일을 #main-body에 뿌려주는 ajax
			/*
			$.ajax({
				url: url,
				type: 'get',
				success: function(data) {
					// post에서 더보기 버튼으로 늘어났을 때, main-body의 height를 초기화
					var height = $('#main-body').height(1000);
					if ( Number(height) > 1000 ) {
						$('#main-body').height(1000);
					};
					$('#main-body').html(data);
					
				},
				error: function(data) {
					console.log(data);
					alert('ajax 실패');
				}
			})
			*/
		}
	});
	
	
	/* ---------------------------- Feed Calendar Page Use Method ---------------------------- */
	
	// DB에 저장된 일정 불러와 달력에 표시하는 메서드
	function getAllPlans()  {
		$.ajax({
	 			url : "feed/getAllPlans.do",
	 			type : "post",
				// security page에서 ajax시 _csrf.token, _csrf.header를 싣어서 보내야함
	 		    beforeSend: function(xhr){
		 		   	var token = $("meta[name='_csrf']").attr('content');
		 			var header = $("meta[name='_csrf_header']").attr('content');
	 		        xhr.setRequestHeader(header, token);
	 		    },
	 			success : function(data) {
	 				// arraylist를 json으로 변환한 데이터를 하나씩 꺼내와서 calendar에 event로 추가
					for (var i = 0; i < data.length; i++ ) {
	 					var color = data[i].eventColor;
						var eventEnd = strToDate(data[i].endDate);
						eventEnd.setDate(eventEnd.getDate() + 1);
						dateToStr(eventEnd);
						// 이벤트를 생성하는 fullcalendar 메서드
						calendar.addEvent({
							id: data[i].planNum,
	 						title : data[i].planName,
	 						start : data[i].startDate,
	 						end : dateToStr(eventEnd),
							backgroundColor : color,
							dateCount: data[i].dateCount
	 					})
	 				}
					events.length = 0;
					events = calendar.getEvents();
	 			},
	 			error : function(data) {
	 				console.log(data);
	 				alert('일시적인 오류로 캘린더 초기화를 실패하였습니다. 문제가 지속될 시 게시판으로 문의해주시면 감사하겠습니다.');
	 			}
	 		})
	};
	
	// string으로 된 데이터를 date 객체로 바꿔주는 메서드
	function strToDate(str) {
		let y = str.slice(0, 4);
		let m = Number(str.slice(5, 7)) - 1;
		let d = str.slice(8);
		
		return new Date(y, m, d);
	};
	
	// Date 객체를 yyyy-mm-dd 포맷의 string으로 바꿔주는 메서드
	function dateToStr(date) {
		let y = date.getFullYear();
		let m = date.getMonth() + 1;
		let d = date.getDate();
		
		if ( m < 10 ) { m = "0" + m;	}
		
		if ( d < 10 ) { d = "0" + d; }

		return y+"-"+m+"-"+d;
	};
	
	// 이미 생성된 이벤트를 확인하여 같은 날짜에 3개 이상의 이벤트가 있는 경우 false
	function duplicateEventsValidation(startDate, dateCount) {
		var check = true;
		
		var start = strToDate(startDate);
		var duplicateEventsCount = 0;

		// startdate 부터 하루씩 증가
		for ( var i = 0; i < Number(dateCount); i++ ) {
			if ( i != 0 ) {
				start.setDate(start.getDate() + 1);
			}
			// for문을 돌면서 startDate 부터 i만큼 증가된 날짜
			var planDate = dateToStr(start);
			
			// 전체 이벤트를 가지고 있는 events 배열만큼 for문
			for ( var j = 0; j < events.length; j++ ) {
				// calendar eventEndDate가 allday속성으로 인해 +1일이 되므로 다시 -1시켜서 비교 
				var eventEnd = events[j].end;
				eventEnd.setDate(eventEnd.getDate() - 1);
				eventEnd = dateToStr(eventEnd);
				
				// 이미 생성된 이벤트 중에 planDate 날짜를 포함한 일정이 있으면 duplicateEventsCount++시킴
				if ( events[j].startStr <= planDate && eventEnd >= planDate ) {
					duplicateEventsCount++;
				}
			}
			
			// 하루라도 이벤트가 3개 이상인 날이 있으면 return 값을 false로 바꾸고 반복문 종료
			if ( duplicateEventsCount >= 3 ) {
				check = false;
				break;
			}
			// 다음 날짜 확인을 위해 duplicateEventsCount을 다시 0으로 초기화
			duplicateEventsCount = 0;
		}

		return check;
	};
	
	// planMst 생성, 수정시 공통 validation method
	function planMstValidations(planName, startDate, endDate, dateCount) {
		var validation = true;
		// 이미 생성된 이벤트를 확인하여 같은 날짜에 3개 이상의 이벤트가 있는 경우 false
		if ( duplicateEventsValidation(startDate, dateCount) == false ) {
			alert('같은 날짜에 3개 이상의 일정을 생성할 수 업습니다.');
			validation = false;
		}
		
		// 1st Validation : input null check
		if( planName == "" ) {
			alert('일정 이름을 입력해주세요.');
			validation = false;
			
		} else if( startDate =="" || endDate =="" ) {
			alert('일자를 선택해주세요.');
			validation = false;
		}
		
		 
		// 2nd Validation : 종료일자가 시작일자보다 빠르면 폼을 return = false / submit 되지 않게 함.
		if ( startDate > endDate ) {
			alert("종료일자가 시작일자보다 빠를 수 없습니다.");
			validation = false;
		} 
		
		
		// 3rd Validation : 10일 초과 일정 생성 불가
		if ( dateCount > 10 ) {
			alert("10일을 초과한 일정을 생성할 수 없습니다.");
			$('.mp_btn #reset').trigger('click');
			validation = false;
		}

		return validation;
	};
	
	
	
	// 이벤트 블럭 클릭하면 모달창에 정보 가져와서 tab menu 만드는 메서드
	function modifyModal(data, dateCount) {
		// tab 박스의 부모 element가 될 위치를 선택
		var target1 = $('.plan-details');
		
		// 기본으로 생성되어 있는 details1의 html을 가져오고 div#details로 감싸줌
		var boxHtml = '<div id="details" class="col-4 px-0">'
					+ $('#details1').html()
					+ '</div>';

		// details 박스를 동적으로 dateCount만큼 생성하고, 각 date의 상세 일정 개수만큼 상세 일정 정보 입력
		for(var i = 1; i <= dateCount; i++ ) {
			if ( i == 1 ) {
				// 하루짜리 일정인 경우, 기본으로 생성되어 있는 #details1에 active 클래스를 부여하여 화면에 보이게만 설정
				$('#details' + i).addClass('active');
			} else {
				// 2일 이상의 일정의 경우, target박스 안에 #details 박스를 생성
				target1.append(boxHtml);
				// 생성 완료한 후, id 값에 인덱스 번호를 붙여줌 (2 부터 시작)
				$('div#details').attr('id', 'details'+ i);
			}
			
			// 박스 생성과 인덱스 추가를 완료한 후, 해당 일자에 맞는 정보 입력
			var target2 = $('#details'+ i);
			// 해당 일자 안에 상세 일정 개수를 표시할 객체
			var count = 1;
			
			// 일자 안에 상세 일정 개수만큼 반복
			for ( var j = 0; j < data.length; j++ ) {
				if ( data[j].planDay == "day" + i ) {
										
					plans.push(data[j]);
					
					// PlaceName이 null인 경우
					if ( data[j].placeName == null ) {
						data[j].placeName = 'Place';
					}
					// startTime이 null 인 경우
					if ( data[j].startTime == null ) {
						data[j].startTime = '- - : - - ';
					}
					// startTime이 null 인 경우
					if ( data[j].endTime == null ) {
						data[j].endTime = '- - : - - ';
					}

					// 각각의 위치에 텍스트 입력
					target2.children('.planDt' + count).children('h4').text(data[j].placeName);
					target2.children('.planDt' + count).children('.startTime').text('start : ' + data[j].startTime);
					target2.children('.planDt' + count).children('.endTime').text('end : ' + data[j].endTime);
					target2.children('.planDt' + count).children('#latitude').val(data[j].latitude);
					target2.children('.planDt' + count).children('#longitude').val(data[j].longitude);
					target2.children('.planDt' + count).children('#planDay').val(data[j].planDay);										
					// 상세 일정 개수만큼 ++
					count++;
				}
			}
		}
	};

});