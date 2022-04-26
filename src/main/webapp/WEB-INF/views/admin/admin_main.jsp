<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@0.7.0"></script>
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<!-- Cart.js API 라이브러리 추가 -->
<title>Insert title here</title>
<style>
html,body {
	height: 100%;
	margin: 0; 
	padding : 0;
}

body{
	padding-top: 80px;
}

.container{
	width : 100%;
}

#admin_ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: auto;
}

#admin-li a {
  display: block;
  color: #000;
  padding: 8px 16px;
  text-decoration: none;
  border-radius: 15px 15px 0px 0px;
}

#admin-li a.active {
  background-color: #828282;
  color: white;
}

#admin-li a:hover:not(.active) {
  background-color: #CBCBCB;
  color: white;
}

hr {
	margin-top : 0;
}

.DashBoard-filter{
	width : 100%;
	height : auto;
}

#btn{
	border: solid;
}

#canvas{
	width : 100%;
	/* border: solid; */
}

</style>
</head>
<body>

<%@ include file="../includes/header.jsp" %>



<div class="container">
	<nav class="bg-white mt-3">
		<ul id="admin_ul" class="d-flex row mx-0">
			<li id="admin-li" class="col-6">
				<a class="active" href="admin"><b class="font-italic">DashBoard</b></a>
			</li>
			
			<li id="admin-li" class="col-6">
				<a href="u_admin"><b class="font-italic">UserBoard</b></a>
			</li>
		</ul>
	</nav>
	
	<hr />
	
	<div class="DashBoard-filter d-flex mt-2 mb-3 row mx-0"> <!-- 필터 생성 -->
		<form id="frm" name="frm" action="insertFilter" method="post" class="col-6 border-right"> <!-- 필터 form -->
			<div class="form-group row mx-0"> 
				<label for="pSelBox" class="pSelBox_title col-4 mt-2 mr-3 border-right">인기 장소 통계</label>
				<select id="pSelBox" class="main-filter custom-select my-1 col-7" name="value1"> <!-- 메인 필터 select창 생성 -->
					<option value="AllPlaces Top 5">AllPlaces Top 5</option>
					<option value="Restaurant Top 5">Restaurant Top 5</option>
					<option value="Cafe Top 5">Cafe Top 5</option>
					<option value="Attractions Top 5">Attractions Top 5</option>
				</select>	
				<select id="pSelSubBox" class="sub-filter custom-select my-1 mr-sm-2" name="value2" style="display:none"> <!-- 서브 필터 select창 생성, option은 script에서 생성 --></select>			 
			</div>
			<button type="submit" id="pfilterbtn" class="btn btn-sm btn-success float-right col-3">장소 통계</button> <!-- 필터 제출 버튼 -->
		</form>
		
		<form id="frm" name="frm" action="insertFilter" method="post" class="col-6"> <!-- 필터 form -->
			<div class="form-group">
				<label for="uSelBox" class="uSelBox_title col-4 mt-2 mr-3 border-right">회원 통계</label> 
				<select id="uSelBox" class="main-filter custom-select my-1 my-1 col-7" name="value1" > <!-- 메인 필터 select창 생성 -->
					<option value="#">---------------------------</option>
					<option value="년도 별 가입자 수">년도 별 가입자 수</option>
					<option value="월 별 가입자 수">월 별 가입자 수</option>
					<option value="일 별 가입자 수">일 별 가입자 수</option>
				</select>
				<div class="date_value1 d-none mt-2 row mx-0">		
					<input id="uvalue3" type="text" name="value3" class="ml-5 form-control col-5" placeholder="ex)2018"/>&nbsp;~&nbsp;
					<input id="uvalue4" type="text" name="value4" class="form-control col-5" placeholder="ex)2022"/>
				</div>			 
			</div>
			<div class="row mx-0 d-flex justify-content-end">				
				<button type="submit" id="ufilterbtn" class="btn btn-sm ml-2 btn-primary col-3" >가입자 수</button> <!-- 가입자 수 -->
				<button type="submit" id="gfilterbtn" class="btn btn-sm ml-2 btn-warning col-3 text-white" >가입자 성별</button> <!-- 가입자 성별 -->
				<button type="submit" id="afilterbtn" class="btn btn-sm ml-2 btn-secondary col-3" >가입자 연령</button> <!-- 가입자 연령 -->
			</div>
		</form>
	</div>
	<hr/>
	<!-- 그래픽표시 공간 -->
	<div id="main" class="container">
		<div id="title" style="text-align:center; font-size:30px;"></div>
		<canvas id="canvas" class="container"></canvas>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>

