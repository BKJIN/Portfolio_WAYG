
function setPlanDt(data, dateCount) {
	// tab 박스의 부모 element가 될 위치를 선택
	var target1 = $('.plan-details');

	// 기본으로 생성되어 있는 details1의 html을 가져오고 div#details로 감싸줌
	var boxHtml = '<div id="details" class="px-0">'
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
				// 각각의 위치에 텍스트 입력
				target2.children('.planDt' + count).children('input.planDtNum').val(data[j].planDtNum);
				target2.children('.planDt' + count).children('h4').text(data[j].placeName);
				target2.children('.planDt' + count).children('.startTime').text('start : ' + data[j].startTime);
				target2.children('.planDt' + count).children('.endTime').text('end : ' + data[j].endTime);
				target2.children('.planDt' + count).children('.addLocBtn').attr('data-index', data[j].planDtNum);
				
				if ( data[j].placeName == 'Place' ) {
					target2.children('.planDt' + count).children('.addLocBtn').attr('disabled', 'disabled');
					
				} else {
					target2.children('.planDt' + count).children('.addLocBtn').addClass('active');
				}
				
				count++;
			}
		}
	}
}



$(document).ready(function() {
	setPlanDt(planDt, dateCount);

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
		
	});
	
	// modal창에 상세일정 표시 부분에 next 버튼 클릭 시
	$('#next-btn').click(function() {
		// 버튼에 부여한 data-index 값(= .active인 탭 박스에 index - 1) 을 가져옴
		var index = Number($(this).attr('data-index'));
		// index < 2  ==  첫 번째 탭 박스가 .active, index가 총 상세 일정의 개수보다 클 경우 == 마지막 탭 박스가 .active
		if ( index < 2 || index > dateCount) {
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
	});
	
	
	$(document).on('click', '.addLocBtn', function() {
		var addLocBtn = $(this);
		var placeName = addLocBtn.siblings('h4.placeName').text();
		var planDtNum = $(this).attr('data-index');
		
		
		if ( $('.locations-box').children('.location-item').length == 0 ) {
			$('.locations-box').css('height', '28px');
			$('.locations-box').css('display', 'flex');
			$('.locations-box').css('flex-wrap', 'nowrap');
		}

		var item = '<div class="mr-1 px-1 location-item border bg-light rounded">' 
				 + placeName + '&nbsp;<span class="text-danger delLocBtn" data-index="' + planDtNum + '">&times;</span></div>';
		
		$('.locations-box').append(item);
		
		$('div.planDt').append('<input type="hidden" name="planDtNum" data-group="' + planDtNum + '" value="' + planDtNum + '"/>');
		$('div.planDt').append('<input type="hidden" name="placeName" data-group="' + planDtNum + '" value="' + placeName + '"/>');
		
		addLocBtn.attr('disabled', 'disabled');	
	});

	
	$(document).on('click', '.delLocBtn', function() {
		var index = $(this).attr('data-index');
		
		$('.addLocBtn[data-index='+ index + ']').removeAttr('disabled');
		$('input[data-group='+ index +']').remove();
		
		$(this).parent().remove();
		
		if ( $('.locations-box').children('.location-item').length == 0 ) {
			$('.locations-box').css('height', '0px');
			$('.locations-box').css('display', 'none');
		}
		
	});
	
	$('.content').keyup(function () {
		let tmp = $(this).val().length;
		
		if (tmp != 0 || tmp != '') {
			 $('.textCount').text(tmp + '/300자');
		}  
		if (tmp > 299) {
			$(this).val($(this).val().substring(0, 299));
		};
	});

	$('.hashtag').keyup(function () {
		let element = $(this);
		let count = element.val().split('#').length-1;
		let hashtag = element.val().split('#');
		let result = '';
		let hashCheck =element.val().substr(0,1);
		var pattern = /\s/g;
		
		
		if(hashCheck !=='#'){
			alert('해쉬태그는 #을 붙여주세요! ');
			element.val('#');
		}
		
		if ( element.val().match(pattern) ) {
			element.val(element.val().replace(/\s/g, '#'));
		}
		
		
		if(count>=11){

			for(let i=0; i<11; i++){
			
				if(i==0){
				
					result=hashtag[0];
				} else {
					result +='#'+hashtag[i];
				}
			}
			alert('해쉬태그는 10개까지만 등록가능합니다\n'+result);
			element.val(result); 
			
		} else {
			for(let i=0; i<hashtag.length; i++) {
				if(i==0) {
					result=hashtag[0];
				} else {
					result +='#'+hashtag[i];									
				}
			}
		}	
		
		$(this).attr('value',result);	
	});

	$(document).on('click','.reimg',function(){
		
		const dataTransfer = new DataTransfer(); 
		let changeData ="";
		let arr = $('.img')[0].files;
		let index = $(this).attr('index');
			
		let fileArray = Array.from(arr); //변수에 할당된 파일을 배열로 변환(FileList -> Array) 
		fileArray.splice(index, 1); //해당하는 index의 파일을 배열에서 제거 
		fileArray.forEach(file => { dataTransfer.items.add(file); }); //남은 배열을 dataTransfer로 처리(Array -> FileList) 
		$('.img')[0].files = dataTransfer.files; //제거 처리된 FileList를 돌려줌
			
		changeData = $('.img')[0].files;
		imgView='';
		for(var i=0; i<changeData.length; i++){
			imgView +='<img src="'+URL.createObjectURL(changeData[i])+'" style="width :23%; max-height: 150px;">'
			imgView +='<i class="fa-solid fa-x reimg" index="'+i+'"></i>';
			imgView +='<br/>';
		}
			
			//동일 이미지 등록 가능 (추가)
			$('.addImg').val('');
			
		$('.imgView').html(imgView);	
		
	});
	
	$('.addImg').change(function(){ //파일 추가
		const dataTransfer = new DataTransfer(); 
		let arr = $('.img')[0].files;
		let arr2 =$('.addImg')[0].files;
		
		let totalSize = 0;
		
		console.log(totalSize);
		
					
		//파일값 초기화
		for(var i=0; i<arr.length; i++){
			totalSize+=arr[i].size;
		}
		for(var i=0; i<arr2.length; i++){
			totalSize+=arr2[i].size;		
		}
		
		
		if(arr.length+arr2.length>10){
			alert('10장 이상 등록할수 없습니다.\n다시 선택해주세요');

		} else if(totalSize>10000000-1){
				alert('이미지의 총 용량이 10MB를 초과합니다.\n 다른 이미지를 올려주세요');
			
		} else {
			let fileArray = Array.from(arr); //변수에 할당된 파일을 배열로 변환(FileList -> Array) 
			for(var i=0; i<arr2.length; i++){				
				extension = arr2[i].name.substring(arr2[i].name.lastIndexOf('.')+1).toLowerCase(); //확장자명 추출

				if(extension =='jpg' || extension =='jpeg' || extension =='png'){   //확장자 확인      
					fileArray.push(arr2[i]);            

				}else{
					alert(arr2[i].name+'은 지원하지 않은 확장자 파일입니다.');
				}
			}
			
			fileArray.forEach(file => { dataTransfer.items.add(file); }); //남은 배열을 dataTransfer로 처리(Array -> FileList) 
			$('.img')[0].files = dataTransfer.files; 
			arr = $('.img')[0].files;
			
		}
		

		let imgView='';
		
		for(var i=0; i<arr.length; i++){
			
			imgView +='<img src="'+URL.createObjectURL(arr[i])+'" style="width :23%; max-height: 150px;">'
			imgView +='<i class="fa-solid fa-x reimg" index="'+i+'"></i>';
			imgView +='<br/>'
		}

		$('.imgView').html(imgView);
		$('.addImg').val('');	
	});
	
	$(document).on('click','.addImgBtn',function(){
		$('input[name=addImg]').trigger('click');
	});
	
});

function checkfrm() { 
	
	var files = $('.img')[0].files;
	
	if ($('.content').val() == '') {
		alert('포스트 내용을 입력해주세요.');
		$('.content').focus();
		return false;
	}

	else if (files.length == 0 ){
		alert('한 장 이상의 사진을 등록해주세요.');
		return false;
	}

	
	else {
		$('#addForm').submit();
	}
}
