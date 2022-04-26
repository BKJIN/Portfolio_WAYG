<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf6683abe4ec90dcf4215a32469205b3&libraries=services,clusterer,drawing"></script>

</head>
<body>
	<%-- modal 창 --%>
	<div class="modal fade" id="detailModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-xl d-block">
			<%-- modal 창 닫기 버튼 --%>
			<button type="button" id="modalCloseBtn" class="btn btn-sm btn-default text-white text-weight-bold display-1 float-right" data-dismiss="modal">&times;</button>
			<div class="modal-content">
				<%-- 1. modal header --%>
				<div class="modal-header bg-light d-flex justify-content-start">
					<%-- 해당 Plan의 이름 --%>
					<h4 id="plan-name" class="modal-title display-4 font-italic"></h4>
				</div>
				
				<%-- 2. modal body --%>
				<div class="modal-body bg-light">
					<%-- 1- PlanMst 수정 form --%>
					<form action="#" class="row" method="post" id="modify_form">
						<%-- 1-1- _csrf input --%>
						<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
						<%-- 1-2- planNum[hidden] : 해당 일정의 planNum --%>
						<input type="hidden" name="planNum" id="modal-planNum" />
						<%-- 1-3- originDateCount[hidden] : db에 저장되어 있는 현재 일정의 dateCount --%>
						<input type="hidden" name="originDateCount" id="modal-originDateCount" value="" />
						<%-- 1-4- newDateCount[hidden] : 수정이 끝난 날짜의 dateCount, modal창에서 수정 submit하면 계산하여 value 입력 --%>
						<input type="hidden" name="newDateCount" id="modal-newDateCount" value="" />
						
						<%-- 1-5- planName : 일정의 이름 --%>
						<div class="form-group col-8">
							<label for="planName">일정 이름</label>
							<input type="text" id="modal-planName" name="planName" class="form-control"/>
						</div>
						
						<%-- 1-6- planName : 이벤트 블럭의 색상 --%>
						<div class="form-group col-4">
							<label for="modal-eventColor">블럭 색상</label>
							<select class="custom-select my-1 mr-sm-2 " id="modal-eventColor" name="eventColor">
								<option value="#007bff" selected>Blue</option>
								<option value="#6610f2">Indigo</option>
								<option value="#6f42c1">Purple</option>
								<option value="#e83e8c">Pink</option>
								<option value="#dc3545">Red</option>
								<option value="#fd7e14">Orange</option>
								<option value="#ffc107">Yellow</option>
								<option value="#28a745">Green</option>
								<option value="#20c997">Teal</option>
								<option value="#17a2b8">Cyan</option>
								<option value="#6c757d">Gray</option>
								<option value="gray-dark">Dark Gray</option>
							</select>
						</div>
						
						<%-- 1-7- startDate : 시작일자 --%>
						<div class="form-group col-6">
							<label for="modal-startDate">시작 일자</label>
							<input type="date" id="modal-startDate" name="startDate" class="form-control"/>
						</div>
						
						<%-- 1-8- endDate : 종료일자 --%>
						<div class="form-group col-6">
							<label for="modal-endDate">종료 일자</label>
							<input type="date" id="modal-endDate" name="endDate" class="form-control"/>
						</div>
					</form>
					
					<%-- 2- buttonBox --%>
					<div class="button-group d-flex justify-content-end mt-2">
						<%-- 2-1- PlanMst 수정 내용 submit --%>
						<button type="submit" id="btn-modify" class="btn btn-sm btn-success mx-1">일정 수정</button>
						
						<%-- 2-2- PlanMst delete--%>
						<button type="button" id="btn-delete" class="btn btn-sm btn-danger mx-1">일정 삭제</button>
						
						<%-- 2-3- PlanDt 수정 페이지로 이동 --%>
						<a href="" id="btn-detail" class="btn btn-sm btn-dark mx-1">상세 수정</a>
						
						<%-- 2-4- 포스팅 작성 페이지로 이동 --%>
						<a href="" id="btn-posting" class="btn btn-sm btn-info mx-1">후기 작성</a>
					
						<%-- 마커와 폴리라인 표시 버튼 --%>
    	                <button type="button" class="btn btn-primary" id="mbtn" style="display:none">marker</button>
               		</div>
					
					<%-- 3- planDay tab button 박스 --%>
					<div class="detail-days d-flex" data-count="">
						<%-- 3-1- 이전 planDay 이동 버튼 --%>
						<button type="button" class="btn btn-outline-default text-dark col-1" id="prev-btn" data-index="0">
							<i class="fa-solid fa-angle-left"></i>
						</button>
						
						<%-- 3-2- 현재 보이는 planDay --%>
						<h4 id="plan-day" class="display-4 font-italic"></h4>
						
						<%-- 3-3- 다음 planDay 이동 버튼 --%>
						<button type="button" class="btn btn-outline-default text-dark col-1" id="next-btn" data-index="2">
							<i class="fa-solid fa-angle-right"></i>
						</button>
					</div>
					
					<%-- 4- 상세 일정 출력 박스 --%>
					<div class="plan-details mt-2 d-flex row mx-0">
						<%-- 4-1- 생성한 위치의 마커와 마커를 순서대로 선으로 연결하여 출력 --%>
						<div id="map" class="col-8 border"></div>
						
						<%-- 4-2- 상세 일정의 장소 이름, 시작/종료 시간을 출력 --%>
						<div id="details1" class="col-4 px-0">
							<c:forEach begin="1" end="10" var="i">
								<div class="list-group-item planDt${i} flex-row mx-0 px-1 pt-2">
									<h4 class="placeName col-12 font-italic"></h4>
									<h6 class="font-italic col-6 startTime"></h6>
									<h6 class="font-italic col-6 endTime"></h6>
									<input type="hidden" id="latitude"/>
		                            <input type="hidden" id="longitude"/>
		                            <input type="hidden" id="planDay"/>	
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			<div class="modal-footer bg-light mb-2"></div>
		</div>
	</div>
</div>
</body>
</html>
