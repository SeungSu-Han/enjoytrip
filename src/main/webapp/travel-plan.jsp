<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나만의 여행 계획</title>
<style>
#map {
  width: 100%;
  height: 500px;
  margin-bottom: 20px;
}
.travel-plan-container {
  display: flex;
  gap: 20px;
}
.places-list {
  width: 300px;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 15px;
  height: 500px;
  overflow-y: auto;
}
.plan-details {
  flex: 1;
}
.place-item {
  background-color: #f8f9fa;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 4px;
  cursor: grab;
}
.place-item:active {
  cursor: grabbing;
}
.timeline-container {
  margin-top: 20px;
}
.timeline {
  position: relative;
  max-width: 1200px;
  margin: 0 auto;
}
.timeline::after {
  content: '';
  position: absolute;
  width: 6px;
  background-color: #007bff;
  top: 0;
  bottom: 0;
  left: 0;
  margin-left: 18px;
}
.timeline-item {
  padding: 10px 40px;
  position: relative;
  background-color: inherit;
  margin-bottom: 15px;
}
.timeline-item::after {
  content: '';
  position: absolute;
  width: 25px;
  height: 25px;
  left: 8px;
  background-color: white;
  border: 4px solid #007bff;
  top: 10px;
  border-radius: 50%;
  z-index: 1;
}
.timeline-content {
  padding: 15px;
  background-color: white;
  position: relative;
  border-radius: 6px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}
