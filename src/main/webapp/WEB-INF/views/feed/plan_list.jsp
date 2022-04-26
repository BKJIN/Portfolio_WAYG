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
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<title>Plan List</title>
<style>
.map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
.map_wrap {position:relative;width:100%;height:500px;}
#menu_wrap {position:absolute;top:0;left:0;bottom:0;width:250px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(255, 255, 255, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
.bg_white {background:#fff;}
#menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
#menu_wrap .option{text-align: center;}
#menu_wrap .option p {margin:10px 0;}  
#menu_wrap .option button {margin-left:5px;}
#placesList li {list-style: none;}
#placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
#placesList .item span {display: block;margin-top:4px;}
#placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
#placesList .item .info{padding:10px 0 10px 55px;}
#placesList .info .gray {color:#8a8a8a;}
#placesList .info .jibun {padding-left:26px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
#placesList .info .tel {color:#009900;}
#placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
#placesList .item .marker_1 {background-position: 0 -10px;}
#placesList .item .marker_2 {background-position: 0 -56px;}
#placesList .item .marker_3 {background-position: 0 -102px}
#placesList .item .marker_4 {background-position: 0 -148px;}
#placesList .item .marker_5 {background-position: 0 -194px;}
#placesList .item .marker_6 {background-position: 0 -240px;}
#placesList .item .marker_7 {background-position: 0 -286px;}
#placesList .item .marker_8 {background-position: 0 -332px;}
#placesList .item .marker_9 {background-position: 0 -378px;}
#placesList .item .marker_10 {background-position: 0 -423px;}
#placesList .item .marker_11 {background-position: 0 -470px;}
#placesList .item .marker_12 {background-position: 0 -516px;}
#placesList .item .marker_13 {background-position: 0 -562px;}
#placesList .item .marker_14 {background-position: 0 -608px;}
#placesList .item .marker_15 {background-position: 0 -654px;}
#pagination {margin:10px auto;text-align: center;}
#pagination a {display:inline-block;margin-right:10px;}
#pagination .on {font-weight: bold; cursor: default;color:#777;}
#removebtn{
margin-left : 20px;
}
</style>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=92b6b7355eb56122be94594a5e40e5fd&libraries=services"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=92b6b7355eb56122be94594a5e40e5fd"></script>
</head>
<body>
<a href = "main">main</a><br/>
<a href = "markerclusterer">markerclusterer</a>

<div class="container">
<h3>DATE 1 : ${mstDto.startDate }</h3>
<hr/>

<!-- input창 -->
<div>
총 갯수 : <span id="showIndex"></span> / 10
</div>
<button type="button" id="insertButton" class="btn btn-success" style="float: right;">추가</button>	
<form id="frm" name="frm" action="feed/insertMap" method="post">	
	<input type="text" id="index" name="placecount" value=""/>
	<input type="text" name="planNum" id="planNum" value="${mstDto.planNum}" readonly/>
	<button type="submit" id="submit" class="btn btn-primary" style="float: right;">저장</button>   	    	    	
</form>

<!-- 저장 누를 시 생성되는 modal창 -->
<div class="container">
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal"/>
	<!-- modal창 -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;POST작성</h4>
				</div>
				<div class="modal-body bg-light">
					<h4>작성되었습니다.</h4>
				</div>
				<div class="modal-footer bg-light">
					<button id="closeBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
</div>




<!-- 맵 생성 -->
<div class="map_wrap">
	<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
	<div id="menu_wrap" class="bg_white">
    	<div class="option">
        	<div>
            	<form onsubmit="searchPlaces(); return false;">
                	키워드 : <input type="text" value="이태원 맛집" id="keyword" size="15"> 
                	<button type="submit">검색하기</button> 
            	</form>
        	</div>
    	</div>
    	<hr>
    	<ul id="placesList"></ul>
    	<div id="pagination"></div>
	</div>
</div>
</div>

<script>

