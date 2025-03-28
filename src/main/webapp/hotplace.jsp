<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나만의 핫플레이스</title>
<style>
#map {
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}
.hotplace-gallery {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-top: 30px;
}
.hotplace-card {
  width: 300px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}
.hotplace-card:hover {
  transform: translateY(-5px);
}
.hotplace-img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}
.hotplace-info {
  padding: 15px;
}
.hotplace-title {
  font-weight: bold;
  margin-bottom: 5px;
}
.hotplace-address {
  color: #666;
  font-size: 0.9em;
  margin-bottom: 10px;
}
.hotplace-description {
  color: #333;
  font-size: 0.95em;
}
.hotplace-meta {
  display: flex;
  justify-content: space-between;
  margin-top: 10px;
  color: #666;
  font-size: 0.85em;
}
.image-preview {
  max-width: 100%;
  max-height: 200px;
  margin-top: 10px;
  border-radius: 4px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <div class="container mt-5">
        <h2>나만의 핫플레이스</h2>
        
        <!-- 핫플레이스 등록 폼 -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>새로운 핫플레이스 등록</h5>
            </div>
            <div class="card-body">
                <form id="hotplaceForm">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="hotplaceTitle" class="form-label">장소명</label>
                            <input type="text" class="form-control" id="hotplaceTitle" name="title" required>
                        </div>
                        <div class="col-md-6">
                            <label for="visitDate" class="form-label">방문일자</label>
                            <input type="date" class="form-control" id="visitDate" name="visitDate" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="hotplaceAddress" class="form-label">주소</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="hotplaceAddress" name="address" readonly required>
                            <button type="button" class="btn btn-outline-secondary" id="searchAddressBtn">검색</button>
                        </div>
                        <input type="hidden" id="coordX" name="x">
                        <input type="hidden" id="coordY" name="y">
                    </div>
                    
                    <div class="mb-3">
                        <label for="placeType" class="form-label">장소 유형</label>
                        <select class="form-select" id="placeType" name="placeType" required>
                            <option value="">-- 장소 유형 선택 --</option>
                            <option value="restaurant">음식점</option>
                            <option value="cafe">카페</option>
                            <option value="attraction">관광지</option>
                            <option value="accommodation">숙소</option>
                            <option value="shopping">쇼핑</option>
                            <option value="other">기타</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">상세 설명</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="imageUpload" class="form-label">사진 업로드</label>
                        <input type="file" class="form-control" id="imageUpload" name="image" accept="image/*">
                        <div id="imagePreview"></div>
                    </div>
                    
                    <!-- 지도 위치 표시 영역 -->
                    <div id="map"></div>
                    
                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary" id="submitHotplace">등록하기</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- 핫플레이스 목록 -->
        <div class="card">
            <div class="card-header">
                <h5>인기 핫플레이스</h5>
            </div>
            <div class="card-body">
                <div class="hotplace-gallery" id="hotplaceGallery">
                    <!-- 핫플레이스 목록이 동적으로 추가됨 -->
                </div>
            </div>
        </div>
    </div>
    
    <!-- 주소 검색 모달 -->
    <div class="modal fade" id="addressSearchModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">주소 검색</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" id="addressSearchInput" placeholder="검색할 주소 입력">
                        <button class="btn btn-primary" type="button" id="addressSearchButton">검색</button>
                    </div>
                    <div id="addressSearchResults">
                        <!-- 검색 결과 목록이 동적으로 추가됨 -->
                    </div>
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

<!-- 핫플레이스 관리 스크립트 -->
<script>
// 지도 초기화
const map = sop.map("map");
map.mks = []; // 마커 정보 관리
let currentMarker = null; // 현재 선택한 위치의 마커

// 서울 중심 좌표로 초기화
map.setCenter(126.9779451, 37.5662952);
map.setZoom(7);

// 모달 초기화
const addressModal = new bootstrap.Modal(document.getElementById('addressSearchModal'));

// DOM이 로드된 후 실행
document.addEventListener("DOMContentLoaded", () => {
    // 주소 검색 버튼 이벤트
    document.getElementById("searchAddressBtn").addEventListener("click", () => {
        addressModal.show();
    });
    
    // 주소 검색 실행 버튼 이벤트
    document.getElementById("addressSearchButton").addEventListener("click", searchAddress);
    
    // 이미지 업로드 미리보기
    document.getElementById("imageUpload").addEventListener("change", function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById("imagePreview");
                preview.innerHTML = `<img src="${e.target.result}" class="image-preview">`;
            };
            reader.readAsDataURL(file);
        }
    });
    
    // 지도 클릭 이벤트
    map.on("click", function(e) {
        setLocation(e.latlng.lng, e.latlng.lat);
    });
    
    // 핫플레이스 등록 버튼 이벤트
    document.getElementById("submitHotplace").addEventListener("click", submitHotplace);
    
    // 초기 핫플레이스 목록 로드
    loadHotplaces();
});

