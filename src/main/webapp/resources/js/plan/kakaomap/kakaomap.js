//마커를 담을 배열입니다
var markers = [];
var markers2 = [];

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
          
       // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
       // LatLngBounds 객체에 좌표를 추가합니다
       bounds.extend(placePosition); //extend() - 다수의 객체를 하나의 객체로 합치는 merge기능을 수행

       // 마커와 검색결과 항목에 click 했을때
       // 해당 장소에 인포윈도우에 장소명을 표시합니다
       (function(marker, title, address, category, category_code) {
          //addListener(target, type, handler) - 다음 지도 API 객체에 이벤트를 등록한다. 
          //target : 이벤트를 지원하는 다음 지도 API 객체, type : 이벤트 이름, handler : 이벤트를 처리할 함수
          
          kakao.maps.event.addListener(marker, 'mouseover', function() { //마커에 마우스 올렸을 때
               displayInfowindow(marker, title, address, category); // displayInfowindow()에서 처리
           });
   
           kakao.maps.event.addListener(marker, 'mouseout', function() { // 마커에 마우스 치웠을 때 인포창 닫기
               infowindow.close();
           });
           
           itemEl.onmouseover =  function () { //검색목록에 마우스 올렸을 때
               displayInfowindow(marker, title, address, category); // displayInfowindow()에서 처리
           };
   
           itemEl.onmouseout =  function () { // 검색목록에 마우스 치웠을 때 인포창 닫기
               infowindow.close();
           };

           kakao.maps.event.addListener(marker, 'click', function() { // 마커 클릭 시
            // 현재 보여지고 있는 탭 박스의 form을 타겟으로 선언
            var target1 = $('div.active').children('.inputDiv').children('form');
            
            // 타겟의 data-count(상세 일정 개수) value 변수 선언
            var value = target1.attr('data-count');
            
            var day = target1.attr('data-day');
            
            if ( markerValidation(day, marker) == false ) {
               if ( confirm('같은 날짜에 중복되는 장소로 생성된 일정이 있습니다. 중복으로 생성할까요?') == false ) {
                  return false;                     
               }
            }
            
            // inputdata()에서 처리
            inputdata(marker, target1, value, title, address, category);
           });
                               
           itemEl.onclick =  function () { // 검색 목록창 클릭 시
            // 현재 보여지고 있는 탭 박스의 form을 타겟으로 선언
            var target1 = $('div.active').children('.inputDiv').children('form');
            
            // 타겟의 data-count(상세 일정 개수) value 변수 선언
            var value = target1.attr('data-count');
            
            // inputdata()에서 처리
            inputdata(marker, target1, value, title, address, category, category_code);           
           }; 
       })(marker, places[i].place_name, places[i].address_name, places[i].category_name, places[i].category_group_code);
   
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
marker.setZIndex(1);

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
function displayInfowindow(marker, title, address, category) {

	if ( category == null || category == '' ) {
		category = '준비중';
	}
	
	var content = '<div class="wrap">' + 
    	       '<div class="info">' + 
	           '<div class="title bg-info">' + 
	     	   '<img src="/init/images/marker.png" width="25px" height="25px" background-color="white">&nbsp;&nbsp;&nbsp;' + 
	     		title + 
	            '</div>' + 
	            '<div class="body">' + 
	            '<div class="img">' +
	            '<img src="/init/images/infowindow-logo.png">' +
	            '</div>' + 
	            '<div class="content">' + 
	            '<div class="address">' + '주소 : ' + address + '</div>' +
	            '<div class="category">' + '장소 : ' + category + '</div>' +
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

//마커와 검색결과 목록 클릭 시 input에 data 입력
function inputdata(marker, target1, value, title, address, category, category_code) {
   // 현재 상세 일정에 추가할 것이므로 일정 개수(value) + 1한 값을 변수로 선언
   var plusVal = Number(value)+1;
   
   // 현재 value가 10인 경우, 10개 이상 만들지 못하게 return false
   if ( value > 9 ) {
      alert('하루에 열개 이상의 일정을 생성할 수 없습니다.');
      return false;

   // 현재 value가 1개 이상 10개 미만일 때, 새로운 상세일정 빈 박스를 생성하고 plusVal 변수로 인덱싱
   } else if ( value != 0 ){
      var boxHtml = '<div class="detail' + plusVal + ' mt-2 py-2 border bg-light rounded">'
               + '<h3 class="font-italic ml-2 d-inline mt-2">Place</h3>'
               + '<!-- placeName -->'
               + '<input type="text" class="form-control col-8 d-inline ml-3" name="placeName" readonly/>'
               + '<button type="button" class="btn btn-sm btn-danger deleteBtn float-right mr-2 mt-1" ><i class="fa-solid fa-minus"></i></button>'
               + '<button type="button" class="btn btn-sm btn-dark detailBtn float-right mr-2 mt-1" data-count="0"><i class="fa-solid fa-angles-down"></i></button>'
               + '<hr />'
               + '<div class="inputbox row mx-0 justify-content-between">'
               + '<!-- [pk] planDtNum -->'
               + '<input type="hidden" class="form-control" name="planDtNum" value="0" readonly/>'
               + '<!-- day -->'
               + '<input type="hidden" class="form-control" name="planDay" readonly/>'
               + '<!-- placeCount -->'
               + '<input type="hidden" class="form-control" name="placeCount" readonly/>'
               + '<!-- planDate -->'
               + '<input type="hidden" class="form-control" name="planDate" readonly/>'
               + '<!-- latitude -->'
               + '<input type="hidden" class="form-control" name="latitude" readonly/>'
               + '<!-- longitude -->'
               + '<input type="hidden" class="form-control" name="longitude" readonly/>'
               + '<!-- address -->'
               + '<input type="hidden" class="form-control" name="address" readonly/>'
               + '<!-- category -->'
               + '<input type="hidden" class="form-control" name="category" readonly/>'
               + '<!-- startTime -->'
               + '<div class="form-group col-6">'
               + '<label for="startTime">StartTime</label>'
               + '<input type="time" class="form-control" name="startTime" value="" />'
               + '</div>'
               + '<!-- endTime -->'
               + '<div class="form-group col-6">'
               + '<label for="endTime">EndTime</label>'
               + '<input type="time" class="form-control" name="endTime" value="" />'
               + '</div>'
               + '<!-- theme -->'
               + '<div class="form-group col-6">'
               + '<label for="theme">목적</label>'
               + '<select class="custom-select my-1 mr-sm-2 " id="theme" name="theme">'
               + '<option value="방문" selected>방문</option>'
               + '<option value="데이트">데이트</option>'
               + '<option value="가족여행">가족여행</option>'
               + '<option value="친구들과">친구들과</option>'
               + '<option value="맛집탐방">맛집탐방</option>'
               + '<option value="비즈니스">비즈니스</option>'
               + '<option value="소개팅">소개팅</option>'
               + '<option value="미용">미용</option>'
               + '<option value="운동">운동</option>'
               + '<option value="문화생활">문화생활</option>'
               + '<option value="여가생활">여가생활</option>'
               + '</select>'
               + '</div>'
               + '<!-- transportation -->'
			   + '<div class="form-group col-6">'
			   + '<label for="transportation">교통수단</label>'
			   + '<select class="custom-select my-1 mr-sm-2 " id="transportation" name="transportation">'
			   + '<option value="도보" selected>도보</option>'
			   + '<option value="자가용">자가용</option>'
			   + '<option value="고속/시외/시내버스">고속/시외/시내버스</option>'
			   + '<option value="지하철">지하철</option>'
			   + '<option value="자전거">자전거</option>'
			   + '<option value="택시">택시</option>'
			   + '<option value="전세/관광버스">전세/관광버스</option>'
			   + '<option value="차량대여/렌트">차량대여/렌트</option>'
			   + '<option value="오토바이">오토바이</option>'
			   + '<option value="전동킥보드">전동킥보드</option>'
			   + '<option value="비행기">비행기</option>'
			   + '<option value="선박">선박</option>'
			   + '<option value="기타">기타</option>'
			   + '</select>'
			   + '</div>'
               + '<!-- details -->'
               + '<div class="form-group col-12 toggle none">'
               + '<label for="details">상세 일정</label>'
               + '<textarea rows="5" class="form-control" name="details" value="" ></textarea>'
               + '</div>'
               + '</div>'
               + '</div>';
      
      // form 안에 제일 마지막 child로 박스 생성
      target1.append(boxHtml);

   }
   
   // 맵에서 나온 값을 입력할 .detail 박스
   var target2 = target1.children('.detail' + plusVal);
   
   // 위에서 생성한 .detail 박스안에 input이 들어있는 박스
   var target3 = target1.children('.detail' + plusVal).children('.inputbox');

   // detail박스에 placeName input에 marker의 title 입력
   target2.children('input[name=placeName]').val(title);

   // 맵에서 나오는 정보를 갖는 input에 해당 데이터 모두 입력
   target3.children('input[name=latitude]').val(marker.getPosition().getLat());
   target3.children('input[name=longitude]').val(marker.getPosition().getLng());
   
   target3.children('input[name=address]').val(address);
   target3.children('input[name=category]').val(category_code);

   // form에 attr를 이용하여 planDay, planDate 입력
   target3.children('input[name=planDay]').val(target1.attr('data-day'));
   target3.children('input[name=planDate]').val(target1.attr('data-date'));

   // form attr를 +1하고, 현재 일정 개수를 표시해주는 텍스트도 변경
   target1.attr('data-count', plusVal);               
   target1.parent().siblings('p.mt-2').children('.showIndex').text(plusVal);
   
   
   //클릭한 마커에 임의로 지정한 마커 생성
   var imageSrc = '/init/images/marker.png', // 마커이미지의 경로    
    imageSize = new kakao.maps.Size(50, 50), // 마커이미지의 크기입니다
    imageOption = {offset: new kakao.maps.Point(10, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
   
   var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption), //마커 이미지 옵션을 markerImage객체에 담기
    markerPosition = new kakao.maps.LatLng(marker.getPosition().getLat(), marker.getPosition().getLng()); // 마커가 표시될 위치입니다
   
   var marker = new kakao.maps.Marker({ //설정한 좌표와 이미지 마커 객체에 담기
     position: markerPosition, //마커 좌표 설정
     image: markerImage, // 마커이미지 설정    
   });

   marker.setMap(map); // 마커를 맵에 생성

   // 현재 작성중인 planDay를 변수로 선언
   var planDay = target1.attr('data-day');
   
   // 현재 작성중인 planDay에 맞는 배열에 marker를 저장
   addMarkerArray(planDay, marker);
   
   //사용자가 임의로 만든 마커의 인포윈도우 생성 이벤트 등록
   kakao.maps.event.addListener(marker, 'mouseover', function() { //마커에 마우스 올렸을 때
        displayInfowindow(marker, title, address, category); // displayInfowindow()에서 처리
    });

        kakao.maps.event.addListener(marker, 'mouseout', function() { // 마커에 마우스 치웠을 때 인포창 닫기
        infowindow.close();
    });    

}

// 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {
   while (el.hasChildNodes()) {
       el.removeChild (el.lastChild);
   }
}

// 마커를 각 일정에 맞는 배열에 저장하는 메서드
function addMarkerArray(planDay, marker) {
   // {planDay , marker}로 구성된 객체로 생성하여 markers2 배열에 저장
   var planObject = {
      day : planDay,
      mapMarker : marker
   }
   markers2.push(planObject);
};

// 마커를 개별적으로 삭제하는 메서드
function removeMarkerArray(planDay, index) {
   var dayMarker = [];
   
   // planDay가 같은 마커를 dayMarker 배열에 따로 push
   for ( var i = 0; i < markers2.length; i++ ) {
      if ( markers2[i].day == planDay ) {
         dayMarker.push(markers2[i]);
      }
   }
   // planDay가 같은 마커 중 해당하는 index번째에 마커를 map에서 지움
   dayMarker[index].mapMarker.setMap(null);
   
   var count = 0;
   // markers2에서 다시 planDay가 같은 마커를 찾음
   for ( var i = 0; i < markers2.length; i++ ) { 
      if( markers2[i].day == planDay ) {
         // planDay가 같은 걸 찾았을 때, index번째 인지 확인
         if ( count == index ) {
            // 맞으면 지우고 반복문을 더 이상 수행하지 않고 나감
            markers2.splice(i, 1);
            break;
         }
         // index 번째가 아니면 count를 ++하고 반복문 수행
         count++;
      }
   }
};

// 맵에 각 일정에 맞는 마커만 표시하는 메서드
function setDayMap(planday) {
   for ( var i = 0; i < markers2.length; i++ ) {
      if( markers2[i].day == planday ) {
         markers2[i].mapMarker.setMap(map);
      } else {
         markers2[i].mapMarker.setMap(null);
      }
   }
}

// 같은 날짜에 동일한 장소로 일정 생성 확인
function markerValidation(day, marker) {
   var validation = true;
   for ( var i = 0; i < markers2.length; i++ ) {
      if ( markers2[i].day == day && 
          markers2[i].mapMarker.getPosition().getLat() == marker.getPosition().getLat() && 
          markers2[i].mapMarker.getPosition().getLng() == marker.getPosition().getLng()) {
         validation = false;
      }               
   }
   return validation;
}