<script>
$(document).ready(function(){
	//메인 필터객체 생성
	var mainFilter = document.querySelector('.main-filter');
	
	//메인 필터 객체에 변화가 생겼을 때 이벤트가 실행될 수 있는 onchange이벤트 생성
	mainFilter.onchange = function(){
		var subFilter = document.querySelector('.sub-filter');
		var mainOption = mainFilter.options[mainFilter.selectedIndex].innerText;
	
		//서브필터의 option 생성	
		var subOption = {
			allPlaces : ['all'],	
			restaurant : ['FD6'],
			cafe : ['CE7'],
			attractions : ['AT4']	
		}

		//메인옵션 선택에 따라 서브옵션 select
		switch(mainOption){
			case 'AllPlaces Top 5' : 
				var subOption = subOption.allPlaces;
				break; 
			case 'Restaurant Top 5' : 
				var subOption = subOption.restaurant;
				break; 
			case 'Cafe Top 5' : 
				var subOption = subOption.cafe;
				break;
			case 'Attractions Top 5' : 
				var subOption = subOption.attractions;
				break;
		}
		
		subFilter.options.length = 0;
		
		for(var i=0; i < subOption.length; i++){ //생성된 서브옵션 수 만큼 option태그 생성
			var option = document.createElement('option');
			option.innerText = subOption[i]; // 생성된 option 태그에 서브옵션의 값 넣기
			subFilter.append(option); // 서브필터에 option태그 넣기
		}
	}
	
	
	/* 년도,월,일 별 회원통계 셀렉 할 때마다 input의 placeholder 바꾸기 */
	$('#uSelBox').change(function(){
		console.log($('#uSelBox option:selected').val());
		if($('#uSelBox option:selected').val() == '년도 별 가입자 수'){
			$('.date_value1').removeClass('d-none');
			$('#uvalue3').attr('type', 'number');
			$('#uvalue4').attr('type', 'number');
			
			var date = new Date();

			$('#uvalue3').attr('min', 2000);
			$('#uvalue3').attr('max', date.getFullYear());
			$('#uvalue4').attr('min', 2000);
			$('#uvalue4').attr('max', date.getFullYear());
			
			
			$('#uvalue3').val('');
			$('#uvalue4').val('');
		}
		else if($('#uSelBox option:selected').val() == '월 별 가입자 수'){
			$('.date_value1').removeClass('d-none');
			$('#uvalue3').attr('type', 'month');
			$('#uvalue4').attr('type', 'month');
			$('#uvalue3').val('');
			$('#uvalue4').val('');
		}
		else if($('#uSelBox option:selected').val() == '일 별 가입자 수'){
			$('.date_value1').removeClass('d-none');
			$('#uvalue3').attr('type', 'date');
			$('#uvalue4').attr('type', 'date');
			$('#uvalue3').val('');
			$('#uvalue4').val('');
		} else {
			$('.date_value1').addClass('d-none');
		}
	});
	
	/* 장소별 통계 */
	$("#pfilterbtn").click(function(event){
		event.preventDefault();
		
	    document.getElementById('title').innerText //그래프에 맞는 title 생성
	    = $("#pSelBox").val();
		
		let value1; //컬럼
		let value2; //값
		
	  	if($("#pSelBox").val() == "AllPlaces Top 5"){ //모든 장소는 컬럼 = 1, 값 = '1' 설정
	  		value1 = "1";
			value2 = "1";
		}
	  	else{ 
	  		value1 = "category"; //컬럼
	  		value2 = $("#pSelSubBox").val(); //값
	  	}
		
		let pChartLabels = []; //장소 표시 배열 초기화
		let pChartData = []; // top.5 장소
		
		//그래프를 그릴 수 있도록 가공해둔 변수
		let barChartData = {
			labels : pChartLabels, //그래프의 기본축인 x에 들어 가는 값
			fill: false,
			datasets : [ //그래프에 표시할 데이터 값 charData1
				{
					label: "Place", //데이터 종류 이름
					fillColor : "rgba(220,220,220,0.2)", //채울색
					strokeColor : "rgba(220,220,220,1)", //선색
					pointColor : "rgba(220,220,220,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(220,220,220,1)",
					data : pChartData,
					backgroundColor: [
						//색상
	                   'rgba(255, 99, 132, 0.2)',
	                   'rgba(54, 162, 235, 0.2)',
	                   'rgba(255, 206, 86, 0.2)',
	                   'rgba(75, 192, 192, 0.2)',
	                   'rgba(153, 102, 255, 0.2)',
					],
	                borderColor: [
	                    //경계선 색상
	                    'rgba(255, 99, 132, 1)',
	                    'rgba(54, 162, 235, 1)',
	                    'rgba(255, 206, 86, 1)',
	                    'rgba(75, 192, 192, 1)',
	                    'rgba(153, 102, 255, 1)',
	                ],
	                borderWidth: 1 //경계선 굵기
				}
			]
		};
		
		
		
		function createChart() {
			if(window.dashBoardChart != undefined){ //이전 차트를 지워서 차트 중복 제거
				window.dashBoardChart.destroy();
			}
			window.dashBoardChart = new Chart(document.getElementById("canvas").getContext("2d"),{
				type: 'bar', //수평막대그래프
				data: barChartData,
				options: {
					title:{
						display : true,
						text : "가장 많이 방문한 장소 Top 5"
					},
					legend:{
						display : false
					},
					scales: { //눈금표시
						xAxes: [
									{
									ticks:{
										fontColor : 'rgba(12, 13, 13, 1)',
										fontSize : 15
									}
								}
							],
						yAxes: [
									{
										ticks: {
											beginAtZero:true, //0부터 시작
											max : 100 //y 최대값
										}
									}
								]
					}
				}
			});
		}
		
		console.log(value1, value2);
		
		$.ajax({
			type : 'POST',
			url : 'placesDashBoard', //서버에서 그래프용 데이터 처리 요청
			data: {"value1" : value1, "value2" : value2},
			beforeSend: function(xhr){
			   	var token = $("meta[name='_csrf']").attr('content');
				var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
			},
			success : function(data) { //result는 서버에서 오는 json형태 값
				console.log(data);
			
				for(i=0; i<data.length; i++) {
					pChartLabels.push(data[i].placeName);
					pChartData.push(data[i].count);
				};
				createChart();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert('장소 통계를 다시 선택해 주세요');
			}
		});
	});
	
	/* 년도,월,일 별 회원수 통계 */
	$("#ufilterbtn").click(function(event){
		event.preventDefault();
		
	    document.getElementById('title').innerText //그래프에 맞는 title 생성
	    = $("#uSelBox").val();
		
		let value1 = $("#uSelBox").val();
		
		switch(value1){ // DB에는 카테고리의 code값이 들어가므로 code를 카테고리 명으로 변경
			case "년도 별 가입자 수" : value1 = "'YYYY'";
			break;
			case "월 별 가입자 수" : value1 = "'YYYY-MM'";
			break;
			case "일 별 가입자 수" : value1 = "'YYYY-MM-DD'";
			break;
		}
		
		console.log(value1);
		
		let value2;
			
		switch(value1){
			case "'YYYY'" : value2 = "YYYY";
			break;
			case "'YYYY-MM'" : value2 = "YYYY-MM";
			break;
			case "'YYYY-MM-DD'" : value2 = "YYYY-MM-DD";
			break;
		}
		
		console.log(value2);
		
		let value3 = $('#uvalue3').val();
		let value4 = $('#uvalue4').val();
		
		console.log(value3);
		console.log(value4);
		
		let uChartLabels = []; //장소 표시 배열 초기화
		let uChartData = []; // top.5 장소
		
		//그래프를 그릴 수 있도록 가공해둔 변수
		let lineChartData = {
			labels : uChartLabels, //그래프의 기본축인 x에 들어 가는 값
			datasets : [ //그래프에 표시할 데이터 값 uChartData
				{
					label: "User", //데이터 종류 이름
					fillColor : "rgba(220,220,220,0.2)", //채울색
					strokeColor : "rgba(220,220,220,1)", //선색
					pointColor : "rgba(220,220,220,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(220,220,220,1)",
					data : uChartData,
					backgroundColor: [
						//색상
	                   'rgba(255, 99, 132, 0.2)',
	                   'rgba(54, 162, 235, 0.2)',
	                   'rgba(255, 206, 86, 0.2)',
	                   'rgba(75, 192, 192, 0.2)',
	                   'rgba(153, 102, 255, 0.2)',
					],
	                borderColor: [
	                    //경계선 색상
	                    'rgba(255, 99, 132, 1)',
	                    'rgba(54, 162, 235, 1)',
	                    'rgba(255, 206, 86, 1)',
	                    'rgba(75, 192, 192, 1)',
	                    'rgba(153, 102, 255, 1)',
	                ],
	                borderWidth: 1 //경계선 굵기
				}
			]
		};
			
		function createChart() {
			if(window.dashBoardChart != undefined){ //이전 차트를 지워서 차트 중복 제거
				window.dashBoardChart.destroy();
			}
			window.dashBoardChart = new Chart(document.getElementById("canvas").getContext("2d"),{
				type: 'line', //수평막대그래프
				data: lineChartData,
				options: {
					title:{
						display : true,
						text : "가입자 현황"
					},
					legend:{
						display : false
					},
					scales: { //눈금표시
						xAxes: [
									{
									ticks:{
										fontColor : 'rgba(12, 13, 13, 1)',
										fontSize : 10
									}
								}
							],
						yAxes: [
									{
										ticks: {
											beginAtZero:true, //0부터 시작
										}
									}
								]
					}
				}
			});
		}
		
		console.log(value1, value2 ,value3, value4);
		
		$.ajax({
			type : 'POST',
			url : 'userDashBoard', //서버에서 그래프용 데이터 처리 요청
			data: {"value1" : value1, "value2" : value2, "value3" : value3, "value4" : value4},
			beforeSend: function(xhr){
			   	var token = $("meta[name='_csrf']").attr('content');
				var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
			},
			success : function(data) { //result는 서버에서 오는 json형태 값
				console.log(data);
			
				for(i=0; i<data.length; i++) {
					uChartLabels.push(data[i].userDate);
					uChartData.push(data[i].count);
				};
				createChart();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert('가입자 통계를 다시 선택해 주세요');
			}
		});
	});
	
	/* 회원 성별 통계 */
	$("#gfilterbtn").click(function(event){
		event.preventDefault();
		
	    document.getElementById('title').innerText //그래프에 맞는 title 생성
	    = $("#gfilterbtn").val();
		
		let gChartLabels = []; //성별 표시 배열 초기화
		let gChartData = []; // 성별 카운트 수
		console.log(gChartData);
		//그래프를 그릴 수 있도록 가공해둔 변수
		let PieChartData = {
			labels : gChartLabels,
			fill: false,
			datasets : [ //그래프에 표시할 데이터 값
				{
					label: "Gender", //데이터 종류 이름
					fillColor : "rgba(220,220,220,0.2)", //채울색
					strokeColor : "rgba(220,220,220,1)", //선색
					pointColor : "rgba(220,220,220,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(220,220,220,1)",
					data : gChartData,
					backgroundColor: [
						//색상
						'rgba(54, 162, 235, 0.2)',
		                'rgba(255, 99, 132, 0.2)'
					],
	                borderColor: [
	                    //경계선 색상
	                    'rgba(54, 162, 235, 0.2)',
		                'rgba(255, 99, 132, 0.2)'

	                ],
	                borderWidth: 1 //경계선 굵기
				}
			]
		};
		
		
		
		function createChart() {
			if(window.dashBoardChart != undefined){ //이전 차트를 지워서 차트 중복 제거
				window.dashBoardChart.destroy();
			}
			window.dashBoardChart = new Chart(document.getElementById("canvas").getContext("2d"),{
				type:'pie',
				data: PieChartData,
				options: {
					responsive: true
				}
			});
		}
		
		$.ajax({
			type : 'POST',
			url : 'userDashBoardGender', //서버에서 그래프용 데이터 처리 요청
			beforeSend: function(xhr){
			   	var token = $("meta[name='_csrf']").attr('content');
				var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
			},
			success : function(data) { //result는 서버에서 오는 json형태 값
				console.log(data);
			
				for(i=0; i<data.length; i++) {
					gChartLabels.push(data[i].userGender);
					gChartData.push(data[i].count);
				};
				createChart();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert('성별 통계를 다시 눌러주세요');
			}
		});
	});
	
	/* 회원 연령별 통계 */
	$("#afilterbtn").click(function(event){
		event.preventDefault();
		
	    document.getElementById('title').innerText //그래프에 맞는 title 생성
	    = $("#afilterbtn").val();
		
		let aChartLabels = []; //연령대 표시 배열 초기화
		let aChartData = []; // 연령대 별 카운트 수
		console.log(aChartData);
		//그래프를 그릴 수 있도록 가공해둔 변수
		let PieChartData = {
			labels : aChartLabels,
			fill: false,
			datasets : [ //그래프에 표시할 데이터 값
				{
					label: "UserAge", //데이터 종류 이름
					fillColor : "rgba(220,220,220,0.2)", //채울색
					strokeColor : "rgba(220,220,220,1)", //선색
					pointColor : "rgba(220,220,220,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(220,220,220,1)",
					data : aChartData,
					backgroundColor: [
						//색상
						   'rgba(15, 255, 10, 0.2)',
		                   'rgba(255, 99, 132, 0.2)',
		                   'rgba(54, 162, 235, 0.2)',
		                   'rgba(255, 206, 86, 0.2)',
		                   'rgba(75, 192, 192, 0.2)',
		                   'rgba(153, 102, 255, 0.2)',


					],
	                borderColor: [
	                    //경계선 색상
						   'rgba(15, 255, 10, 0.2)',
		                   'rgba(255, 99, 132, 0.2)',
		                   'rgba(54, 162, 235, 0.2)',
		                   'rgba(255, 206, 86, 0.2)',
		                   'rgba(75, 192, 192, 0.2)',
		                   'rgba(153, 102, 255, 0.2)',

	                ],
	                borderWidth: 1 //경계선 굵기
				}
			]
		};	
		
		function createChart() {
			if(window.dashBoardChart != undefined){ //이전 차트를 지워서 차트 중복 제거
				window.dashBoardChart.destroy();
			}
			window.dashBoardChart = new Chart(document.getElementById("canvas").getContext("2d"),{
				type:'pie',
				data: PieChartData,
				options: {
					responsive: true
				}
			});
		}
		
		$.ajax({
			type : 'POST',
			url : 'userDashBoardAge', //서버에서 그래프용 데이터 처리 요청
			beforeSend: function(xhr){
			   	var token = $("meta[name='_csrf']").attr('content');
				var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
			},
			success : function(data) { //result는 서버에서 오는 json형태 값
				console.log(data);
				
				for(i=0; i<data.length; i++) {
					aChartLabels.push(data[i].agegroup);
					aChartData.push(data[i].count);
				};
				createChart();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert('가입자 연령 통계를 다시 눌러주세요');
			}
		});
	});
	
	$('#pfilterbtn').trigger('click');
});
</script>
</body>
</html>