// 주소 검색
async function searchAddress() {
    const searchInput = document.getElementById("addressSearchInput").value.trim();
    if (!searchInput) {
        alert("검색할 주소를 입력해주세요.");
        return;
    }
    
    try {
        // 주소 검색 API 호출
        const coord = await getCoords(searchInput);
        
        // 검색 결과 표시
        const searchResults = document.getElementById("addressSearchResults");
        searchResults.innerHTML = "";
        
        if (coord.errMsg && coord.errMsg !== "Success") {
            searchResults.innerHTML = `<div class="alert alert-warning">${coord.errMsg}</div>`;
            return;
        }
        
        // 주소 결과 표시
        const addressItem = document.createElement("div");
        addressItem.className = "list-group-item list-group-item-action";
        addressItem.innerHTML = `
            <div class="d-flex justify-content-between">
                <div>
                    <strong>${searchInput}</strong>
                </div>
                <button class="btn btn-sm btn-outline-primary select-address-btn">선택</button>
            </div>
        `;
        
        // 주소 선택 버튼 이벤트
        addressItem.querySelector(".select-address-btn").addEventListener("click", () => {
            setLocation(coord.x, coord.y);
            document.getElementById("hotplaceAddress").value = searchInput;
            addressModal.hide();
        });
        
        searchResults.appendChild(addressItem);
    } catch (error) {
        console.error("주소 검색 오류:", error);
    }
}

// 위치 설정
function setLocation(x, y) {
    // 기존 마커 제거
    if (currentMarker) {
        currentMarker.remove();
    }
    
    // 새 마커 추가
    currentMarker = sop.marker([x, y]);
    currentMarker.addTo(map);
    
    // 좌표 저장
    document.getElementById("coordX").value = x;
    document.getElementById("coordY").value = y;
    
    // 지도 중심 이동
    map.setView([x, y], 15);
}

// 핫플레이스 등록
async function submitHotplace() {
    // 폼 데이터 가져오기
    const title = document.getElementById("hotplaceTitle").value.trim();
    const visitDate = document.getElementById("visitDate").value;
    const address = document.getElementById("hotplaceAddress").value.trim();
    const placeType = document.getElementById("placeType").value;
    const description = document.getElementById("description").value.trim();
    const x = document.getElementById("coordX").value;
    const y = document.getElementById("coordY").value;
    const imageFile = document.getElementById("imageUpload").files[0];
    
    // 유효성 검사
    if (!title || !visitDate || !address || !placeType || !description || !x || !y) {
        alert("모든 필수 항목을 입력해주세요.");
        return;
    }
    
    try {
        // 폼 데이터 생성
        const formData = new FormData();
        formData.append("action", "hotplace-insert");
        formData.append("title", title);
        formData.append("visitDate", visitDate);
        formData.append("address", address);
        formData.append("placeType", placeType);
        formData.append("description", description);
        formData.append("x", x);
        formData.append("y", y);
        
        if (imageFile) {
            formData.append("image", imageFile);
        }
        
        // 서버에 전송 (실제 구현에서는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     body: formData
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("등록할 핫플레이스:", {
            title, visitDate, address, placeType, description, x, y
        });
        
        alert("핫플레이스가 등록되었습니다!");
        
        // 폼 초기화
        document.getElementById("hotplaceForm").reset();
        document.getElementById("imagePreview").innerHTML = "";
        if (currentMarker) {
            currentMarker.remove();
            currentMarker = null;
        }
        
        // 핫플레이스 목록 다시 로드
        loadHotplaces();
    } catch (error) {
        console.error("핫플레이스 등록 오류:", error);
        alert("핫플레이스 등록 중 오류가 발생했습니다.");
    }
}

