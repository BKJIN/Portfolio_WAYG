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
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3&libraries=services"></script>
<script type="text/javascript" src="../js/plan/plan_modify.js"></script>
<link rel="stylesheet" type="text/css" href="../css/plan/kakaomap/kakaomap.css" />
<link rel="stylesheet" type="text/css" href="../css/plan/plan_detail.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
<script>
var dateCount = '<c:out value="${plan1.dateCount}" />';


var selectDts = [];

<c:forEach var="plan2" items="${plan2 }">

var selectDt = {
		planDtNum : "${plan2.planDtNum}",
		theme : "${plan2.theme}",
		transportation : "${plan2.transportation}"
}

selectDts.push(selectDt);
</c:forEach>

</script>
</head>

<body>
<%@ include file="../includes/header.jsp" %>

<section class="container-fluid">
	<div class="planlist row mx-0">
		<%-- 1. 카카오 맵 --%>
		<div id="kakaobox" class="map_wrap col-7">
			<%-- 1- 맵이 생성되는 박스 --%>
			<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
			
			<%-- 2- 맵 검색 창 --%>
			<div id="menu_wrap" class="bg_white">
		    	<div class="option">
		        	<div>
		            	<form onsubmit="searchPlaces(); return false;">
		                	키워드 : <input type="text" value="이태원 맛집" id="keyword" size="15"> 
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
			<div class="tab-nav row mx-0 mt-2 justify-content-end" data-count="${plan1.dateCount}">
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
				<input type="hidden" class="form-control" name="planNum" value="${plan1.planNum}" value="0" readonly/>
				<%-- planName --%>
				<input type="hidden" class="form-control" name="planName" value="${plan1.planName}" readonly/>
				<%-- startDate --%>
				<input type="hidden" class="form-control" name="startDate" value="${plan1.startDate}" readonly/>
				<%-- endDate --%>
				<input type="hidden" class="form-control" name="endDate" value="${plan1.endDate}" readonly/>
				<%-- dateCount --%>
				<input type="hidden" class="form-control" name="dateCount" value="${plan1.dateCount}" readonly/>
				<%-- eventColor --%>
				<input type="hidden" class="form-control" name="eventColor" value="${plan1.eventColor}" readonly/>
				
				<%-- deleteDtNum : 수정하면서 삭제된 planDtNum이 입력되는 input --%>
				<input type="hidden" class="form-control" name="deleteDtNum" readonly/>
			</form>
			
			<%-- 2-4- dateCount만큼 반복해서 생성되는 tab 박스, 1번째만 .active로 생성 --%>
			<c:forEach var="i" begin="1" end="${plan1.dateCount }">
				<c:choose>
					<c:when test="${i == 1}">
						<div id="tab-${i}" class="mt-2 tab-content active">
					</c:when>
					
					<c:otherwise>
						<div id="tab-${i}" class="mt-2 tab-content">
					</c:otherwise>
				</c:choose>
					<h3 class="display-4 font-italic" id="date-title"></h3>
					<hr />
					<p class="mt-2">일정 :  <span class="showIndex">0</span> / 10</p>
					<div class="inputDiv">
						<%-- 2-4-1 하나의 date안에 planDt form --%>
						<form id="frm${i}" name="frm${i}" action="#" method="post" data-count="0" data-day="day${i}" data-date="${plan1.startDate }">
							<%-- planDay�� �대�뱁���� 諛��ㅼ�� ���몄�쇱���� 留��ㅺ린 ���댁�� day+i 媛��� 蹂���濡� ���� --%>
							<c:set var="day" value="day${i}" />
							<%-- planDt(plan2)�� 諛곗�� 湲몄�대��� 諛�蹂� --%>
							<c:forEach var="plan2" items="${plan2}">
								<%-- planDt(plan2)�� planDay媛� �대�뱁���� ��吏��쇰��留� 諛�蹂듯�댁�� ���몄�쇱�� 諛��� ���� --%>
								<c:if test="${plan2.planDay eq day}">
									<div class="detail0 mt-2 py-2 border bg-light rounded">
										<h3 class="font-italic ml-2 d-inline mt-2">Place</h3>
										<%-- placeName --%>
										<input type="text" class="form-control col-8 d-inline ml-3" name="placeName" value="${plan2.placeName }" readonly/>
										<button type="button" class="btn btn-sm btn-danger deleteBtn float-right mr-2 mt-1"><i class="fa-solid fa-minus"></i></button>
										<button type="button" class="btn btn-sm btn-dark detailBtn float-right mr-2 mt-1" data-count="0"><i class="fa-solid fa-angles-down"></i></button>
										<hr />
			
										<div class="inputbox row mx-0 justify-content-between">
											<%-- [pk] planDtNum --%>
											<input type="hidden" class="form-control" name="planDtNum" value="${plan2.planDtNum }" readonly/>
											<%-- planDay --%>
											<input type="hidden" class="form-control" name="planDay" value="${plan2.planDay}" readonly/>
											<%-- placeCount --%>
											<input type="hidden" class="form-control" name="placeCount" value="${plan2.placeCount}" readonly/>
											<%-- planDate --%>
											<input type="hidden" class="form-control" name="planDate" value="${plan2.planDate}" readonly/>
											<%-- latitude --%>
											<input type="hidden" class="form-control" name="latitude" value="${plan2.latitude}" readonly/>
											<%-- longitude --%>
											<input type="hidden" class="form-control" name="longitude" value="${plan2.longitude}" readonly/>
											<%-- address --%>
											<input type="hidden" class="form-control" name="address" value="${plan2.address}" readonly/>
											<%-- category --%>
											<input type="hidden" class="form-control" name="category" value="${plan2.category}" readonly/>
											
											<%-- startTime --%>
											<div class="form-group col-6">
												<label for="startTime">StartTime</label>
												<input type="time" class="form-control" name="startTime" value="${plan2.startTime}" />
											</div>
											
											<%-- endTime --%>
											<div class="form-group col-6">
												<label for="endTime">EndTime</label>
												<input type="time" class="form-control" name="endTime" value="${plan2.endTime}" />
											</div>
											
											<%-- theme --%>
											<div class="form-group col-6">
												<label for="theme">방문</label>
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
												<label for="details">취소</label>
												<textarea rows="5" class="form-control" name="details" >${plan2.details}</textarea>
											</div>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</form>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</section>

<%-- 저장 누를 시 생성되는 modal창 --%>
<div class="container">
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal"/>
	<!-- modal李� -->
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
					<button id="falseBtn" type="button" class="btn btn-sm btn-danger col-6 mx-0 border-white" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" src="../js/plan/kakaomap/kakaomap.js"></script>

<%@ include file="../includes/footer.jsp" %>

</body>
</html>
