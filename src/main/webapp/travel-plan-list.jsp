<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 여행 계획 목록</title>
<style>
.plan-card {
  transition: transform 0.3s;
}
.plan-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.1);
}
.plan-date {
  color: #6c757d;
  font-size: 0.9rem;
}
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.empty-plans {
  text-align: center;
  padding: 50px 0;
}
.empty-plans i {
  font-size: 4rem;
  color: #dee2e6;
  margin-bottom: 20px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>나의 여행 계획</h2>
            <a href="${root}/auth?action=travel-plan-form" class="btn btn-primary">
                <i class="bi bi-plus-circle me-2"></i>새 여행 계획 만들기
            </a>
        </div>
        
        <c:if test="${empty planList}">
            <div class="empty-plans">
                <i class="bi bi-map"></i>
                <h4>아직 여행 계획이 없습니다</h4>
                <p class="text-muted">새 여행 계획을 만들어 여행을 준비해보세요!</p>
                <a href="${root}/auth?action=travel-plan-form" class="btn btn-outline-primary mt-3">
                    여행 계획 만들기
                </a>
            </div>
        </c:if>
        
        <c:if test="${not empty planList}">
            <div class="row">
                <c:forEach var="plan" items="${planList}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 plan-card">
                            <div class="card-body">
                                <h5 class="card-title">${plan.title}</h5>
                                <p class="plan-date">
                                    <i class="bi bi-calendar-event me-1"></i> ${plan.startDate} ~ ${plan.endDate}
                                </p>
                                <p class="card-text">
                                    <c:choose>
                                        <c:when test="${fn:length(plan.description) > 100}">
                                            ${fn:substring(plan.description, 0, 100)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${plan.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="card-footer bg-transparent">
                                <small class="text-muted">
                                    <i class="bi bi-geo-alt me-1"></i> ${fn:length(plan.places)}개 장소
                                </small>
                                <a href="${root}/auth?action=travel-plan-detail&planId=${plan.planId}" class="btn btn-sm btn-outline-primary">
                                    자세히 보기
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <%@ include file="/fragments/footer.jsp"%>
</body>
</html>