<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    <div class="container mt-4">
        <!-- 지도 표시 영역 -->
        <div class="card mt-4">
            <div class="card-header">
                <h4>지역 지도</h4>
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
                    <select id="dongSelect" class="form-select">
                        <option value="">읍/면/동 선택</option>
                    </select>
                    <button id="moveToRegion" class="btn btn-primary">이동</button>
                </div>
                
                <!-- 지도 표시 영역 -->
                <div id="map"></div>
            </div>
        </div>
    </div>
    <%@ include file="/fragments/footer.jsp"%>
</body>
<script>
const key_vworld = `${key_vworld}`;
const key_sgis_service_id = `${key_sgis_service_id}`;
const key_sgis_security = `${key_sgis_security}`; // 보안 key
const key_data = `${key_data}`;
</script>
<script src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=${key_sgis_service_id }"></script>
<script src="${root }/js/common.js"></script>

<!-- 지도 초기화 및 지역 선택 기능 구현 -->
<script>
// 지도 초기화
const map = sop.map("map");

// 서울 시청 좌표 (초기 중심점)
const initialCenter = {
    x: 126.9779451,
    y: 37.5662952
};

// 지도 중심 설정 및 줌 레벨 설정
map.setCenter(initialCenter.x, initialCenter.y);
map.setZoom(8);

// 시도 목록 가져오기
const getSidoList = async () => {
    try {
        // SGIS API 사용하여 시도 목록 가져오기
        const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=${window.sop.accessToken}`);
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
};

// 시군구 목록 가져오기
const getSigunguList = async (sidoCd) => {
    try {
        // SGIS API 사용하여 시군구 목록 가져오기
        const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=${window.sop.accessToken}&cd=${sidoCd}`);
        const data = await response.json();
        
        const sigunguSelect = document.getElementById("sigunguSelect");
        sigunguSelect.innerHTML = '<option value="">시/군/구 선택</option>';
        document.getElementById("dongSelect").innerHTML = '<option value="">읍/면/동 선택</option>';
        
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
};

// 읍면동 목록 가져오기
const getDongList = async (sigunguCd) => {
    try {
        // SGIS API 사용하여 읍면동 목록 가져오기
        const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=${window.sop.accessToken}&cd=${sigunguCd}`);
        const data = await response.json();
        
        const dongSelect = document.getElementById("dongSelect");
        dongSelect.innerHTML = '<option value="">읍/면/동 선택</option>';
        
        if (data.errMsg === "Success") {
            data.result.forEach(dong => {
                const option = document.createElement("option");
                option.value = dong.cd;
                option.textContent = dong.addr_name;
                dongSelect.appendChild(option);
            });
        } else {
            console.error("읍면동 목록 가져오기 실패:", data.errMsg);
        }
    } catch (error) {
        console.error("읍면동 목록 요청 오류:", error);
    }
};

// 선택한 지역의 좌표 가져오기
const getRegionCoords = async (code) => {
    try {
        // SGIS API를 사용하여 선택한 지역의 좌표 가져오기
        const response = await fetch(`https://sgisapi.kostat.go.kr/OpenAPI3/boundary/centerPoint.json?accessToken=${window.sop.accessToken}&code=${code}`);
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
};

// 지도 이동 함수
const moveMapToRegion = async () => {
    const sidoSelect = document.getElementById("sidoSelect");
    const sigunguSelect = document.getElementById("sigunguSelect");
    const dongSelect = document.getElementById("dongSelect");
    
    // 선택된 가장 하위 단위의 코드 가져오기
    let selectedCode = '';
    if (dongSelect.value) {
        selectedCode = dongSelect.value;
    } else if (sigunguSelect.value) {
        selectedCode = sigunguSelect.value;
    } else if (sidoSelect.value) {
        selectedCode = sidoSelect.value;
    } else {
        alert("지역을 선택해주세요.");
        return;
    }
    
    // 지역 좌표 가져오기
    const coords = await getRegionCoords(selectedCode);
    if (coords) {
        // 지도 이동 및 줌 레벨 조정
        map.setCenter(coords.x, coords.y);
        
        // 줌 레벨 설정 (읍면동 > 시군구 > 시도 순으로 점점 더 확대)
        if (dongSelect.value) {
            map.setZoom(12); // 읍면동 레벨
        } else if (sigunguSelect.value) {
            map.setZoom(10); // 시군구 레벨
        } else {
            map.setZoom(8);  // 시도 레벨
        }
    }
};

// 이벤트 리스너 등록
document.addEventListener("DOMContentLoaded", () => {
    // 시도 목록 초기 로드
    getSidoList();
    
    // 시도 선택 시 시군구 목록 가져오기
    document.getElementById("sidoSelect").addEventListener("change", (e) => {
        if (e.target.value) {
            getSigunguList(e.target.value);
        } else {
            document.getElementById("sigunguSelect").innerHTML = '<option value="">시/군/구 선택</option>';
            document.getElementById("dongSelect").innerHTML = '<option value="">읍/면/동 선택</option>';
        }
    });
    
    // 시군구 선택 시 읍면동 목록 가져오기
    document.getElementById("sigunguSelect").addEventListener("change", (e) => {
        if (e.target.value) {
            getDongList(e.target.value);
        } else {
            document.getElementById("dongSelect").innerHTML = '<option value="">읍/면/동 선택</option>';
        }
    });
    
    // 이동 버튼 클릭 시 지도 이동
    document.getElementById("moveToRegion").addEventListener("click", moveMapToRegion);
});
</script>
</html>