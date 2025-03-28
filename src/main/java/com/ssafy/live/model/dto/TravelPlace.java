package com.ssafy.live.model.dto;

/**
 * 여행 계획의 장소 정보를 담는 DTO 클래스
 */
public class TravelPlace {
    private int placeId;        // 장소 ID
    private int planId;         // 여행 계획 ID
    private String title;       // 장소 이름
    private String address;     // 주소
    private String x;           // 경도
    private String y;           // 위도
    private int order;          // 순서
    private String memo;        // 메모
    private String contentId;   // 콘텐츠 ID (한국관광공사 API)
    private String contentTypeId; // 콘텐츠 타입 ID (한국관광공사 API)

    public TravelPlace() {
    }

    public TravelPlace(int planId, String title, String address, String x, String y, int order, String memo) {
        this.planId = planId;
        this.title = title;
        this.address = address;
        this.x = x;
        this.y = y;
        this.order = order;
        this.memo = memo;
    }

    public TravelPlace(int placeId, int planId, String title, String address, String x, String y, int order, String memo, String contentId, String contentTypeId) {
        this.placeId = placeId;
        this.planId = planId;
        this.title = title;
        this.address = address;
        this.x = x;
        this.y = y;
        this.order = order;
        this.memo = memo;
        this.contentId = contentId;
        this.contentTypeId = contentTypeId;
    }

    public int getPlaceId() {
        return placeId;
    }

    public void setPlaceId(int placeId) {
        this.placeId = placeId;
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getX() {
        return x;
    }

    public void setX(String x) {
        this.x = x;
    }

    public String getY() {
        return y;
    }

    public void setY(String y) {
        this.y = y;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getContentId() {
        return contentId;
    }

    public void setContentId(String contentId) {
        this.contentId = contentId;
    }

    public String getContentTypeId() {
        return contentTypeId;
    }

    public void setContentTypeId(String contentTypeId) {
        this.contentTypeId = contentTypeId;
    }

    @Override
    public String toString() {
        return "TravelPlace [placeId=" + placeId + ", planId=" + planId + ", title=" + title + ", address=" + address
                + ", x=" + x + ", y=" + y + ", order=" + order + ", memo=" + memo + ", contentId=" + contentId
                + ", contentTypeId=" + contentTypeId + "]";
    }
}