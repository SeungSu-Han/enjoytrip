package com.ssafy.live.model.dto;

import java.util.ArrayList;
import java.util.List;

/**
 * 여행 계획 정보를 담는 DTO 클래스
 */
public class TravelPlan {
    private int planId;         // 여행 계획 ID
    private int mno;            // 회원 번호
    private String title;       // 여행 제목
    private String startDate;   // 여행 시작일
    private String endDate;     // 여행 종료일
    private String description; // 여행 설명
    private double budget;      // 예상 경비
    private String createdAt;   // 작성일시
    private String updatedAt;   // 수정일시
    
    // 여행 장소 목록
    private List<TravelPlace> places = new ArrayList<>();

    public TravelPlan() {
    }

    public TravelPlan(int mno, String title, String startDate, String endDate, String description, double budget) {
        this.mno = mno;
        this.title = title;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.budget = budget;
    }

    public TravelPlan(int planId, int mno, String title, String startDate, String endDate, String description, double budget, String createdAt, String updatedAt) {
        this.planId = planId;
        this.mno = mno;
        this.title = title;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.budget = budget;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
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

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<TravelPlace> getPlaces() {
        return places;
    }

    public void setPlaces(List<TravelPlace> places) {
        this.places = places;
    }

    public void addPlace(TravelPlace place) {
        this.places.add(place);
    }

    @Override
    public String toString() {
        return "TravelPlan [planId=" + planId + ", mno=" + mno + ", title=" + title + ", startDate=" + startDate
                + ", endDate=" + endDate + ", description=" + description + ", budget=" + budget + ", createdAt="
                + createdAt + ", updatedAt=" + updatedAt + ", placesCount=" + places.size() + "]";
    }
}