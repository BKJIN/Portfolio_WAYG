$(document).ready(function() {
	// planMst.startDate, planMst.endDate를 Date 객체로 변환	
	var sDate = strToDate($('#frm0 input[name=startDate]').val());
	var eDate = strToDate($('#frm0 input[name=endDate]').val());

	// planMst.dateCount
	var dateCount = $('#frm0 input[name=dateCount]').val();

	// sDate부터 eDate까지의 날짜를 문자열 배열로 생성
	var dates = getPlanDate(sDate, eDate);

	// 일정 날짜 수(dateCount)만큼 tabdiv 동적 생성 (1번은 미리 생성해두고 시작)
	for ( var i = 2; i <= Number(dateCount); i++ ) {
		// 미리 생성해둔 #tab-1의 html을 가져와서 header index만 추가해서 동적 생성
		var tab_div = '<div id="tab-' + i + '" class="tab-content">' 
			        + $('#tab-1').html();
		            + '</div>';

		$('.planbox').append(tab_div);
		
		// 현재의 탭 박스가 몇번째 DAY이고, 실제 planDate가 몇일인지 표시
		$('#tab-' + i + '>h3').text('DAY ' + i + ' : ' + dates[i-1]);
		
		// tab박스 안에 frm의 name과 id에 똑같이 index 추가
		$('#tab-' + i + ' #frm1').attr('name', 'frm' + i);
		$('#tab-' + i + ' #frm1').attr('id', 'frm' + i);
		
		// #frm 안에 data-date에 planDate, data-day에 planDay 저장(동적 박스 생성시 input값에 부여)
		$('#frm' + i).attr('data-date', dates[i-1]);
		$('#frm' + i).attr('data-day', 'day' + i);

		// #frm 안에 input planDate, planDay에 value 입력
		$('#frm' + i + ' .detail1 .inputbox input[name=planDay]').val('day' + i);
		$('#frm' + i + ' input[name=planDate]').val(dates[i-1]);
	};

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
		var index = $(this).attr('data-index');
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
	$('#submitAll').on('click', function(e) {
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
				url: 'plan/detail.do',
				type: 'post',
				data: data,
				success: function(data) {
					
					if ( data == "success" ) {
						// 성공시 feed 페이지로 이동
						location.href = "feed";
					} else {
						$('.modal-body').text('저장에 실패하였습니다.');
					}
				},
				error: function() {
					console.log('error');				
				}
			})
		} else {
			return false;
		}
		
		
	});
	
	/* 동적으로 생성한 엘리먼트까지 이벤트를 부여할 때, $(document).on 사용 */
	
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
		
		// 현재 value가 0인 경우, return false
		if ( delValue < 0 ) {
			alert('최소 1개 이상의 일정이 필요합니다');
			return false;
		
		// 현재 value가 1인 경우 박스를 지우지 않고 박스안에 값을 전부 초기화	
		} else if ( delValue < 1 ) {
			$(this).siblings('input[name=placeName]').val('');

			var inputBox = $(this).siblings('.inputbox');
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

	/* method repository */
	
	// string으로 된 date를 javascript date객체로 변환
	function strToDate(str) {
		let y = str.slice(0, 4);
		let m = Number(str.slice(5, 7)) - 1;
		let d = str.slice(8);
		
		return new Date(y, m, d);
	}
	
	// javascript date객체를 string으로 변환
	function dateToStr(date) {
		let y = date.getFullYear();
		let m = date.getMonth() + 1;
		let d = date.getDate();
		
		if ( m <= 9 ) {
			m = "0" + m;
		}
		
		if ( d <= 9 ) {
			d = "0" + d;
		}
		
		return y+"-"+m+"-"+d;
	}
	
	// javascript date객체인 startDate와 endDate로 모든 일정의 날짜를 구하는 메서드
	function getPlanDate(start, end) {
		var dates = [];
		dates.push(dateToStr(start));
		
		var date = new Date(start);

		while ( date < end ) {
			date.setDate(date.getDate() + 1);
			
			dates.push(dateToStr(date));
		}
		return dates;
	}

});