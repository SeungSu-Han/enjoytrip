<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>

</head>
<body>
    <%@ include file="/fragments/header.jsp"%>

    <h1>회원가입</h1>
    <form action="${root}/member" method="post" class="m-3">
        <input type="hidden" name="action" value="regist-member" />

        <div class="mb-3 row">
            <label for="name" class="col-sm-2 col-form-label">이름</label>
            <div class="col-sm-10">
                <input type="text" name="name" id="name" class="form-control" required />
            </div>
        </div>

        <div class="mb-3 row">
            <label for="email" class="col-sm-2 col-form-label">이메일</label>
            <div class="col-sm-10">
                <input type="email" name="email" id="email" class="form-control" required />
                <!-- TODO: 01-01. 오류 정보를 표시하기 위한 div를 선언해보자. -->
                <div class="invalid-feedback">
                   이미 사용중인 email입니다.
                </div>
            </div>
        </div>

        <div class="mb-3 row">
            <label for="password" class="col-sm-2 col-form-label">비밀번호</label>
            <div class="col-sm-10">
                <input type="password" name="password" id="password" class="form-control" required />
            </div>
        </div>

        <button type="submit" class="btn btn-primary">등록</button>
    </form>

    <c:if test="${!empty error }">
        <div class="alert alert-danger" role="alert">${error }</div>
    </c:if>

    <%@ include file="/fragments/footer.jsp"%>
</body>
<script src="${root }/js/common.js"></script>
<!-- TODO: 01-02. #email에서 input event 발생 시 중복 여부를 확인하세요. -->
<script>
    document.querySelector("#email").addEventListener("input", async (e)=>{   
        const target = e.target;
        // /member?action=checkEmail을 이용하며 email을 전송한다.
        const json = await getFetch("${root}/member",{action:"checkEmail",  email:target.value});
        // 상태를 표시하기 위해 bootstrap의 is-invalid, is-valid class를 사용한다.
        if(!json.canUse){    
            target.classList.add("is-invalid");
            target.classList.remove("is-valid");
        }else{
            target.classList.remove("is-invalid");
               target.classList.add("is-valid");
        }
    })
</script>
</html>