//latitude, longitude, placeName 값이 들어갈 input창 생성
$(document).ready(function (){
var Form = $("#frm")
var index = 0    	
 $("#insertButton").on("click", function (){ 
     if(index == 10){  // input창 생성 제한
        alert("10개 까지만 됩니다.")
        return false;
    }
    
    var newDiv = document.createElement("div")
    newDiv.setAttribute("class", "newDiv")
    newDiv.setAttribute("name", "index")

    var newInput1 = document.createElement("input") //위도 input
    newInput1.setAttribute("id", "latitude"+index)
    newInput1.setAttribute("type", "text")
    newInput1.setAttribute("name", "latitude"+index)
    newInput1.setAttribute("value", "")
    newInput1.setAttribute("readonly", "true")
    var newInput2 = document.createElement("input") //경도 input
    newInput2.setAttribute("id", "longitude"+index)
    newInput2.setAttribute("type", "text")
    newInput2.setAttribute("name", "longitude"+index)
    newInput2.setAttribute("value", "")
    newInput2.setAttribute("readonly", "true")
    var newInput3 = document.createElement("input") //장소명 input
    newInput3.setAttribute("id", "placeName"+index)
    newInput3.setAttribute("type", "text")
    newInput3.setAttribute("name", "placeName"+index)
    newInput3.setAttribute("value", "")
    newInput3.setAttribute("readonly", "true")    
    var newInput4 = document.createElement("input") //카테고리 input
    newInput4.setAttribute("id", "category"+index)
    newInput4.setAttribute("type", "text")
    newInput4.setAttribute("name", "category"+index)
    newInput4.setAttribute("value", "")
    newInput4.setAttribute("readonly", "true")
    var newInput5 = document.createElement("input") //카테고리 input
    newInput5.setAttribute("id", "address"+index)
    newInput5.setAttribute("type", "text")
    newInput5.setAttribute("name", "address"+index)
    newInput5.setAttribute("value", "")
    newInput5.setAttribute("readonly", "true")
     
    var removeInput = document.createElement("button") //삭제 버튼
    removeInput.setAttribute("type", "button")
    removeInput.setAttribute("id", "removebtn")
    removeInput.setAttribute("class", "btn btn-danger")
    removeInput.textContent = "삭제"
	       	
    newDiv.append(newInput1)
	newDiv.append(newInput2)
    newDiv.append(newInput3)
    newDiv.append(newInput4)
    newDiv.append(newInput5)
    newDiv.append(removeInput)
    Form.append(newDiv)
    			
    index+=1
    console.log(newDiv);
    $("#showIndex").text(index)
    $("#index").val(index)
}) 

$(document).on("click", "#removebtn", function () { // 삭제
    $(this).parent(".newDiv").remove()
    resetIndex()
})

function resetIndex(){ //삭제하면 인덱스 번호도 reset 
    index = 0
    Form.children('div').each(function (){
        var target = $(this).children(index)
        target.attr("id", target.attr("latitude"+index))
        target.attr("id", target.attr("longitude"+index))
        target.attr("id", target.attr("placeName"+index))
        target.attr("id", target.attr("category"+index))
        target.attr("id", target.attr("address"+index))
        index+=1
    })
    $("#showIndex").text(index)
    $("#index").val(index)
}

$("#insertButton").trigger("click") // 추가 버튼
$("#showIndex").text(index)       	
});

$(document).ready(function(){ 
$("#frm").submit(function(event){ //#frm의 data 전체를 ajax로 서버에 보내기
	event.preventDefault(); //원래 form의 기능인 submit를 ajax로 처리
	$.ajax({
		type : $("#frm").attr("method"),
		url : $("#frm").attr("action"),
		data : $("#frm").serialize(),
	    beforeSend: function(xhr){
 		   	var token = $("meta[name='_csrf']").attr('content');
 			var header = $("meta[name='_csrf_header']").attr('content');
		        xhr.setRequestHeader(header, token);
		},
		success : function(data){
			console.log(data);
			if(data.search("insert-success") > -1){
				$(".modal-body").text("작성되었습니다.");
				$("#modalBtn").trigger("click");
					$("#closeBtn").click(function(event){
					event.preventDefault();
					location.href = "/feed"; // 성공시 이동 페이지
				});
			}
			else{
				$(".modal-body").text("다시입력해주세요");
				$("#modalBtn").trigger("click");
			}
		},
		error : function(data){
			$(".modal-body").text("다시입력해주세요");
			$("#modalBtn").trigger("click");
		}			
	});
});
});


