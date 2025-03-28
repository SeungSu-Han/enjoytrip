<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ENJOY TRIP - 여행을 즐기다</title>
<style>
#map {
  width: 100%;
  height: 400px;
  margin-top: 20px;
  margin-bottom: 20px;
}
.region-selection {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}
.region-selection select {
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ced4da;
  min-width: 120px;
}
.popular-places {
  margin-top: 30px;
}
.place-cards {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-top: 20px;
}
.place-card {
  width: 250px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}
.place-card:hover {
  transform: translateY(-5px);
}
.place-img {
  width: 100%;
  height: 150px;
  object-fit: cover;
}
.place-info {
  padding: 15px;
}
.place-title {
  font-weight: bold;
  margin-bottom: 5px;
}
.place-address {
  color: #666;
  font-size: 0.9em;
}
.banner {
  background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://source.unsplash.com/1600x900/?korea,travel');
  height: 300px;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  position: relative;
  margin-bottom: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  text-align: center;
}
.banner h1 {
  font-size: 3em;
  margin-bottom: 15px;
}
.banner p {
  font-size: 1.2em;
  max-width: 600px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <!-- Hero Banner -->
    <div class="banner">
        <div>
            <h1>ENJOY TRIP</h1>
            <p>대한민국의 아름다운 관광지를 발견하고 나만의 여행을 계획해보세요.</p>
        </div>
    </div>
    
    <div class="container">
        <!-- 지도 표시 영역 -->
        <div class="card mt-4">
            <div class="card-header">
                <h4>지역 관광지 탐색</h4>
            </div>
            <div class="card-body">
                <!-- 지역 선택 드롭다운 -->
                <div class="region-selection">
                    <select id="sidoSelect" class="form-select">
                        <option value="">시/도 선택</option>
                    </select>
                    <select id="sigunguSelect" class="form-select">
                        <option value="">시/군/구 선택</option>
                    </select>
                    <select id="contentTypeSelect" class="form-select">
                        <option value="">관광지 유형</option>
                        <option value="12">관광지</option>
                        <option value="14">문화시설</option>
                        <option value="15">축제공연행사</option>
                        <option value="25">여행코스</option>
                        <option value="28">레포츠</option>
                        <option value="32">숙박</option>
                        <option value="38">쇼핑</option>
                        <option value="39">음식점</option>
                    </select>
                    <button id="searchButton" class="btn btn-primary">검색</button>
                </div>
                
                <!-- 지도 표시 영역 -->
                <div id="map"></div>
                
                <!-- 검색 결과 표시 영역 -->
                <div id="searchResults" class="mt-4">
                    <h5>검색 결과</h5>
                    <div id="resultsList" class="row"></div>
                </div>
            </div>
        </div>
        
        <!-- 인기 관광지 -->
        <div class="popular-places mt-5">
            <h3>인기 관광지</h3>
            <div class="place-cards">
                <div class="place-card">
                    <img src="https://via.placeholder.com/250x150" alt="경복궁" class="place-img">
                    <div class="place-info">
                        <div class="place-title">경복궁</div>
                        <div class="place-address">서울특별시 종로구 세종로 1-1</div>
                    </div>
                </div>
                <div class="place-card">
                    <img src="https://via.placeholder.com/250x150" alt="해운대 해수욕장" class="place-img">
                    <div class="place-info">
                        <div class="place-title">해운대 해수욕장</div>
                        <div class="place-address">부산광역시 해운대구 우동</div>
                    </div>
                </div>
                <div class="place-card">
                    <img src="https://via.placeholder.com/250x150" alt="제주 성산일출봉" class="place-img">
                    <div class="place-info">
                        <div class="place-title">성산일출봉</div>
                        <div class="place-address">제주특별자치도 서귀포시 성산읍</div>
                    </div>
                </div>
                <div class="place-card">
                    <img src="https://via.placeholder.com/250x150" alt="전주 한옥마을" class="place-img">
                    <div class="place-info">
                        <div class="place-title">전주 한옥마을</div>
                        <div class="place-address">전라북도 전주시 완산구 풍남동</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/fragments/footer.jsp"%>
</body>
<!-- SGIS API 사용을 위한 스크립트 -->
<script src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=${key_sgis_service_id}"></script>
<script src="https://sgisapi.kostat.go.kr/OpenAPI3/maps/SsohtMap.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // SGIS API를 통한 지도 초기화
    var map = new sop.map("map", {
        center: [126.9779451, 37.5662952], // 서울시청 좌표
        zoom: 7
    });
    
    // 마커 관리를 위한 배열
    map.mks = [];
    
    // 시도 목록 가져오기
    async function getSidoList() {
        try {
            const accessToken = await getAccessToken();
            const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=${accessToken}`);
            const data = await response.json();
            
            if (data.errMsg === "Success") {
                const sidoSelect = document.getElementById("sidoSelect");
                sidoSelect.innerHTML = '<option value="">시/도 선택</option>';
                
                data.result.forEach(sido => {
                    const option = document.createElement("option");
                    option.value = sido.cd;
                    option.textContent = sido.addr_name;
                    sidoSelect.appendChild(option);
                });
            } else {
                console.error("시도 목록 가져오기 실패:", data.errMsg);
            }
        } catch (error) {
            console.error("시도 목록 요청 오류:", error);
        }
    }

    // 시군구 목록 가져오기
    async function getSigunguList(sidoCd) {
        try {
            const accessToken = await getAccessToken();
            const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=${accessToken}&cd=${sidoCd}`);
            const data = await response.json();
            
            const sigunguSelect = document.getElementById("sigunguSelect");
            sigunguSelect.innerHTML = '<option value="">시/군/구 선택</option>';
            
            if (data.errMsg === "Success") {
                data.result.forEach(sigungu => {
                    const option = document.createElement("option");
                    option.value = sigungu.cd;
                    option.textContent = sigungu.addr_name;
                    sigunguSelect.appendChild(option);
                });
            } else {
                console.error("시군구 목록 가져오기 실패:", data.errMsg);
            }
        } catch (error) {
            console.error("시군구 목록 요청 오류:", error);
        }
    }

    // AccessToken 가져오기
    async function getAccessToken() {
        try {
            if (localStorage.getItem("SGIS_ACCESS_TOKEN")) {
                return localStorage.getItem("SGIS_ACCESS_TOKEN");
            }
            
            const response = await fetch("https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json", {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                },
                params: {
                    consumer_key: "${key_sgis_service_id}",
                    consumer_secret: "${key_sgis_security}"
                }
            });
            
            const json = await response.json();
            if (json.result && json.result.accessToken) {
                localStorage.setItem("SGIS_ACCESS_TOKEN", json.result.accessToken);
                return json.result.accessToken;
            } else {
                throw new Error("Access token not found in response");
            }
        } catch (error) {
            console.error("AccessToken 가져오기 오류:", error);
            return null;
        }
    }

    // 선택한 지역의 좌표 가져오기
    async function getRegionCoords(code) {
        try {
            const accessToken = await getAccessToken();
            const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/boundary/centerPoint.json?accessToken=${accessToken}&code=${code}`);
            const data = await response.json();
            
            if (data.errMsg === "Success" && data.result.length > 0) {
                return {
                    x: parseFloat(data.result[0].x),
                    y: parseFloat(data.result[0].y)
                };
            } else {
                console.error("지역 좌표 가져오기 실패:", data.errMsg);
                return null;
            }
        } catch (error) {
            console.error("지역 좌표 요청 오류:", error);
            return null;
        }
    }

    // 관광지 정보 표시 함수
    function displayTourismData(data) {
        const resultsList = document.getElementById("resultsList");
        resultsList.innerHTML = "";
        
        // 기존 마커 제거
        if (map.mks && map.mks.length > 0) {
            map.mks.forEach(marker => marker.remove());
            map.mks = [];
        }
        
        const bounds = [];
        
        data.forEach(item => {
            // 검색 결과 목록에 추가
            const resultCard = document.createElement("div");
            resultCard.className = "col-md-4 mb-3";
            resultCard.innerHTML = `
                <div class="card">
                    <img src="${item.image || 'https://via.placeholder.com/400x200'}" class="card-img-top" alt="${item.title}" style="height: 150px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title">${item.title}</h5>
                        <p class="card-text">${item.address}</p>
                        <button class="btn btn-sm btn-outline-primary view-detail" data-id="${item.id}">상세보기</button>
                        <button class="btn btn-sm btn-outline-success add-to-plan" data-id="${item.id}">여행계획에 추가</button>
                    </div>
                </div>
            `;
            resultsList.appendChild(resultCard);
            
            // 지도에 마커 추가
            if (item.x && item.y) {
                const marker = new sop.marker([item.x, item.y]);
                marker.addTo(map).bindPopup(item.title);
                map.mks.push(marker);
                bounds.push([item.x, item.y]);
            }
        });
        
        // 경계를 기준으로 map을 중앙에 위치하도록 함
        if (bounds.length > 1) {
            map.fitBounds(bounds);
        } else if (bounds.length === 1) {
            map.setView(bounds[0], 12);
        }
        
        // 버튼 이벤트 리스너 추가
        document.querySelectorAll(".view-detail").forEach(btn => {
            btn.addEventListener("click", function() {
                alert(`관광지 ID ${this.getAttribute("data-id")} 상세보기 기능은 추후 구현 예정입니다.`);
            });
        });
        
        document.querySelectorAll(".add-to-plan").forEach(btn => {
            btn.addEventListener("click", function() {
                if (!isLoggedIn()) {
                    alert("로그인 후 이용 가능합니다.");
                    return;
                }
                alert(`관광지 ID ${this.getAttribute("data-id")}를 여행계획에 추가했습니다.`);
            });
        });
    }

    // 선택한 지역의 관광지 정보 가져오기 (모의 데이터)
    async function getTourismData() {
        const sidoSelect = document.getElementById("sidoSelect");
        const sigunguSelect = document.getElementById("sigunguSelect");
        const contentTypeSelect = document.getElementById("contentTypeSelect");
        
        // 선택된 값 가져오기
        const sidoCode = sidoSelect.options[sidoSelect.selectedIndex].textContent;
        const sigunguCode = sigunguSelect.options[sigunguSelect.selectedIndex].textContent;
        const contentTypeCode = contentTypeSelect.value;
        
        if (!sidoCode || sidoCode === "시/도 선택") {
            alert("지역을 선택해주세요.");
            return;
        }
        
        // 검색 결과 목록 초기화
        document.getElementById("resultsList").innerHTML = "";
        
        try {
            // 모의 데이터 (실제로는 관광공사 API 호출)
            await new Promise(resolve => setTimeout(resolve, 500)); // API 호출 시뮬레이션
            
            const mockData = [
                {
                    id: 1,
                    title: "경복궁",
                    address: "서울특별시 종로구 세종로 1-1",
                    x: 126.976799,
                    y: 37.579617,
                    image: "https://via.placeholder.com/400x200",
                    contentType: "12"
                },
                {
                    id: 2,
                    title: "남산타워",
                    address: "서울특별시 용산구 남산공원길 105",
                    x: 126.988228,
                    y: 37.551163,
                    image: "https://via.placeholder.com/400x200",
                    contentType: "12"
                },
                {
                    id: 3,
                    title: "광장시장",
                    address: "서울특별시 종로구 종로5가 395-8",
                    x: 126.999908,
                    y: 37.570483,
                    image: "https://via.placeholder.com/400x200",
                    contentType: "39"
                }
            ];
            
            // 필터링
            const filteredData = mockData.filter(item => {
                const matchSido = item.address.includes(sidoCode);
                const matchSigungu = sigunguCode === "시/군/구 선택" || item.address.includes(sigunguCode);
                const matchContentType = !contentTypeCode || item.contentType === contentTypeCode;
                return matchSido && matchSigungu && matchContentType;
            });
            
            // 검색 결과 및 마커 표시
            displayTourismData(filteredData);
            
        } catch (error) {
            console.error("관광지 정보 가져오기 오류:", error);
        }
    }

    // 로그인 여부 확인 (임시 함수)
    function isLoggedIn() {
        // 실제로는 서버 세션 확인
        return document.querySelector(".mx-3:contains('로그아웃')") !== null;
    }

    // 이벤트 리스너 등록
    function initEventListeners() {
        // 시도 선택 시 시군구 목록 가져오기
        document.getElementById("sidoSelect").addEventListener("change", (e) => {
            if (e.target.value) {
                getSigunguList(e.target.value);
            } else {
                document.getElementById("sigunguSelect").innerHTML = '<option value="">시/군/구 선택</option>';
            }
        });
        
        // 검색 버튼 클릭 시 관광지 검색
        document.getElementById("searchButton").addEventListener("click", getTourismData);
    }

    // 초기화
    async function init() {
        await getSidoList();
        initEventListeners();
    }

    // 초기화 실행
    init();
});
</script>
</html>