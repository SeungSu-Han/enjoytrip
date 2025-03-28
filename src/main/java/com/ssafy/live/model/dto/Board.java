package com.ssafy.live.model.dto;

import java.util.ArrayList;
import java.util.List;

/**
 * 게시글 정보를 담는 DTO 클래스
 */
public class Board {
    private int boardId;        // 게시글 ID
    private int mno;            // 회원 번호
    private String title;       // 제목
    private String content;     // 내용
    private int viewCount;      // 조회수
    private String createdAt;   // 작성일시
    private String updatedAt;   // 수정일시
    
    // 작성자 정보 (조회용)
    private String writerName;  // 작성자 이름
    
    // 댓글 목록 (조회용)
    private List<Comment> comments = new ArrayList<>();

    public Board() {
    }

    public Board(int mno, String title, String content) {
        this.mno = mno;
        this.title = title;
        this.content = content;
    }

    public Board(int boardId, int mno, String title, String content, int viewCount, String createdAt, String updatedAt) {
        this.boardId = boardId;
        this.mno = mno;
        this.title = title;
        this.content = content;
        this.viewCount = viewCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
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

    public String getWriterName() {
        return writerName;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public void addComment(Comment comment) {
        this.comments.add(comment);
    }

    @Override
    public String toString() {
        return "Board [boardId=" + boardId + ", mno=" + mno + ", title=" + title + ", content=" + content
                + ", viewCount=" + viewCount + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", writerName="
                + writerName + ", commentsCount=" + comments.size() + "]";
    }
}