//마커를 담을 배열입니다
var markers = [];

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = {
    center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};  

//지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

//장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

//검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

//키워드로 장소를 검색합니다
searchPlaces();

//키워드 검색을 요청하는 함수입니다
function searchPlaces() {

var keyword = document.getElementById('keyword').value;

if (!keyword.replace(/^\s+|\s+$/g, '')) {
    alert('키워드를 입력해주세요!');
    return false;
}

// 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
ps.keywordSearch( keyword, placesSearchCB); 
}

//장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
if (status === kakao.maps.services.Status.OK) {
	  	
    // 정상적으로 검색이 완료됐으면
    // 검색 목록과 마커를 표출합니다
    displayPlaces(data);
	
    // 페이지 번호를 표출합니다
    displayPagination(pagination);

} else if (status === kakao.maps.services.Status.ZERO_RESULT) {

    alert('검색 결과가 존재하지 않습니다.');
    return;

} else if (status === kakao.maps.services.Status.ERROR) {

    alert('검색 결과 중 오류가 발생했습니다.');
    return;

}
}

//검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

console.log(places);

var listEl = document.getElementById('placesList'), 
menuEl = document.getElementById('menu_wrap'),
fragment = document.createDocumentFragment(), //새로운 빈 DocumentFragment 를 생성합니다. DocumentFragment 인터페이스는 부모가 없는 아주 작은 document 객체를 나타냅니다. 
bounds = new kakao.maps.LatLngBounds(), //LatLngBounds - WGS84 좌표계에서 사각영역 정보를 표현하는 객체를 생성한다.
										//WGS84 좌표계는 지심 좌표계인데 이것은 지구 타원체의 중심을 원점으로 하고 X, Y ,Z 방향의 축을 따라 좌표를 결정
listStr = '';

// 검색 결과 목록에 추가된 항목들을 제거합니다
removeAllChildNods(listEl);

// 지도에 표시되고 있는 마커를 제거합니다
removeMarker();


for ( var i=0; i<places.length; i++ ) {

    // 마커를 생성하고 지도에 표시합니다
    var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x), //LatLng - WGS84 좌표 정보를 가지고 있는 객체를 생성한다.
        marker = addMarker(placePosition, i), 
        itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
    
    var category = places[i].category_name; //카테고리 정보를 가지고 있는 객체 생성 
    var address = places[i].address_name; // 도로명 주소 정보를 가지고 있는 객체 생성
    console.log(address);
    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
    // LatLngBounds 객체에 좌표를 추가합니다
    bounds.extend(placePosition); //extend() - 다수의 객체를 하나의 객체로 합치는 merge기능을 수행
    
    // 마커와 검색결과 항목에 click 했을때
    // 해당 장소에 인포윈도우에 장소명을 표시합니다
    (function(marker, title, category, address) {
    	//addListener(target, type, handler) - 다음 지도 API 객체에 이벤트를 등록한다. 
    	//target : 이벤트를 지원하는 다음 지도 API 객체, type : 이벤트 이름, handler : 이벤트를 처리할 함수
    	
    	kakao.maps.event.addListener(marker, 'mouseover', function() { //마커에 마우스 올렸을 때
            displayInfowindow(marker, title); // displayInfowindow()에서 처리
        });

        kakao.maps.event.addListener(marker, 'mouseout', function() { // 마커에 마우스 치웠을 때 인포창 닫기
            infowindow.close();
        });
        
        itemEl.onmouseover =  function () { //검색목록에 마우스 올렸을 때
            displayInfowindow(marker, title); // displayInfowindow()에서 처리
        };

        itemEl.onmouseout =  function () { // 검색목록에 마우스 치웠을 때 인포창 닫기
            infowindow.close();
        };
    	        	
        kakao.maps.event.addListener(marker, 'click', function() { // 마커 클릭 시 
        	inputdata(marker, title, category, address); // inputdata()에서 처리            	
        });
    	                     
        itemEl.onclick =  function () { // 검색 목록창 클릭 시
        	inputdata(marker, title, category, address); // inputdata()에서 처리                
        }; 
    })(marker, places[i].place_name, places[i].category_name, places[i].address_name);

    fragment.appendChild(itemEl); //appendChild() - 새로운 노드를 해당 노드의 자식 노드 리스트(child node list)의 맨 마지막에 추가        
}

