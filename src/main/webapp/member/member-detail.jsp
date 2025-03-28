<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#profile {
 max-width: 150px;
}

th:nth-child(1) {
 width: 80px;
}

th:nth-child(2) {
 width: 50%;
}

th:nth-child(3) {
 
}

th:nth-child(4) {
 width: 75px;
}

input[type='text'] {
 width: 100%;
}

#map {
 display: none;
 width: 100%;
 height: 300px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-5">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4>회원 정보</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p>
                                    <strong>회원번호:</strong> ${member.mno}
                                </p>
                                <p>
                                    <strong>이름:</strong> ${member.name}
                                </p>
                                <p>
                                    <strong>이메일:</strong> ${member.email}
                                </p>
                                <p>
                                    <strong>권한:</strong> ${member.role}
                                </p>
                            </div>

                            <!-- 이미지 표시 -->
                            <div class="mt-3 col-md-6 text-center">
                                <p class="mt-2">
                                    <strong>프로필 이미지</strong>
                                </p>
                            </div>
                        </div>
                        <!-- TODO: 05-01. 회원의 정보가 로그인한 사용자거나 admin role일 경우 수정, 삭제 버튼을 표현해보자. -->
                        <c:if test="${loginUser.email.equals(member.email) || loginUser.role.equalsIgnoreCase('admin')}">
                            <div class="d-flex mt-5 justify-content-center">
                                <form method="post" action="${root}/auth" id="form-delete">
                                    <input type="hidden" name="action" value="member-delete">
                                    <input type="hidden" name="mno" value="${member.mno}">
                                    <input type="hidden" name="email" value="${member.email }">
                                    <button type="button" class="btn btn-primary mx-3" onclick="updateMember()">수정</button>
                                    <button type="submit" class="btn btn-danger  mx-3" onclick="deleteMember()">삭제</button>
                                </form>
                            </div>
                        </c:if>

                        <!-- END -->
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card">

                    <div class="card-header">
                        <h4>여행 계획</h4>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered" id="table-user-address">
                            <thead>
                                <tr>
                                    <th>여행 순서</th>
                                    <th>주소</th>
                                    <th>상세 주소</th>
                                    <th>편집</th>
                                </tr>
                            </thead>
                            <tbody id="address-body">

                            </tbody>
                        </table>
                        <div id="map"></div>
                        <hr>
                        <!-- TODO: 03-01. 주소 추가를 위한 form을 확인하세요. -->
                        <form id="formAddressAdd">
                            <fieldset class="row g-3">
                                <input type="hidden" name="action" value="address-insert">
                                <!-- address 등록용 -->
                                <input type="hidden" name="mno" value="${member.mno}">
                                <!-- member detail 조회용 -->
                                <input type="hidden" name="email" value="${member.email}">
                                <input type="hidden" name="x" id="addr_x">
                                <input type="hidden" name="y" id="addr_y">
                                <div class="col-md-2">
                                    <label for="addr_title" class="form-label">제목</label>
                                    <input type="text" class="form-control" id="addr_title" name="addr_title" required
                                        value="테스트">
                                </div>
                                <div class="col-md-5">
                                    <label for="addr_main" class="form-label">주소</label>
                                    <input type="text" class="form-control" id="addr_main" name="addr_main" required
                                        value="서울특별시 강남구 역삼동">
                                </div>
                                <div class="col-md-5">
                                    <label for="addr_detail" class="form-label">상세주소</label>
                                    <input type="text" class="form-control" id="addr_detail" name="addr_detail" required
                                        value="멀티캠퍼스">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="button" class="btn btn-primary" data-mno="${member.mno }"
                                        id="btn-address-add">추가</button>
                                </div>
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${!empty error }">
        <div class="alert alert-danger" role="alert">${error }</div>
    </c:if>
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

<!-- TODO: 02-02. member의 address 정보를 지도에 표시한다. -->
<script>
const map = sop.map("map");
map.mks = []; // marker 정보 관리
const addrInfos = []; // 지도 정보를 저장할 배열
<c:forEach var="addr" items="${member.addresses}">
// 테이블에서 사용되는 정보:  addr.ano, addr.address, addr.detailAddress, addr.title
// map에서 사용되는 정보: addr.title, addr.x, addr.y
addrInfos.push({ano:"${addr.ano}",                     
                address:"${addr.address}",
                detailAddress:"${addr.detailAddress}",
                title:"${addr.title}",               
                x:"${addr.x}", y:"${addr.y}"}
);
</c:forEach>

const showAddress = (addrInfos)=>{
    const target = document.querySelector("#address-body");
    target.innerHTML = "";
    if(addrInfos.length>0){
        document.querySelector("#map").style.display="block";
        addrInfos.forEach(item =>{
            target.innerHTML+=`
                <tr>
                  <td>\${item.title}</td>
                  <td>\${item.address}</td>
                  <td>\${item.detailAddress}</td>
                  <td><button class="btn btn-danger" data-ano="\${item.ano}" onclick="deleteAddress(event)">삭제</button></td>
                </tr>
            `;
        })
        updateMap(map, addrInfos);
    }else{
        document.querySelector("#map").style.display="none";
    }
}
showAddress(addrInfos);
</script>


<!-- TODO: 03-02. 주소 추가 클릭시 동작을 처리하세요.-->
<!-- 입력된 주소를 이용해 좌표를 가져온 후 등록 처리한다. -->
<script>
document.querySelector("#btn-address-add").addEventListener("click", async (e)=>{
    try{
        // 주소를 이용한 좌표 조회 및 form update
        const address = document.querySelector('#addr_main').value+" "+document.querySelector("#addr_detail").value;
        const coord = await getCoords(address);
        if(coord.x){ // 좌표가 전송된 경우만 submit 처리
            document.querySelector("#addr_x").value = coord.x;
            document.querySelector("#addr_y").value = coord.y;
        }else{
            alert(coord.errMsg);
            return;
        }
        // form 정보를 이용해 parameter 생성
        const formData = new FormData(document.querySelector("#formAddressAdd"));
        const searchParam = new URLSearchParams(formData).toString();
        // 등록 요청 -> 전체 주소 획득
        const result = await postFetch("${root }/auth", searchParam);
        if(result.error){
            alert(result.error);
        }else{
            // 화면 update
            showAddress(result);
        }
        console.log(formData);
    }catch(e){
        console.log(e)
    }
});
</script>

<!-- END-->

<!-- TODO: 04. 주소 삭제 클릭시 confirm 후 주소 삭제요청한다. 결과를 이용해 다시 화면을 구성한다..-->
<script>
const deleteAddress = async (e)=>{
 if(confirm("삭제하시겠습니까?")){
     const params ={
           ano:e.target.dataset.ano,
           email:"${member.email}",
           action:"address-delete"
     }
     
     const result = await postFetch("${root}/auth", new URLSearchParams(params).toString());
     if(result.error){
         alert(result.error);
     }else{
         showAddress(result);
     }
 }
} 
</script>

<!--END-->


<!-- TODO: 05-02. #btnModify 클릭시 동작을 처리하세요.-->
<script>
const updateMember = ()=>{
    location.href="${root}/auth?action=member-modify-form&email=${member.email}"
};
</script>

<!-- TODO: 06-03. #form-delete 제출시 동작을 처리하세요.-->
<!--  의도를 다시 한번 확인하고 맞다면 제출-->
<script>
document.querySelector("#form-delete").addEventListener("submit", (e) => {
	const result = confirm("삭제하시겠습니까?");
	if(result){
		console.log("delete");
	} else {
		e.preventDefault();
		console.log("cancelled")
	}
});
</script>
<!-- END -->
</html>