.remove-place {
  color: #dc3545;
  cursor: pointer;
}
.search-box {
  margin-bottom: 15px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <div class="container mt-5">
        <h2>나만의 여행 계획</h2>
        
        <!-- 여행 계획 기본 정보 -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>여행 기본 정보</h5>
            </div>
            <div class="card-body">
                <form id="planBasicForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="planTitle" class="form-label">여행 제목</label>
                                <input type="text" class="form-control" id="planTitle" placeholder="여행 제목을 입력하세요">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="planDates" class="form-label">여행 기간</label>
                                <div class="d-flex">
                                    <input type="date" class="form-control" id="startDate">
                                    <span class="mx-2 d-flex align-items-center">~</span>
                                    <input type="date" class="form-control" id="endDate">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="planDescription" class="form-label">여행 설명</label>
                        <textarea class="form-control" id="planDescription" rows="3" placeholder="여행에 대한 간단한 설명을 입력하세요"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="planBudget" class="form-label">예상 경비</label>
                        <input type="number" class="form-control" id="planBudget" placeholder="예상 경비를 입력하세요">
                    </div>
                </form>
            </div>
        </div>
        
        <!-- 여행 장소 추가 및 일정 관리 -->
        <div class="card">
            <div class="card-header">
                <h5>여행 일정 관리</h5>
            </div>
            <div class="card-body">
                <div class="travel-plan-container">
                    <!-- 장소 목록 -->
                    <div class="places-list">
                        <div class="search-box">
                            <div class="input-group">
                                <input type="text" class="form-control" id="placeSearchInput" placeholder="장소 검색">
                                <button class="btn btn-primary" id="placeSearchButton">검색</button>
                            </div>
                        </div>
                        <h6>검색 결과</h6>
                        <div id="searchResultsList">
                            <!-- 검색 결과 목록이 동적으로 추가됨 -->
                        </div>
                        <hr>
                        <h6>선택한 장소</h6>
                        <div id="selectedPlacesList">
                            <!-- 선택한 장소 목록이 동적으로 추가됨 -->
                        </div>
                    </div>
                    
                    <!-- 지도 -->
                    <div class="plan-details">
                        <div id="map"></div>
                        
                        <!-- 일정 타임라인 -->
                        <div class="timeline-container">
                            <h5>여행 일정</h5>
                            <div class="timeline" id="planTimeline">
                                <!-- 일정 타임라인이 동적으로 추가됨 -->
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 저장 버튼 -->
                <div class="d-flex justify-content-end mt-4">
                    <button class="btn btn-primary" id="savePlanButton">여행 계획 저장</button>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/fragments/footer.jsp"%>
</body>
<script>
const key_vworld = `${key_vworld}`;
const key_sgis_service_id = `${key_sgis_service_id}`;
const key_sgis_security = `${key_sgis_security}`; 
const key_data = `${key_data}`;
</script>
<script src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=${key_sgis_service_id}"></script>
<script src="${root}/js/common.js"></script>

<!-- 여행 계획 관리 스크립트 -->
<script>
// 지도 초기화
const map = sop.map("map");
map.mks = []; // 마커 정보 관리

// 서울 중심 좌표로 초기화
map.setCenter(126.9779451, 37.5662952);
map.setZoom(7);

// 전역 변수
let selectedPlaces = [];
let searchResults = [];

// DOM이 로드된 후 실행
document.addEventListener("DOMContentLoaded", () => {
    // 장소 검색 버튼 이벤트
    document.getElementById("placeSearchButton").addEventListener("click", searchPlaces);
    
    // 저장 버튼 이벤트
    document.getElementById("savePlanButton").addEventListener("click", saveTravelPlan);
    
    // 드래그 앤 드롭 기능 초기화
    initDragAndDrop();
});

// 드래그 앤 드롭 기능 초기화
function initDragAndDrop() {
    // HTML5 드래그 앤 드롭 API 활용
    let draggedItem = null;
    
    document.addEventListener("dragstart", function(e) {
        if (e.target.classList.contains("place-item")) {
            draggedItem = e.target;
            e.dataTransfer.setData("text/plain", e.target.getAttribute("data-id"));
            setTimeout(() => {
                e.target.style.opacity = "0.5";
            }, 0);
        }
    });
    
    document.addEventListener("dragend", function(e) {
        if (e.target.classList.contains("place-item")) {
            e.target.style.opacity = "1";
        }
    });
    
    document.addEventListener("dragover", function(e) {
        if (e.target.classList.contains("timeline") || e.target.closest(".timeline")) {
            e.preventDefault();
        }
    });
    
    document.addEventListener("drop", function(e) {
        e.preventDefault();
        const timeline = document.getElementById("planTimeline");
        
        if (timeline.contains(e.target) || e.target === timeline) {
            const placeId = e.dataTransfer.getData("text/plain");
            const place = selectedPlaces.find(p => p.id.toString() === placeId);
            
            if (place && !document.querySelector(`.timeline-item[data-id="${placeId}"]`)) {
                addToTimeline(place);
                updateMap();
            }
        }
    });
}

// 장소 검색
async function searchPlaces() {
    const searchInput = document.getElementById("placeSearchInput").value.trim();
    if (!searchInput) {
        alert("검색어를 입력해주세요.");
        return;
    }
    
    try {
        // 실제 구현에서는 API 호출
        const results = await getMockSearchResults(searchInput);
        searchResults = results;
        
        // 검색 결과 표시
        displaySearchResults(results);
    } catch (error) {
        console.error("장소 검색 오류:", error);
    }
}

// 검색 결과 표시
function displaySearchResults(results) {
    const searchResultsList = document.getElementById("searchResultsList");
    searchResultsList.innerHTML = "";
    
    if (results.length === 0) {
        searchResultsList.innerHTML = "<p class='text-muted'>검색 결과가 없습니다.</p>";
        return;
    }
    
    results.forEach(place => {
        const placeItem = document.createElement("div");
        placeItem.className = "place-item";
        placeItem.setAttribute("draggable", "true");
        placeItem.setAttribute("data-id", place.id);
        placeItem.innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <strong>${place.title}</strong>
                    <p class="mb-0 small text-muted">${place.address}</p>
                </div>
                <button class="btn btn-sm btn-outline-primary add-place-btn">추가</button>
            </div>
        `;
        
        // 추가 버튼 이벤트 리스너
        placeItem.querySelector(".add-place-btn").addEventListener("click", () => {
            addToSelectedPlaces(place);
        });
        
        searchResultsList.appendChild(placeItem);
    });
}

// 선택한 장소 목록에 추가
function addToSelectedPlaces(place) {
    // 이미 선택된 장소인지 확인
    if (selectedPlaces.some(p => p.id === place.id)) {
        alert("이미 선택된 장소입니다.");
        return;
    }
    
    // 선택한 장소 목록에 추가
    selectedPlaces.push(place);
    
    // 선택한 장소 목록 갱신
    updateSelectedPlacesList();
    
    // 지도 업데이트
    updateMap();
}

// 선택한 장소 목록 갱신
function updateSelectedPlacesList() {
    const selectedPlacesList = document.getElementById("selectedPlacesList");
    selectedPlacesList.innerHTML = "";
    
    if (selectedPlaces.length === 0) {
        selectedPlacesList.innerHTML = "<p class='text-muted'>선택한 장소가 없습니다.</p>";
        return;
    }
    
    selectedPlaces.forEach(place => {
        const placeItem = document.createElement("div");
        placeItem.className = "place-item";
        placeItem.setAttribute("draggable", "true");
        placeItem.setAttribute("data-id", place.id);
        placeItem.innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <strong>${place.title}</strong>
                    <p class="mb-0 small text-muted">${place.address}</p>
                </div>
                <button class="btn btn-sm btn-outline-danger remove-place-btn">삭제</button>
            </div>
        `;
        
        // 삭제 버튼 이벤트 리스너
        placeItem.querySelector(".remove-place-btn").addEventListener("click", () => {
            removeFromSelectedPlaces(place.id);
        });
        
        selectedPlacesList.appendChild(placeItem);
    });
}

// 선택한 장소에서 제거
function removeFromSelectedPlaces(placeId) {
    // 타임라인에서도 제거
    const timelineItem = document.querySelector(`.timeline-item[data-id="${placeId}"]`);
    if (timelineItem) {
        timelineItem.remove();
    }
    
    // 선택한 장소 목록에서 제거
    selectedPlaces = selectedPlaces.filter(p => p.id !== placeId);
    
    // 선택한 장소 목록 갱신
    updateSelectedPlacesList();
    
    // 지도 업데이트
    updateMap();
}

// 타임라인에 추가
function addToTimeline(place) {
    const planTimeline = document.getElementById("planTimeline");
    
    const timelineItem = document.createElement("div");
    timelineItem.className = "timeline-item";
    timelineItem.setAttribute("data-id", place.id);
    
    timelineItem.innerHTML = `
        <div class="timeline-content">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h6>${place.title}</h6>
                <div>
                    <button class="btn btn-sm btn-outline-danger remove-timeline-btn">삭제</button>
                </div>
            </div>
            <p class="small text-muted">${place.address}</p>
            <div class="form-group mt-2">
                <label class="form-label small">메모</label>
                <textarea class="form-control form-control-sm place-memo" rows="2"></textarea>
            </div>
        </div>
    `;
    
    // 삭제 버튼 이벤트 리스너
    timelineItem.querySelector(".remove-timeline-btn").addEventListener("click", () => {
        timelineItem.remove();
        updateMap();
    });
    
    planTimeline.appendChild(timelineItem);
}

// 지도 업데이트
function updateMap() {
    // 기존 마커 제거
    if (map.mks.length > 0) {
        map.mks.forEach(marker => marker.remove());
        map.mks = [];
    }
    
    // 타임라인에 있는 장소들만 마커로 표시
    const timelineItems = document.querySelectorAll(".timeline-item");
    const bounds = [];
    
    timelineItems.forEach(item => {
        const placeId = parseInt(item.getAttribute("data-id"));
        const place = selectedPlaces.find(p => p.id === placeId);
        
        if (place && place.x && place.y) {
            // 마커 추가
            const marker = sop.marker([place.x, place.y]);
            marker.addTo(map).bindInfoWindow(place.title);
            map.mks.push(marker);
            bounds.push([place.x, place.y]);
        }
    });
    
    // 경로 선 그리기
    if (bounds.length > 1) {
        const polyline = sop.polyline(bounds, { color: '#3388ff', weight: 3 });
        polyline.addTo(map);
        map.mks.push(polyline);
        
        // 지도 중심 및 줌 레벨 조정
        map.setView(map._getBoundsCenterZoom(bounds).center, map._getBoundsCenterZoom(bounds).zoom);
    } else if (bounds.length === 1) {
        map.setView(bounds[0], 12);
    }
}

// 여행 계획 저장
async function saveTravelPlan() {
    // 기본 정보 가져오기
    const title = document.getElementById("planTitle").value.trim();
    const startDate = document.getElementById("startDate").value;
    const endDate = document.getElementById("endDate").value;
    const description = document.getElementById("planDescription").value.trim();
    const budget = document.getElementById("planBudget").value;
    
    // 유효성 검사
    if (!title) {
        alert("여행 제목을 입력해주세요.");
        return;
    }
    
    if (!startDate || !endDate) {
        alert("여행 기간을 설정해주세요.");
        return;
    }
    
    // 타임라인에 있는 장소 정보 가져오기
    const timelineItems = document.querySelectorAll(".timeline-item");
    if (timelineItems.length === 0) {
        alert("최소 1개 이상의 여행 장소를 추가해주세요.");
        return;
    }
    
    // 여행 계획 객체 생성
    const travelPlan = {
        title,
        startDate,
        endDate,
        description,
        budget,
        places: []
    };
    
    // 타임라인 장소 정보 추가
    timelineItems.forEach((item, index) => {
        const placeId = parseInt(item.getAttribute("data-id"));
        const place = selectedPlaces.find(p => p.id === placeId);
        const memo = item.querySelector(".place-memo").value;
        
        if (place) {
            travelPlan.places.push({
                id: place.id,
                title: place.title,
                address: place.address,
                x: place.x,
                y: place.y,
                order: index + 1,
                memo: memo
            });
        }
    });
    
    try {
        // 서버에 여행 계획 저장 (실제 구현에서는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "save-travel-plan",
        //         planData: JSON.stringify(travelPlan)
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("저장할 여행 계획:", travelPlan);
        alert("여행 계획이 저장되었습니다!");
        
        // 여행 계획 목록 페이지로 이동
        // window.location.href = "${root}/auth?action=travel-plan-list";
    } catch (error) {
        console.error("여행 계획 저장 오류:", error);
        alert("여행 계획 저장 중 오류가 발생했습니다.");
    }
}

// 모의 장소 검색 결과 (실제로는 서버 API 호출)
async function getMockSearchResults(keyword) {
    // API 호출 시뮬레이션
    await new Promise(resolve => setTimeout(resolve, 500));
    
    const mockPlaces = [
        {
            id: 1,
            title: "경복궁",
            address: "서울특별시 종로구 세종로 1-1",
            x: 126.976799,
            y: 37.579617
        },
        {
            id: 2,
            title: "남산타워",
            address: "서울특별시 용산구 남산공원길 105",
            x: 126.988228,
            y: 37.551163
        },
        {
            id: 3,
            title: "광장시장",
            address: "서울특별시 종로구 종로5가 395-8",
            x: 126.999908,
            y: 37.570483
        },
        {
            id: 4,
            title: "롯데호텔 서울",
            address: "서울특별시 중구 을지로 30",
            x: 126.981346,
            y: 37.565739
        },
        {
            id: 5,
            title: "코엑스",
            address: "서울특별시 강남구 영동대로 513",
            x: 127.058908,
            y: 37.511684
        },
        {
            id: 6,
            title: "해운대 해수욕장",
            address: "부산광역시 해운대구 우동",
            x: 129.158867,
            y: 35.158905
        },
        {
            id: 7,
            title: "제주 성산일출봉",
            address: "제주특별자치도 서귀포시 성산읍",
            x: 126.940536,
            y: 33.459293
        },
        {
            id: 8,
            title: "전주 한옥마을",
            address: "전라북도 전주시 완산구 풍남동",
            x: 127.153849,
            y: 35.815464
        }
    ];
    
    // 키워드로 필터링
    return mockPlaces.filter(place => 
        place.title.includes(keyword) || place.address.includes(keyword)
    );
}