// 검색결과 항목들을 검색결과 목록 Element에 추가합니다
listEl.appendChild(fragment);
menuEl.scrollTop = 0; //scrollTop - 현재 스크롤의 위치값

// 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
map.setBounds(bounds); //setBounds() - 주어진 영역이 화면 안에 전부 나타날 수 있도록 지도의 중심 좌표와 확대 수준을 설정한다.
}


//검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

var el = document.createElement('li'),
itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
            '<div class="info">' +
            '   <h5>' + places.place_name + '</h5>';

        	             
            
if (places.road_address_name) {
    itemStr += '    <span>' + places.road_address_name + '</span>' +
                '   <span class="jibun gray">' +  places.address_name  + '</span>';
} else {
    itemStr += '    <span>' +  places.address_name  + '</span>'; 
}                 
  itemStr += '  <span class="tel">' + places.phone  + '</span>' +
            '</div>';       
            
el.innerHTML = itemStr;
el.className = 'item';

return el;
}

//마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
    imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
    imgOptions =  {
        spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
        spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
        offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
    },
    markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
        marker = new kakao.maps.Marker({
        position: position, // 마커의 위치
        image: markerImage 
    });

marker.setMap(map); // 지도 위에 마커를 표출합니다
markers.push(marker);  // 배열에 생성된 마커를 추가합니다

return marker;
}

//지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
for ( var i = 0; i < markers.length; i++ ) {
    markers[i].setMap(null);
}   
markers = [];
}

//검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
var paginationEl = document.getElementById('pagination'),
    fragment = document.createDocumentFragment(),
    i; 

// 기존에 추가된 페이지번호를 삭제합니다
while (paginationEl.hasChildNodes()) { //Node.hasChildNodes() - 현재 노드(Node)에게 자식노드(child nodes)가 있는지를 Boolean 값으로 반환
    paginationEl.removeChild (paginationEl.lastChild); //removeChild() - DOM에서 자식 노드를 제거하고 제거된 노드를 반환
}

for (i=1; i<=pagination.last; i++) {
    var el = document.createElement('a');
    el.href = "#";
    el.innerHTML = i;

    if (i===pagination.current) {
        el.className = 'on';
    } else {
        el.onclick = (function(i) {
            return function() {
                pagination.gotoPage(i);
            }
        })(i);
    }

    fragment.appendChild(el);
}
paginationEl.appendChild(fragment);
}

//검색결과 목록 또는 마커에 마우스 올렸을 때 호출되는 함수입니다
//인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

infowindow.setContent(content);
infowindow.open(map, marker);
}

//마커와 검색결과 목록 클릭 시 input에 data 입력
//input에 insert하기 위한 index번호 생성
var index = 0
function inputdata(marker, title, category, address) {

$('#address'+index).val(address);
$('#category'+index).val(category);
$('#latitude'+index).val(marker.getPosition().getLat());
$('#longitude'+index).val(marker.getPosition().getLng());
$('#placeName'+index).val(title);
index += 1 //index 번호 장소 선택 마다 1씩증가

}

// 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
while (el.hasChildNodes()) {
    el.removeChild (el.lastChild);
}
}



</script>
</body>
</html>
