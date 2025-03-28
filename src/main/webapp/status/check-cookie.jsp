<%@ page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    <div>
        <h1>개별 쿠키 확인(el의 쿠키 내장 객체 활용)</h1>
        for-domain: ${cookie["for-domain"].value }
    </div>
    <br />
    <h1>cookie 목록</h1>
    <ul>
        <c:forEach var="c" items="${pageContext.request.cookies}">
            <li>이름: ${c.name}, 값: ${URLDecoder.decode(c.value, "UTF-8")}</li>
        </c:forEach>
    </ul>
    <%@ include file="/fragments/footer.jsp"%>
</body>
</html>
