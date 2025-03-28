<!-- /fragments/header.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 페이지들이 가져갈 공통적인 내용들 위치 --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
header>#logo {
 width: 90px;
 margin-bottom: 8px;
 margin-left: 10px;
}

header>h1 {
 line-height: 50px;
 display: inline-block;
 height: 50px;
}
</style>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="root" value="${pageContext.servletContext.contextPath }" />
<div class="container">
    <!-- 전체 .container 시작 -->
    <header class="d-flex justify-content-center my-5 align-items-center">
        <h1 class='text-center'>Welcome To</h1>
        <img src="${root }/img/ssafy_logo.png" id="logo" />
    </header>
    <div class="d-flex justify-content-end">
        <a href="${root }/main" class="mx-3">홈으로</a> |
        <a href="${root }/auth?action=member-list&currentPage=1" class="mx-3">멤버목록</a> |

        <c:if test="${empty loginUser }">
            <a href="${root }/member?action=login-form" class="mx-3">로그인</a> |
            <a href="${root }/member?action=regist-member-form" class="mx-3">회원가입</a>
        </c:if>
        <c:if test="${!empty loginUser }">
            <a href="${root }/auth?action=member-detail&email=${loginUser.email}" class="mx-3">${loginUser.name }</a> |
            <a href="${root }/member?action=logout" class="mx-3">로그아웃</a>
        </c:if>
    </div>
    <hr />
    <script type="text/javascript">
                    const alertMsg = `${param.alertMsg}` || `${alertMsg}`; // 메시지 자체에 ""가 포함 되기도 함
                    console.log(alertMsg)
                    if (alertMsg) {
                        alert(alertMsg);
                    }
                    /*   
                     html에서 작성하고 주석 처리 해 두는게 오히려 가독성이 좋을 수도. 
                     <c:remove var="alertMsg" scope="session"/>  
                     */
                </script>
