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
        <h2>사고 싶은 품목을 입력하세요</h2>
        <label for="addToCart">
            구매 희망 물품
            <input type="text" placeholder="입력 후 엔터" id="addToCart" />
        </label>
    </div>
    <br />
    <br />
    <div>
        <span class="fs-3">쇼핑카트</span>
        <button id="btn-buy" class="btn btn-primary">구매하고 비우기</button>
        <br>
        <br>
        <ul id="shoppingCart">
            <c:forEach items="${cart }" var="item">
                <li>${item }</li>
            </c:forEach>
        </ul>
    </div>
    <%@ include file="/fragments/footer.jsp"%>
</body>
<script>
document.querySelector("#addToCart").addEventListener("keyup", async (e) => {
    const ul = document.querySelector("#shoppingCart")
    const source = e.currentTarget;
    if (e.key !== 'Enter' || source.value.trim() === "") {
        return;
    }//if
    try {
        const response = await fetch("${root}/main", {
            method: "post",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: "action=add-to-cart&data=" + source.value
        });
        const json = await response.json();

        ul.innerHTML = "";
        json.forEach((item) => {
            ul.innerHTML += `<li>\${item}</li>`
        })
    } catch (e) {
        console.log(e);
    } finally {
        source.value = "";
    }
})
</script>
<script>
document.querySelector("#btn-buy").addEventListener("click", async (e) => {
    try {
        const response = await fetch("${root}/main", {
            method: "post",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=buy"
        });
        const json = await response.json();
        if (json.status) {
          document.querySelector("#shoppingCart").innerHTML = "";
          alert("구매 처리 되었습니다.");
        }
    } catch (e) {
        console.log(e);
    }
})
</script>
</html>
