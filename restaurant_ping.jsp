<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>다양한 이미지 마커 표시하기</title>
    <style>
#mapwrap{position:relative;overflow:hidden;}
.category, .category *{margin:0;padding:0;color:#000;}   
.category {position:absolute;overflow:hidden;top:10px;left:10px;width:100px;height:50px;z-index:10;border:1px solid black;font-family:'Malgun Gothic','맑은 고딕',sans-serif;font-size:12px;text-align:center;background-color:#fff;}
.category .menu_selected {background:#FF5F4A;color:#fff;border-left:1px solid #915B2F;border-right:1px solid #915B2F;margin:0 -1px;} 
.category li{list-style:none;float:left;width:50px;height:45px;padding-top:5px;cursor:pointer;} 
.category .ico_comm {display:block;margin:0 auto 2px;width:22px;height:26px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/category.png') no-repeat;} 
.category .ico_coffee {background-position:-10px 0;}  
.category .ico_store {background-position:-10px -36px;}   
.category .ico_carpark {background-position:-10px -72px;} 
.radius_border{border:1px solid #919191;border-radius:5px;}     
.custom_typecontrol {position:absolute;top:10px;right:10px;overflow:hidden;width:130px;height:30px;margin:0;padding:0;z-index:1;font-size:12px;font-family:'Malgun Gothic', '맑은 고딕', sans-serif;}
.custom_typecontrol span {display:block;width:65px;height:30px;float:left;text-align:center;line-height:30px;cursor:pointer;}
.custom_typecontrol .btn {background:#fff;background:linear-gradient(#fff,  #e6e6e6);}       
.custom_typecontrol .btn:hover {background:#f5f5f5;background:linear-gradient(#f5f5f5,#e3e3e3);}
.custom_typecontrol .btn:active {background:#e6e6e6;background:linear-gradient(#e6e6e6, #fff);}    
.custom_typecontrol .selected_btn {color:#fff;background:#425470;background:linear-gradient(#425470, #5b6d8a);}
.custom_typecontrol .selected_btn:hover {color:#fff;}   
.custom_zoomcontrol {position:absolute;top:50px;right:10px;width:36px;height:80px;overflow:hidden;z-index:1;background-color:#f5f5f5;} 
.custom_zoomcontrol span {display:block;width:36px;height:40px;text-align:center;cursor:pointer;}     
.custom_zoomcontrol span img {width:15px;height:15px;padding:12px 0;border:none;}             
.custom_zoomcontrol span:first-child{border-bottom:1px solid #bfbfbf;}  
.customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
.customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
.customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
.customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
.customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
</style>
</head>
<body>
<div id="mapwrap"> 
    <!-- 지도가 표시될 div -->
    <div id="map" style="width:100%;height:700px;"></div>
    <!-- 지도 위에 표시될 마커 카테고리 -->
    <div class="category">
        <ul>
            <li id="coffeeMenu" onclick="changeMarker('coffee')">
                <span class="ico_comm ico_coffee"></span>
                커피숍
            </li>
            <li id="storeMenu" onclick="changeMarker('store')">
                <span class="ico_comm ico_store"></span>
                음식점
            </li>
        </ul>
    </div>
    <div class="custom_typecontrol radius_border">
		<span id="btnRoadmap" class="selected_btn" onclick="setMapType('roadmap')">지도</span>
		<span id="btnSkyview" class="btn" onclick="setMapType('skyview')">스카이뷰</span>
	</div>
	<!-- 지도 확대, 축소 컨트롤 div 입니다 -->
    <div class="custom_zoomcontrol radius_border"> 
        <span onclick="zoomIn()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_plus.png" alt="확대"></span>  
        <span onclick="zoomOut()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_minus.png" alt="축소"></span>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=81665cc64fef46d712fbe431d5b72140"></script>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div  
    mapOption = { 
        center: new kakao.maps.LatLng(35.902054060243, 128.848834508688), // 지도의 중심좌표 
        level: 5 // 지도의 확대 레벨 
    }; 

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다


// 커피숍 마커가 표시될 좌표 배열입니다
var coffeePositions = [ 
    new kakao.maps.LatLng( 35.9054488,128.840474),
    new kakao.maps.LatLng(35.9043925, 128.841779)              
];

// 편의점 마커가 표시될 좌표 배열입니다
var storePositions = [
    new kakao.maps.LatLng(35.9046648, 128.841652 ),
    new kakao.maps.LatLng(35.9048545, 128.841624)
];


var markerImageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/category.png';  // 마커이미지의 주소입니다. 스프라이트 이미지 입니다
    coffeeMarkers = [], // 커피숍 마커 객체를 가지고 있을 배열입니다
    storeMarkers = []; // 편의점 마커 객체를 가지고 있을 배열입니다

    
createCoffeeMarkers(); // 커피숍 마커를 생성하고 커피숍 마커 배열에 추가합니다
createStoreMarkers(); // 편의점 마커를 생성하고 편의점 마커 배열에 추가합니다

changeMarker('coffee'); // 지도에 커피숍 마커가 보이도록 설정합니다    


// 마커이미지의 주소와, 크기, 옵션으로 마커 이미지를 생성하여 리턴하는 함수입니다
function createMarkerImage(src, size, options) {
    var markerImage = new kakao.maps.MarkerImage(src, size, options);
    return markerImage;            
}

// 좌표와 마커이미지를 받아 마커를 생성하여 리턴하는 함수입니다
function createMarker(position, image) {
    var marker = new kakao.maps.Marker({
        position: position,
        image: image
    });
    
    return marker;  
}   
   
// 커피숍 마커를 생성하고 커피숍 마커 배열에 추가하는 함수입니다
function createCoffeeMarkers() {
    
    for (var i = 0; i < coffeePositions.length; i++) {  
        
        var imageSize = new kakao.maps.Size(22, 26),
            imageOptions = {  
                spriteOrigin: new kakao.maps.Point(10, 0),    
                spriteSize: new kakao.maps.Size(36, 98)  
            };     
        
        // 마커이미지와 마커를 생성합니다
        var markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions),    
            marker = createMarker(coffeePositions[i], markerImage);  
        
        // 생성된 마커를 커피숍 마커 배열에 추가합니다
        coffeeMarkers.push(marker);
    }     
}

// 커피숍 마커들의 지도 표시 여부를 설정하는 함수입니다
function setCoffeeMarkers(map) {        
    for (var i = 0; i < coffeeMarkers.length; i++) {  
        coffeeMarkers[i].setMap(map);
    }        
}

// 편의점 마커를 생성하고 편의점 마커 배열에 추가하는 함수입니다
function createStoreMarkers() {
    for (var i = 0; i < storePositions.length; i++) {
        
        var imageSize = new kakao.maps.Size(22, 26),
            imageOptions = {   
                spriteOrigin: new kakao.maps.Point(10, 36),    
                spriteSize: new kakao.maps.Size(36, 98)  
            };       
     
        // 마커이미지와 마커를 생성합니다
        var markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions),    
            marker = createMarker(storePositions[i], markerImage);  

        // 생성된 마커를 편의점 마커 배열에 추가합니다
        storeMarkers.push(marker);    
    }        
}

// 편의점 마커들의 지도 표시 여부를 설정하는 함수입니다
function setStoreMarkers(map) {        
    for (var i = 0; i < storeMarkers.length; i++) {  
        storeMarkers[i].setMap(map);
    }        
}



// 카테고리를 클릭했을 때 type에 따라 카테고리의 스타일과 지도에 표시되는 마커를 변경합니다
function changeMarker(type){
    
    var coffeeMenu = document.getElementById('coffeeMenu');
    var storeMenu = document.getElementById('storeMenu');
    
    // 커피숍 카테고리가 클릭됐을 때
    if (type === 'coffee') {
    
        // 커피숍 카테고리를 선택된 스타일로 변경하고
        coffeeMenu.className = 'menu_selected';
        
        // 편의점과 주차장 카테고리는 선택되지 않은 스타일로 바꿉니다
        storeMenu.className = '';
        
        // 커피숍 마커들만 지도에 표시하도록 설정합니다
        setCoffeeMarkers(map);
        setStoreMarkers(null);
        
    } else if (type === 'store') { // 편의점 카테고리가 클릭됐을 때
    
        // 편의점 카테고리를 선택된 스타일로 변경하고
        coffeeMenu.className = '';
        storeMenu.className = 'menu_selected';
        
        // 편의점 마커들만 지도에 표시하도록 설정합니다
        setCoffeeMarkers(null);
        setStoreMarkers(map);
        
    } 
}
/*
//클릭한 마커에 대한 장소 상세정보를 커스텀 오버레이로 표시하는 함수입니다
function displayPlaceInfo (place) {
    var content = '<div class="placeinfo">' +
                    '   <a class="title" href="' + place.place_url + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</a>';   

    if (place.road_address_name) {
        content += '    <span title="' + place.road_address_name + '">' + place.road_address_name + '</span>' +
                    '  <span class="jibun" title="' + place.address_name + '">(지번 : ' + place.address_name + ')</span>';
    }  else {
        content += '    <span title="' + place.address_name + '">' + place.address_name + '</span>';
    }                
   
    content += '    <span class="tel">' + place.phone + '</span>' + 
                '</div>' + 
                '<div class="after"></div>';

    contentNode.innerHTML = content;
    placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
    placeOverlay.setMap(map);  
}
*/

/*
var content = '<div class="customoverlay">' +
'  <a href="https://map.kakao.com/link/map/11394059" target="_blank">' +
'    <span class="title">구의야구공원</span>' +
'  </a>' +
'</div>';


//커스텀 오버레이가 표시될 위치입니다 
var position = new kakao.maps.LatLng(35.9054488,128.840474);


//커스텀 오버레이를 생성합니다
var customOverlay = new kakao.maps.CustomOverlay({
    map: map,
    position: position,
    content: content,
    yAnchor: 0.3 
});*/


//지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수
function setMapType(maptype) { 
    var roadmapControl = document.getElementById('btnRoadmap');
    var skyviewControl = document.getElementById('btnSkyview'); 
    if (maptype === 'roadmap') {
        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);    
        roadmapControl.className = 'selected_btn';
        skyviewControl.className = 'btn';
    } else {
        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);    
        skyviewControl.className = 'selected_btn';
        roadmapControl.className = 'btn';
    }
}

//지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
function zoomIn() {
    map.setLevel(map.getLevel() - 1);
}

// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
function zoomOut() {
    map.setLevel(map.getLevel() + 1);
}


//HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
            message = '<div style="padding:5px;">여기에 계신가요?!</div>'; // 인포윈도우에 표시될 내용입니다
        
        // 마커와 인포윈도우를 표시합니다
        displayMarker(locPosition, message);
            
      });
    
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    
    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
        message = 'geolocation을 사용할수 없어요..'
        
    displayMarker(locPosition, message);
}

//지도에 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, message) {

 // 마커를 생성합니다
 var marker = new kakao.maps.Marker({  
     map: map, 
     position: locPosition
 }); 
 
 var iwContent = message, // 인포윈도우에 표시할 내용
     iwRemoveable = true;

 // 인포윈도우를 생성합니다
 var infowindow = new kakao.maps.InfoWindow({
     content : iwContent,
     removable : iwRemoveable
 });
 
 // 인포윈도우를 마커위에 표시합니다 
 infowindow.open(map, marker);
 
 // 지도 중심좌표를 접속위치로 변경합니다
 map.setCenter(locPosition);      
}    


</script>
</body>
</html>