<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page session="false" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<%-- csrf beforesend 이용을 위한 header setting --%>
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>

<%-- kakaomap javascript CDN --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3&libraries=services"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3"></script>

<%-- page custom javascript file --%>
<script type="text/javascript" src="js/plan/plan_detail.js"></script>

 
<%-- kakaomap css file --%>
<link rel="stylesheet" type="text/css" href="css/plan/kakaomap/kakaomap.css" />

<%-- page custom css file --%>
<link rel="stylesheet" type="text/css" href="css/plan/plan_detail.css" />
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<title>Insert title here</title>
</head>

<body>
<%@ include file="../includes/header.jsp" %>

<section class="container-fluid">
	<div class="planlist row mx-0">
		<%-- 1. 카카오맵 관련 --%>
		<div id="kakaobox" class="map_wrap col-7">
			<%-- 1- 맵이 생성되는 박스 --%>
			<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
			
			<%-- 2- 맵 검색 창 --%>
			<div id="menu_wrap" class="bg_white">
		    	<div class="option">
		        	<div>
		            	<form onsubmit="searchPlaces(); return false;">
		                	키워드 : <input type="text" value="이태원" id="keyword" size="15"> 
		                	<button type="submit">검색하기</button>
		            	</form>
		        	</div>
		    	</div>
		    	<hr/>
		    	<ul id="placesList"></ul>
		    	<div id="pagination"></div>
			</div>
		</div>
		
		<%-- 2. 상세 일정 관련 박스 --%>
		<div class="planbox col-5 d-block" id="tabdiv">
			<div class="tab-nav row mx-0 mt-2 justify-content-end" data-count="${plan.dateCount}">
				<%-- 2-2- 전체 상세일정 저장 버튼 --%>
				<button type="button" id="submitAll" class="btn btn-sm btn-primary col-1  mr-2">
					<i class="fa-regular fa-floppy-disk"></i>
				</button>

				<button type="button" class="btn btn-outline-default text-dark col-1 border" id="prev-btn" data-index="0">
					<i class="fa-solid fa-angle-left"></i>
				</button>
				<button type="button" class="btn btn-outline-default text-dark col-1 border" id="next-btn" data-index="2">
					<i class="fa-solid fa-angle-right"></i>
				</button>
			</div>
			
			<%-- 2-3- planMst form --%>
			<form id="frm0" name="frm0" action="#" method="post">
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" readonly/>
				<%-- [pk] planNum --%>
				<input type="hidden" class="form-control" name="planNum" value="${plan.planNum}" value="0" readonly/>
				<%-- userId --%>
				<input type="hidden" class="form-control" name="userId" value="${id }" value="0" readonly/>
				<%-- planName --%>
				<input type="hidden" class="form-control" name="planName" value="${plan.planName}" readonly/>
				<%-- startDate --%>
				<input type="hidden" class="form-control" name="startDate" value="${plan.startDate}" readonly/>
				<%-- endDate --%>
				<input type="hidden" class="form-control" name="endDate" value="${plan.endDate}" readonly/>
				<%-- dateCount --%>
				<input type="hidden" class="form-control" name="dateCount" value="${plan.dateCount}" readonly/>
				<%-- eventColor --%>
				<input type="hidden" class="form-control" name="eventColor" value="${plan.eventColor}" readonly/>
			</form>
			
			<%-- 2-4- dateCount만큼 반복해서 생성되는 tab 박스 --%>
			<div id="tab-1" class="tab-content active">
				<h3 class="display-4 font-italic" id="date-title">DAY 1 : ${plan.startDate }</h3>
				<hr />
				<p class="mt-2">일정 : <span class="showIndex">0</span> / 10</p>
				<div class="inputDiv">
					<%-- 2-4-1 하나의 date안에 planDt form --%>
					<form id="frm1" name="frm1" action="#" method="post" data-count="0" data-day="day1" data-date="${plan.startDate}">
						
						<div class="detail1 mt-2 py-2 border bg-light rounded" data-index="1">
							<h3 class="font-italic ml-2 d-inline mt-2">Place</h3>
							<%-- placeName --%>
							<input type="text" class="form-control col-8 d-inline ml-3" name="placeName" readonly/>
							<button type="button" class="btn btn-sm btn-danger deleteBtn float-right mr-2 mt-1" data-index="1"><i class="fa-solid fa-minus"></i></button>
							<button type="button" class="btn btn-sm btn-dark detailBtn float-right mr-2 mt-1" data-count="0"><i class="fa-solid fa-angles-down"></i></button>
							<hr />

							<div class="inputbox row mx-0 justify-content-between">
								<%-- [pk] planDtNum --%>
								<input type="hidden" class="form-control" name="planDtNum" value="0" readonly/>
								<%-- planDay --%>
								<input type="hidden" class="form-control" name="planDay" value="day1" readonly/>
								<%-- placeCount --%>
								<input type="hidden" class="form-control" name="placeCount" readonly/>
								<%-- planDate --%>
								<input type="hidden" class="form-control" name="planDate" value="${plan.startDate}" readonly/>
								<%-- latitude --%>
								<input type="hidden" class="form-control" name="latitude" readonly/>
								<%-- longitude --%>
								<input type="hidden" class="form-control" name="longitude" readonly/>
								<%-- address --%>
								<input type="hidden" class="form-control" name="address" readonly/>
								<%-- category --%>
								<input type="hidden" class="form-control" name="category" readonly/>
								
								<%-- startTime --%>
								<div class="form-group col-6">
									<label for="startTime">StartTime</label>
									<input type="time" class="form-control" name="startTime" />
								</div>
								
								<%-- endTime --%>
								<div class="form-group col-6">
									<label for="endTime">EndTime</label>
									<input type="time" class="form-control" name="endTime" />
								</div>
								
								<%-- theme --%>
								<div class="form-group col-6">
									<label for="theme">목적</label>
									<select class="custom-select my-1 mr-sm-2 " id="theme" name="theme">
										<option value="방문" selected>방문</option>
										<option value="데이트">데이트</option>
										<option value="가족여행">가족여행</option>
										<option value="친구들과">친구들과</option>
										<option value="맛집탐방">맛집탐방</option>
										<option value="비즈니스">비즈니스</option>
										<option value="소개팅">소개팅</option>
										<option value="미용">미용</option>
										<option value="운동">운동</option>
										<option value="문화생활">문화생활</option>
										<option value="여가생활">여가생활</option>
									</select>
								</div>
								
								<%-- transportation --%>								
								<div class="form-group col-6">
									<label for="transportation">교통수단</label>
									<select class="custom-select my-1 mr-sm-2 " id="transportation" name="transportation">
										<option value="도보" selected>도보</option>
										<option value="자가용">자가용</option>
										<option value="고속/시외/시내버스">고속/시외/시내버스</option>
										<option value="지하철">지하철</option>
										<option value="자전거">자전거</option>
										<option value="택시">택시</option>
										<option value="전세/관광버스">전세/관광버스</option>
										<option value="차량대여/렌트">차량대여/렌트</option>
										<option value="오토바이">오토바이</option>
										<option value="전동킥보드">전동킥보드</option>
										<option value="비행기">비행기</option>
										<option value="선박">선박</option>
										<option value="기타">기타</option>
									</select>
								</div>
								
								<%-- details --%>	
								<div class="form-group col-12 toggle none">
									<label for="details">상세 일정</label>
									<textarea rows="5" class="form-control" name="details" ></textarea>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</section>

<%-- 저장 누를 시 생성되는 modal창 --%>
<div class="container">
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal"/>
	<%-- modal창 --%>
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-md text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h3 class="modal-title font-italic">WAYG</h3>
				</div>
				<div class="modal-body bg-light">
					<h4></h4>
				</div>
				<div class="modal-footer bg-light row mx-0">
					<button id="trueBtn" type="button" class="btn btn-sm btn-primary col-6 mx-0 border-white">저장</button>
					<button id="falseBtn" type="button" class="btn btn-sm btn-danger col-6 mx-0 border-white" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" src="js/plan/kakaomap/kakaomap.js"></script>

<%@ include file="../includes/footer.jsp" %>

</body>
</html>
