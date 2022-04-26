$(document).ready(function() {
	// 동적으로 생성된 tabdiv의 설정 값을 바꿔 줌
	for(var i = 1; i <= dateCount; i++ ) {
		var placeCount = $('#frm'+i+'>.detail0>.inputbox>input[name=placeCount]').val();
		var planDate = $('#frm'+i+'>.detail0>.inputbox>input[name=planDate]').val();
		
		//i번째 form에 data-count, data-date 값 설정
		$('#frm' + i).attr('data-count', placeCount);
		$('#frm' + i).attr('data-date', planDate);
		
		// client에게 보여지는 text에 각 일정 개수와, planDate 입력
		$('#frm' + i).parent().siblings('p.mt-2').children('.showIndex').text(placeCount);
		$('#frm' + i).parent().siblings('#date-title').text('DAY ' + i + ' : ' + planDate);
		
		// 세부 일정이 0일 때
		if ( placeCount == '0' ) {
			// 기존에 생성되어 있는 detail0 박스의 인덱스만 수정
			$('#frm' + i + '>div:nth-child(1)').addClass('detail1');
			$('#frm' + i + '>div:nth-child(1)').removeClass('detail0');
			
		// 세부 일정이 0이 아닐 때
		} else {
			// placeCount 만큼 반복하면서 인덱스를 바꿔 줌
			for ( var j = 1; j <= placeCount; j++ ) {
				var target = $('#frm' + i + '>div:nth-child(' + j + ')');
				
				target.addClass('detail' + j);
				target.removeClass('detail0');
				
				var planDay = target.children('.inputbox').children('input[name=planDay]').val();
				var lat = target.children('.inputbox').children('input[name=latitude]').val();
				var lng = target.children('.inputbox').children('input[name=longitude]').val();
				
				var planPlaceName = target.children('input[name=placeName]').val();
				var planAddress = target.children('.inputbox').children('input[name=address]').val();
				var planCategory = target.children('.inputbox').children('input[name=category]').val();
				
				
				
				// db에서 불러온 값으로 marker를 생성
				var imageSrc = '/init/images/marker.png', // 마커이미지의 경로
			    imageSize = new kakao.maps.Size(50, 50), // 마커이미지의 크기입니다
			    imageOption = {offset: new kakao.maps.Point(10, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
				
				var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption), //마커 이미지 옵션을 markerImage객체에 담기
			    markerPosition = new kakao.maps.LatLng(lat, lng); // 마커가 표시될 위치입니다
				
				var marker = new kakao.maps.Marker({ //설정한 좌표와 이미지 마커 객체에 담기
					position: markerPosition, //마커 좌표 설정
					image: markerImage, // 마커이미지 설정	 
				});
				
				planObject = {
					day : planDay,
					placeName : planPlaceName,
					address : planAddress,
					category : planCategory,
					mapMarker : marker
				};
				
				markers2.push(planObject);
			}
		}
	}
	
	for(var i =0; i < markers2.length; i++ ) {
		var p_marker = markers2[i].mapMarker;
		var p_placeName = markers2[i].placeName;
		var p_address = markers2[i].address;
		var p_category = markers2[i].category;
		
				switch(p_category){ // DB에는 카테고리의 code값이 들어가므로 code를 카테고리 명으로 변경
			case "MT1" : 
				p_category = "대형마트";
				break;
			case "CS2" : 
				p_category = "편의점";
				break;
			case "PS3" : 
				p_category = "어린이집, 유치원";
				break;
			case "SC4" : 
				p_category = "학교";
				break;
			case "AC5" : 
				p_category = "학원";
				break;
			case "PK6" : 
				p_category = "주차장";
				break;
			case "OL7" : 
				p_category = "주유소, 충전소";
				break;
			case "SW8" : 
				p_category = "지하철역";
				break;
			case "BK9" : 
				p_category = "은행";
				break;
			case "CT1" : 
				p_category = "문화시설";
				break;
			case "AG2" : 
				p_category = "중개업소";
				break;
			case "PO3" : 
				p_category = "공공기관";
				break;
			case "AT4" : 
				p_category = "관광명소";
				break;
			case "PO3" : 
				p_category = "숙박";
				break;
			case "FD6" : 
				p_category = "음식점";
				break;
			case "CE7" : 
				p_category = "카페";
				break;
			case "HP8" : 
				p_category = "병원";
				break;
			case "PM9" : 
				p_category = "약국";
				break;
		}
		
		(function(p_marker, p_placeName, p_address, p_category) { //이벤트 등록
			kakao.maps.event.addListener(p_marker, 'mouseover', function() { //마커에 마우스 올렸을 때
	        	displayInfowindow(p_marker, p_placeName, p_address, p_category); // displayInfowindow()에서 처리
	    	});
	
	    	kakao.maps.event.addListener(p_marker, 'mouseout', function() { // 마커에 마우스 치웠을 때 인포창 닫기
	        	infowindow.close();
	    	});
		})(p_marker, p_placeName, p_address, p_category);

	}
	
	

	setDayMap('day1');
	
	for ( var i = 0; i < $('select#theme').length; i++ ) {
		$('select#theme').eq(i).val(selectDts[i].theme);
		$('select#transportation').eq(i).val(selectDts[i].transportation);
	}
	
	
	// 상세 일정 표시 부분에 previous 버튼 클릭 시
	$('#prev-btn').click(function() {
		// 버튼에 부여한 data-index 값(= .active인 탭 박스에 index - 1) 을 가져옴
		var index = $(this).attr('data-index');
		var planday = 'day'+index;
		// index < 1  ==  첫 번째 탭 박스가 active일 경우 작동하지 않음
		if ( index < 1 ) {
			return false;
		
		// 첫 번째 탭 박스가 아닌 경우
		} else {
			// 현재 보여지는 탭 박스의 .active 제거
			$('#tab-' + (Number(index)+1)).removeClass('active');
			// 다음에 보여질 탭 박스의 .active 추가
			$('#tab-' + index).addClass('active');
			$(this).attr('data-index', Number(index)-1);
			$('#next-btn').attr('data-index', Number(index)+1);
			setDayMap(planday);
		}
	});

	// 상세 일정 표시 부분에 next 버튼 클릭 시
	$('#next-btn').click(function() {
		// 버튼에 부여한 data-index 값(= .active인 탭 박스에 index + 1) 을 가져옴
		var index = Number($(this).attr('data-index'));
		var planday = 'day'+index;
		// index < 2  ==  첫 번째 탭 박스가 .active || index가 총 상세 일정의 개수보다 클 경우 == 마지막 탭 박스가 .active
		if ( index < 2 || index > $(this).parent().attr('data-count')) {
			return false;
		} else {
			// 현재 보여지는 탭 박스의 .active 제거
			$('#tab-' + Number(index-1)).removeClass('active');
			// 다음에 보여질 탭 박스의 .active 추가
			$('#tab-' + index).addClass('active');
			// data-index 변경 : prev = .active 탭 박스 인덱스의 -1 // next = .active 탭 박스 인덱스의 +1 
			$(this).attr('data-index', Number(index)+1);
			$('#prev-btn').attr('data-index', Number(index)-1);
			setDayMap(planday);
		}
		
	});
	
	
	// 전체 일정을 submit하는 버튼 클릭 시
	$('#submitAll').click(function(e) {
		e.preventDefault();

		if ( confirm('모든 일정을 저장하고 피드로 돌아갈까요?') ) {
			
			// id가 frm으로 시작하는 form을 배열로 모두 선택
			var form = $('form[id^=frm]').get();

			// 각각의 form 안에 placeCount input 값을 form에 data-count 값으로 입력 (각각의 일정마다의 상세일정 개수를 저장하는 과정)
			for ( var i = 1; i < form.length; i++ ) {
				var count = $('#frm' + i).data('count');
				$('#frm' + i).children('div').children('.inputbox').children('input[name=placeCount]').val(count);
			}
			
			// 모든 form value를 seralize()해서 ajax 처리	
			let data = $('form').serialize();

			$.ajax({
				url: '/init/plan/detail_modify.do',
				type: 'post',
				data: data,
				success: function(data) {
					location.href = "/init/feed";
				},
				error: function() {
					console.log('error');				
				}
			})
			
		} else {
			return false;
		}		
	});


	
	// 상세 일정에 마이너스 버튼 클릭시 이벤트
	$(document).on('click', '.deleteBtn', function() {
		let target = $(this).parent().parent('form');
		
		// 현재 상세 일정의 개수를 변수로 선언
		let currValue = Number(target.attr('data-count'));
		
		// 지워지고 난 일정의 개수를 변수로 선언 (
		let delValue = Number(currValue)-1;
		
		// 지우려고 하는 박스가 몇번째 child인지 구해서+1 시킴
		let index = Number($(this).parent().index())+1;
		
		// 현재 작성중인 일정의 planDay를 변수로 저장
		let planDay = target.attr('data-day');
		
		var inputBox = $(this).siblings('.inputbox');
		
		// 현재 value가 0인 경우, return false
		if ( delValue < 0 ) {
			alert('최소 1개 이상의 일정이 필요합니다');
			return false;
		
		// 현재 value가 1인 경우 박스를 지우지 않고 박스안에 값을 전부 초기화	
		} else if ( delValue < 1 ) {
			$(this).siblings('input[name=placeName]').val('');

			var delNum = inputBox.children('input[name=planDtNum]').val();

			if ( delNum != 0 ) {
				var delDtNums = $('#frm0').children('input[name=deleteDtNum]').val();

				if ( delDtNums == '' ) {
					$('#frm0').children('input[name=deleteDtNum]').val(delNum);
				} else {
					$('#frm0').children('input[name=deleteDtNum]').val(delDtNums + "/" + delNum);
				}
			}
			
			// 해당되는 마커를 삭제
			removeMarkerArray(planDay, (Number(index)-1));
			inputBox.children('input[name=planDtNum]').val('0');
			inputBox.children('input[name=placeName]').val('');
			inputBox.children('input[name=latitude]').val('');
			inputBox.children('input[name=longitude]').val('');
			inputBox.children('input[name=address]').val('');
			inputBox.children('input[name=category]').val('');
			inputBox.children('.form-group').children('input[name=startTime]').val('');			
			inputBox.children('.form-group').children('input[name=endTime]').val('');
			inputBox.children('.form-group').children('select[name=theme]').val('방문');
			inputBox.children('.form-group').children('input[name=transportation]').val('');
			inputBox.children('.form-group').children('input[name=details]').val('');
			
			// form에 data-count와 표시되는 현재 일정 개수를 0으로 바꿔줌
			target.attr('data-count', delValue);
			target.parent().siblings('p.mt-2').children('.showIndex').text(delValue);
		
		} else {

			var delNum = inputBox.children('input[name=planDtNum]').val();

			if ( delNum != 0 ) {
				var delDtNums = $('#frm0').children('input[name=deleteDtNum]').val();

				if ( delDtNums == '' ) {
					$('#frm0').children('input[name=deleteDtNum]').val(delNum);
				} else {
					$('#frm0').children('input[name=deleteDtNum]').val(delDtNums + "/" + delNum);
				}
			}
			
			
			// 지워지는 박스보다 다음에 생긴 박스에 index를 조정 ex> 2번이 지워지면 3,4,5,6번을 2,3,4,5번으로 바꿈
			for ( var i = Number(index); i <= currValue; i++ ) {
				// 자기 자신의 박스를 삭제
				if ( i == Number(index) ) {
					// 해당되는 마커를 삭제					
					removeMarkerArray(planDay, (Number(index)-1));
					// 버튼을 누른 상세일정 박스를 삭제
					$(this).parent().remove();
					
				// 자기 자신 다음 번호의 박스의 인덱스 변경
				} else {
					var box = $('.detail' + i);
							
					box.removeClass('detail' + i);
					box.addClass('detail' + (i-1));
				}
			}
			
			// form에 data-count와 표시되는 현재 일정 개수를 0으로 바꿔줌
			target.attr('data-count', delValue);
			target.parent().siblings('p.mt-2').children('.showIndex').text(delValue);
		}
	});
	
	// detailBtn을 누르면 교통 수단과 상세 일정을 입력하는 input toggle
	$(document).on('click', '.detailBtn', function() {
		// button에 data-count 값이 0일 때
		if( $(this).attr('data-count') == '0' ) {
			// input 박스를 보이게 바꾸고 data-count를 1로 바꿈
			$(this).siblings('.inputbox').children('.toggle').removeClass('none')
			$(this).siblings('.inputbox').children('.toggle').addClass('show');
			$(this).attr('data-count', '1');
			
		// button에 data-count 값이 1일 때
		} else {
			// input 박스를 안보이게 바꾸고 data-count를 0으로 바꿈
			$(this).attr('data-count', '0');
			$(this).siblings('.inputbox').children('.toggle').removeClass('show')
			$(this).siblings('.inputbox').children('.toggle').addClass('none');
		}
	});
	
	// startTime input에 값이 입력되고 focus가 풀렸을 경우
	$(document).on('change', 'input[name=startTime]', function(){
		var startTime = $(this).val();
		// endTime의 value
		var endTime = $(this).parent().next().children('input[name=endTime]').val();
		
		// endTime의 value가 null이면, 아직 입력하기 전이거나 입력하지 않은 경우는 아무 이벤트를 발생시키지 않음
		if ( endTime == '' ) {
			return;
		
		// endTime이 startTime보다 빠를 경우 alert
		} else if ( startTime > endTime ) {
			alert('시작시간보다 종료시간이 빠를 수 없습니다.');
			$(this).val('').focus();
		}
	});	
	
	// endTime input에 값이 입력되고 focus가 풀렸을 경우
	$(document).on('change', 'input[name=endTime]', function(){
		var endTime= $(this).val();
		// startTime의 value
		var startTime= $(this).parent().prev().children('input[name=startTime]').val();
		
		// endTime의 value가 null이면, 아직 입력하기 전이거나 입력하지 않은 것이므로 아무 이벤트를 발생시키지 않음
		if ( startTime > endTime ) {
			alert('시작시간보다 종료시간이 빠를 수 없습니다.');
			$(this).val('').focus();
		}		
	});
	

});
