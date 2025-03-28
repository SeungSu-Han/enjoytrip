package com.ssafy.live.model.dto;

/**
 * 댓글 정보를 담는 DTO 클래스
 */
public class Comment {
    private int commentId;      // 댓글 ID
    private int boardId;        // 게시글 ID
    private int mno;            // 회원 번호
    private String content;     // 내용
    private String createdAt;   // 작성일시
    
    // 작성자 정보 (조회용)
    private String writerName;  // 작성자 이름

    public Comment() {
    }

    public Comment(int boardId, int mno, String content) {
        this.boardId = boardId;
        this.mno = mno;
        this.content = content;
    }

    public Comment(int commentId, int boardId, int mno, String content, String createdAt) {
        this.commentId = commentId;
        this.boardId = boardId;
        this.mno = mno;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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
        return "Comment [commentId=" + commentId + ", boardId=" + boardId + ", mno=" + mno + ", content=" + content
                + ", createdAt=" + createdAt + ", writerName=" + writerName + "]";
    }
}