// 핫플레이스 목록 로드
async function loadHotplaces() {
    try {
        // 서버에서 핫플레이스 목록 가져오기 (실제 구현에서는 서버에 GET 요청)
        // const response = await fetch("/auth?action=hotplace-list");
        // const data = await response.json();
        
        // 임시 데이터 (모의 데이터)
        const mockHotplaces = [
            {
                id: 1,
                title: "서울숲 산책로",
                address: "서울특별시 성동구 성수동1가 685-6",
                description: "도심 속 자연을 느낄 수 있는 멋진 공원입니다. 주말에 가족과 함께 방문했는데 공기도 좋고 산책하기 좋았어요.",
                placeType: "attraction",
                visitDate: "2025-03-15",
                x: 127.0374,
                y: 37.5444,
                image: "/api/placeholder/300/200",
                writerName: "홍길동"
            },
            {
                id: 2,
                title: "을지로 미진식당",
                address: "서울특별시 중구 을지로 119",
                description: "을지로 맛집! 김치찌개가 정말 맛있어요. 점심시간에는 사람이 많으니 일찍 가는 것을 추천합니다.",
                placeType: "restaurant",
                visitDate: "2025-03-10",
                x: 126.9918,
                y: 37.5664,
                image: "/api/placeholder/300/200",
                writerName: "김철수"
            },
            {
                id: 3,
                title: "연남동 경의선 숲길",
                address: "서울특별시 마포구 연남동",
                description: "연트럴파크라고 불리는 이곳은 산책하기 너무 좋은 곳이에요. 카페와 맛집도 많아서 데이트 코스로 강추합니다!",
                placeType: "attraction",
                visitDate: "2025-03-05",
                x: 126.9237,
                y: 37.5603,
                image: "/api/placeholder/300/200",
                writerName: "이영희"
            }
        ];
        
        // 핫플레이스 목록 표시
        displayHotplaces(mockHotplaces);
    } catch (error) {
        console.error("핫플레이스 목록 로드 오류:", error);
    }
}

// 핫플레이스 목록 표시
function displayHotplaces(hotplaces) {
    const gallery = document.getElementById("hotplaceGallery");
    gallery.innerHTML = "";
    
    if (hotplaces.length === 0) {
        gallery.innerHTML = "<p class='text-muted'>등록된 핫플레이스가 없습니다.</p>";
        return;
    }
    
    hotplaces.forEach(place => {
        const placeCard = document.createElement("div");
        placeCard.className = "hotplace-card";
        placeCard.innerHTML = `
            <img src="${place.image || '/api/placeholder/300/200'}" class="hotplace-img" alt="${place.title}">
            <div class="hotplace-info">
                <h5 class="hotplace-title">${place.title}</h5>
                <p class="hotplace-address">${place.address}</p>
                <p class="hotplace-description">${place.description}</p>
                <div class="hotplace-meta">
                    <span>유형: ${getPlaceTypeName(place.placeType)}</span>
                    <span>방문일: ${formatDate(place.visitDate)}</span>
                </div>
                <div class="hotplace-meta mt-1">
                    <span>작성자: ${place.writerName}</span>
                    <button class="btn btn-sm btn-outline-primary view-on-map" data-x="${place.x}" data-y="${place.y}">지도에서 보기</button>
                </div>
            </div>
        `;
        
        // 지도에서 보기 버튼 이벤트 리스너
        placeCard.querySelector(".view-on-map").addEventListener("click", function() {
            const x = this.getAttribute("data-x");
            const y = this.getAttribute("data-y");
            
            // 지도 중심 이동
            map.setView([x, y], 15);
            
            // 마커 표시
            if (currentMarker) {
                currentMarker.remove();
            }
            currentMarker = sop.marker([x, y]);
            currentMarker.addTo(map).bindInfoWindow(place.title);
            
            // 지도 영역으로 스크롤
            document.getElementById("map").scrollIntoView({ behavior: "smooth" });
        });
        
        gallery.appendChild(placeCard);
    });
}

// 장소 유형명 반환
function getPlaceTypeName(placeType) {
    const typeMap = {
        'restaurant': '음식점',
        'cafe': '카페',
        'attraction': '관광지',
        'accommodation': '숙소',
        'shopping': '쇼핑',
        'other': '기타'
    };
    return typeMap[placeType] || placeType;
}

// 날짜 포맷팅
function formatDate(dateStr) {
    const date = new Date(dateStr);
    return date.toLocaleDateString('ko-KR', { year: 'numeric', month: 'long', day: 'numeric' });
}
</script>
</html>