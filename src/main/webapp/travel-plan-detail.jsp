<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 계획 상세</title>
<style>
#map {
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}
.travel-info {
  background-color: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.travel-dates {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.travel-dates i {
  margin: 0 10px;
  color: #6c757d;
}
.place-item {
  border-left: 3px solid #007bff;
  padding: 15px;
  margin-bottom: 15px;
  background-color: #f8f9fa;
  border-radius: 0 8px 8px 0;
}
.place-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}
.place-title {
  font-weight: bold;
  font-size: 1.1rem;
  margin: 0;
}
.place-address {
  color: #6c757d;
  font-size: 0.9rem;
  margin-bottom: 10px;
}
.place-memo {
  padding: 10px;
  background-color: #fff;
  border-radius: 4px;
  border-left: 2px solid #ffc107;
}
.action-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <div class="container mt-5">
        <div class="action-buttons">
            <a href="${root}/auth?action=travel-plan-list" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>목록으로
            </a>
            <a href="${root}/auth?action=travel-plan-form&planId=${plan.planId}" class="btn btn-outline-primary">
                <i class="bi bi-pencil me-2"></i>수정
            </a>
            <button type="button" class="btn btn-outline-danger" id="deletePlanBtn">
                <i class="bi bi-trash me-2"></i>삭제
            </button>
        </div>
        
        <h2>${plan.title}</h2>
        
        <div class="travel-info">
            <div class="travel-dates">
                <strong>여행 기간:</strong>
                <span class="ms-2">${plan.startDate}</span>
                <i class="bi bi-arrow-right"></i>
                <span>${plan.endDate}</span>
            </div>
            
            <div class="mb-3">
                <strong>예상 경비:</strong>
                <span class="ms-2"><fmt:formatNumber value="${plan.budget}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></span>
            </div>
            
            <div>
                <strong>여행 설명:</strong>
                <p class="mt-2">${plan.description}</p>
            </div>
        </div>
        
        <!-- 지도 영역 -->
        <div id="map"></div>
        
        <!-- 장소 목록 -->
        <h4 class="mb-3">여행 장소 목록 (${fn:length(plan.places)}개)</h4>
        
        <c:if test="${empty plan.places}">
            <div class="alert alert-info">
                등록된 여행 장소가 없습니다.
            </div>
        </c:if>
        
        <c:if test="${not empty plan.places}">
            <div class="places-list">
                <c:forEach var="place" items="${plan.places}" varStatus="status">
                    <div class="place-item">
                        <div class="place-header">
                            <h5 class="place-title">
                                <span class="badge bg-primary me-2">${status.index + 1}</span>
                                ${place.title}
                            </h5>
                            <button class="btn btn-sm btn-outline-primary view-on-map-btn" 
                                    data-x="${place.x}" data-y="${place.y}" data-title="${place.title}">
                                지도에서 보기
                            </button>
                        </div>
                        <p class="place-address">
                            <i class="bi bi-geo-alt me-1"></i>${place.address}
                        </p>
                        <c:if test="${not empty place.memo}">
                            <div class="place-memo">
                                <i class="bi bi-chat-left-text me-2"></i>${place.memo}
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <!-- 삭제 확인 모달 -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">여행 계획 삭제</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 이 여행 계획을 삭제하시겠습니까?</p>
                    <p class="text-danger">이 작업은 되돌릴 수 없습니다.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">삭제</button>
                </div>
            </div>