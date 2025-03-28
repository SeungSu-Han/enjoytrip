<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    <h1>${param.dan }단 결과</h1>
    <table>
        <tbody>
        <c:forEach items="${result }" var="item">
        <tr>
            <td>${item.key }</td>
            <td>${item.value }</td>
        </tr>
        </c:forEach>
        </tbody>
    </table>
    <br>
    <a href="${root }/main?action=gugu-form">다시하기</a>
    <%@ include file="/fragments/footer.jsp"%>
</body>
</html>
