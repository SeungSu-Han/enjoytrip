package com.ssafy.live.model.dto;

/**
 * 핫플레이스 정보를 담는 DTO 클래스
 */
public class Hotplace {
    private int hotplaceId;     // 핫플레이스 ID
    private int mno;            // 회원 번호
    private String title;       // 장소 이름
    private String address;     // 주소
    private String x;           // 경도
    private String y;           // 위도
    private String placeType;   // 장소 유형
    private String description; // 상세 설명
    private String visitDate;   // 방문일자
    private String imageUrl;    // 이미지 URL
    private String createdAt;   // 작성일시
    
    // 작성자 정보 (조회용)
    private String writerName;  // 작성자 이름

    public Hotplace() {
    }

    public Hotplace(int mno, String title, String address, String x, String y, String placeType, String description, String visitDate) {
        this.mno = mno;
        this.title = title;
        this.address = address;
        this.x = x;
        this.y = y;
        this.placeType = placeType;
        this.description = description;
        this.visitDate = visitDate;
    }

    public Hotplace(int hotplaceId, int mno, String title, String address, String x, String y, String placeType, String description, String visitDate, String imageUrl, String createdAt) {
        this.hotplaceId = hotplaceId;
        this.mno = mno;
        this.title = title;
        this.address = address;
        this.x = x;
        this.y = y;
        this.placeType = placeType;
        this.description = description;
        this.visitDate = visitDate;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    public int getHotplaceId() {
        return hotplaceId;
    }

    public void setHotplaceId(int hotplaceId) {
        this.hotplaceId = hotplaceId;
    }

    public int getMno() {
        return mno;
    }

    public void setMno(int mno) {
        this.mno = mno;
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

    public String getPlaceType() {
        return placeType;
    }

    public void setPlaceType(String placeType) {
        this.placeType = placeType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(String visitDate) {
        this.visitDate = visitDate;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getWriterName() {
        return writerName;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    @Override
    public String toString() {
        return "Hotplace [hotplaceId=" + hotplaceId + ", mno=" + mno + ", title=" + title + ", address=" + address
                + ", x=" + x + ", y=" + y + ", placeType=" + placeType + ", description=" + description + ", visitDate="
                + visitDate + ", imageUrl=" + imageUrl + ", createdAt=" + createdAt + ", writerName=" + writerName + "]";
    }
}