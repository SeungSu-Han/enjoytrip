<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    <a href="${root }/main?action=gugu-form" class="mx-3">구구단</a>
    <hr>
    <a href="${root }/main?action=make-cookie" class="mx-3">쿠키만들기</a>
    <a href="${root }/main?action=check-cookie" class="mx-3">쿠키확인하기</a>
    <hr>
    <a href="${root }/main?action=cart-form" class="mx-3">쇼핑</a>
    <hr>
    <a href="${root }/main?action=not-exist-action" class="mx-3">404 1</a>
    <a href="${root }/not-exist-path" class="mx-3">404 2</a>
    <a href="${root }/main?action=member-problem" class="mx-3">문제링크</a>
    <%@ include file="/fragments/footer.jsp"%>
</body>
</html>
