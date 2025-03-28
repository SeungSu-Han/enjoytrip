<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 커뮤니티</title>
<style>
.post-item {
  transition: transform 0.2s;
}
.post-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
.search-bar {
  margin-bottom: 20px;
}
.pagination {
  margin-top: 20px;
}
</style>
</head>
<body>
    <%@ include file="/fragments/header.jsp"%>
    
    <div class="container mt-5">
        <h2>여행 커뮤니티 게시판</h2>
        
        <!-- 검색 바 -->
        <div class="search-bar">
            <form id="searchForm" class="row g-3">
                <div class="col-md-3">
                    <select class="form-select" id="searchType">
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                        <option value="writer">작성자</option>
                    </select>
                </div>
                <div class="col-md-7">
                    <input type="text" class="form-control" id="searchKeyword" placeholder="검색어를 입력하세요">
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn btn-primary w-100" id="searchButton">검색</button>
                </div>
            </form>
        </div>
        
        <!-- 게시글 목록 -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">게시글 목록</h5>
                <button class="btn btn-primary" id="writePostBtn">글쓰기</button>
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th width="10%">번호</th>
                            <th width="50%">제목</th>
                            <th width="15%">작성자</th>
                            <th width="15%">작성일</th>
                            <th width="10%">조회수</th>
                        </tr>
                    </thead>
                    <tbody id="postList">
                        <!-- 게시글 목록이 동적으로 추가됨 -->
                    </tbody>
                </table>
                
                <!-- 페이지네이션 -->
                <nav>
                    <ul class="pagination justify-content-center" id="pagination">
                        <!-- 페이지 번호가 동적으로 추가됨 -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    
    <!-- 글쓰기 모달 -->
    <div class="modal fade" id="writePostModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">게시글 작성</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="postForm">
                        <div class="mb-3">
                            <label for="postTitle" class="form-label">제목</label>
                            <input type="text" class="form-control" id="postTitle" required>
                        </div>
                        <div class="mb-3">
                            <label for="postContent" class="form-label">내용</label>
                            <textarea class="form-control" id="postContent" rows="10" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="submitPostBtn">등록</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 게시글 상세 모달 -->
    <div class="modal fade" id="postDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="detailTitle"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="d-flex justify-content-between mb-3">
                        <div>
                            <span class="text-muted">작성자: </span>
                            <span id="detailWriter"></span>
                        </div>
                        <div>
                            <span class="text-muted">작성일: </span>
                            <span id="detailDate"></span>
                            <span class="ms-3 text-muted">조회수: </span>
                            <span id="detailViews"></span>
                        </div>
                    </div>
                    <hr>
                    <div id="detailContent" class="mb-4"></div>
                    <hr>
                    
                    <!-- 댓글 섹션 -->
                    <div class="comments-section">
                        <h6>댓글</h6>
                        <div id="commentsList" class="mb-3">
                            <!-- 댓글 목록이 동적으로 추가됨 -->
                        </div>
                        
                        <!-- 댓글 작성 폼 -->
                        <div class="comment-form">
                            <textarea class="form-control" id="commentContent" rows="3" placeholder="댓글을 입력하세요"></textarea>
                            <div class="d-flex justify-content-end mt-2">
                                <button class="btn btn-primary btn-sm" id="submitCommentBtn">댓글 등록</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" id="postDetailFooter">
                    <!-- 수정/삭제 버튼이 동적으로 추가됨 -->
                </div>
            </div>
        </div>
    </div>
    
    <!-- 게시글 수정 모달 -->
    <div class="modal fade" id="editPostModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">게시글 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editPostForm">
                        <input type="hidden" id="editPostId">
                        <div class="mb-3">
                            <label for="editPostTitle" class="form-label">제목</label>
                            <input type="text" class="form-control" id="editPostTitle" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPostContent" class="form-label">내용</label>
                            <textarea class="form-control" id="editPostContent" rows="10" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="updatePostBtn">수정</button>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/fragments/footer.jsp"%>
</body>
<script>
// 모달 초기화
const writePostModal = new bootstrap.Modal(document.getElementById('writePostModal'));
const postDetailModal = new bootstrap.Modal(document.getElementById('postDetailModal'));
const editPostModal = new bootstrap.Modal(document.getElementById('editPostModal'));

// 현재 페이지와 선택된 게시글 ID
let currentPage = 1;
let currentPostId = null;
let currentUser = null; // 실제로는 서버에서 로그인 사용자 정보 가져옴

// DOM이 로드된 후 실행
document.addEventListener("DOMContentLoaded", () => {
    // 게시글 목록 불러오기
    loadPosts(currentPage);
    
    // 글쓰기 버튼 이벤트
    document.getElementById("writePostBtn").addEventListener("click", () => {
        // 로그인 여부 확인
        if (!isLoggedIn()) {
            alert("로그인 후 이용 가능합니다.");
            return;
        }
        
        writePostModal.show();
    });
    
    // 게시글 등록 버튼 이벤트
    document.getElementById("submitPostBtn").addEventListener("click", submitPost);
    
    // 게시글 수정 버튼 이벤트
    document.getElementById("updatePostBtn").addEventListener("click", updatePost);
    
    // 댓글 등록 버튼 이벤트
    document.getElementById("submitCommentBtn").addEventListener("click", submitComment);
    
    // 검색 버튼 이벤트
    document.getElementById("searchButton").addEventListener("click", () => {
        currentPage = 1;
        loadPosts(currentPage);
    });
});

// 로그인 여부 확인 (실제로는 서버 세션 확인)
function isLoggedIn() {
    // 임시 로그인 상태 확인
    return true;
}

// 게시글 목록 불러오기
async function loadPosts(page) {
    try {
        const searchType = document.getElementById("searchType").value;
        const searchKeyword = document.getElementById("searchKeyword").value;
        
        // 서버에서 게시글 목록 가져오기 (실제로는 서버에 GET 요청)
        // const response = await fetch(`/auth?action=board-list&page=${page}&searchType=${searchType}&searchKeyword=${searchKeyword}`);
        // const data = await response.json();
        
        // 임시 데이터 (모의 데이터)
        const mockData = {
            posts: [
                {
                    id: 1,
                    title: "제주도 여행 추천 코스",
                    content: "제주도 3박 4일 여행 코스를 공유합니다! 첫째 날은 동부 지역을 중심으로 성산일출봉과 섭지코지를 구경했어요. 둘째 날은 서부 지역으로 가서 카페 투어와 올레길 산책을 했습니다. 셋째 날은 한라산을 등반했는데, 정말 힘들었지만 뷰가 정말 좋았어요. 넷째 날은 중문관광단지에서 여유롭게 시간을 보냈습니다. 제주도 여행 계획 중이신 분들에게 도움이 되었으면 좋겠네요!",
                    writer: "여행자A",
                    date: "2025-03-25",
                    views: 142
                },
                {
                    id: 2,
                    title: "부산 해운대 맛집 추천해주세요",
                    content: "다음 주에 부산 여행을 계획 중인데, 해운대 근처 맛집 추천 부탁드립니다! 특히 해산물이나 부산 로컬 음식점이면 더 좋을 것 같아요.",
                    writer: "맛집탐험가",
                    date: "2025-03-24",
                    views: 89
                },
                {
                    id: 3,
                    title: "강원도 속초 여행 후기",
                    content: "지난 주말 속초로 여행 다녀왔습니다. 날씨가 너무 좋아서 설악산도 등반하고 속초 해변도 걸어봤어요. 특히 아바이마을의 순대국밥이 정말 맛있었습니다! 다들 속초 가시면 꼭 드셔보세요.",
                    writer: "산과바다",
                    date: "2025-03-23",
                    views: 115
                },
                {
                    id: 4,
                    title: "전주 한옥마을 1박 2일 코스 질문",
                    content: "전주 한옥마을로 주말 여행 계획 중인데, 1박 2일로 알차게 즐길 수 있는 코스 추천해주실 분 계신가요? 꼭 가봐야 할 곳이나 맛집이 있다면 알려주세요!",
                    writer: "여행초보",
                    date: "2025-03-21",
                    views: 76
                },
                {
                    id: 5,
                    title: "여름 휴가 어디로 갈까요?",
                    content: "여름 휴가 계획 중인데, 국내 여행지 추천 부탁드립니다. 너무 붐비지 않으면서도 시원하게 즐길 수 있는 곳이면 좋겠어요.",
                    writer: "휴가고민중",
                    date: "2025-03-20",
                    views: 201
                }
            ],
            totalPages: 5,
            currentPage: page
        };
        
        // 게시글 목록 표시
        displayPosts(mockData);
    } catch (error) {
        console.error("게시글 목록 로드 오류:", error);
    }
}

// 게시글 목록 표시
function displayPosts(data) {
    const postList = document.getElementById("postList");
    postList.innerHTML = "";
    
    if (data.posts.length === 0) {
        postList.innerHTML = `
            <tr>
                <td colspan="5" class="text-center">게시글이 없습니다.</td>
            </tr>
        `;
        return;
    }
    
    data.posts.forEach(post => {
        const row = document.createElement("tr");
        row.className = "post-item";
        row.innerHTML = `
            <td>${post.id}</td>
            <td class="post-title" data-id="${post.id}">${post.title}</td>
            <td>${post.writer}</td>
            <td>${post.date}</td>
            <td>${post.views}</td>
        `;
        
        // 제목 클릭 시 상세 보기
        row.querySelector(".post-title").addEventListener("click", () => {
            viewPostDetail(post.id);
        });
        
        postList.appendChild(row);
    });
    
    // 페이지네이션 표시
    displayPagination(data.totalPages, data.currentPage);
}

// 페이지네이션 표시
function displayPagination(totalPages, currentPage) {
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = "";
    
    // 이전 버튼
    const prevLi = document.createElement("li");
    prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
    prevLi.innerHTML = `<a class="page-link" href="#" data-page="${currentPage - 1}">이전</a>`;
    pagination.appendChild(prevLi);
    
    // 페이지 번호
    for (let i = 1; i <= totalPages; i++) {
        const pageLi = document.createElement("li");
        pageLi.className = `page-item ${i === currentPage ? 'active' : ''}`;
        pageLi.innerHTML = `<a class="page-link" href="#" data-page="${i}">${i}</a>`;
        pagination.appendChild(pageLi);
    }
    
    // 다음 버튼
    const nextLi = document.createElement("li");
    nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
    nextLi.innerHTML = `<a class="page-link" href="#" data-page="${currentPage + 1}">다음</a>`;
    pagination.appendChild(nextLi);
    
    // 페이지 클릭 이벤트
    document.querySelectorAll(".page-link").forEach(link => {
        link.addEventListener("click", function(e) {
            e.preventDefault();
            const page = parseInt(this.getAttribute("data-page"));
            if (page > 0 && page <= totalPages) {
                currentPage = page;
                loadPosts(currentPage);
            }
        });
    });
}

// 게시글 상세 보기
async function viewPostDetail(postId) {
    try {
        // 서버에서 게시글 상세 정보 가져오기 (실제로는 서버에 GET 요청)
        // const response = await fetch(`/auth?action=board-detail&id=${postId}`);
        // const post = await response.json();
        
        // 임시 데이터 (모의 데이터)
        const mockPost = {
            id: postId,
            title: "제주도 여행 추천 코스",
            content: "제주도 3박 4일 여행 코스를 공유합니다!<br><br>첫째 날은 동부 지역을 중심으로 성산일출봉과 섭지코지를 구경했어요. 섭지코지의 바다 풍경은 정말 장관이었습니다.<br><br>둘째 날은 서부 지역으로 가서 카페 투어와 올레길 산책을 했습니다. 협재해변의 에메랄드빛 바다가 인상적이었어요.<br><br>셋째 날은 한라산을 등반했는데, 정말 힘들었지만 뷰가 정말 좋았어요. 정상에서 바라본 풍경은 잊을 수 없을 거예요.<br><br>넷째 날은 중문관광단지에서 여유롭게 시간을 보냈습니다. 여유롭게 마무리했어요.<br><br>제주도 여행 계획 중이신 분들에게 도움이 되었으면 좋겠네요!",
            writer: "여행자A",
            date: "2025-03-25",
            views: 143,
            comments: [
                {
                    id: 1,
                    content: "좋은 정보 감사합니다! 다음 달에 제주도 여행 갈 예정인데 많은 도움이 되었어요.",
                    writer: "여행준비중",
                    date: "2025-03-26"
                },
                {
                    id: 2,
                    content: "한라산 등반 코스는 어떤 코스로 가셨나요? 참고하고 싶습니다.",
                    writer: "등산러버",
                    date: "2025-03-26"
                }
            ],
            isWriter: true // 실제로는 서버에서 현재 로그인한 사용자와 작성자 비교 결과
        };
        
        // 현재 선택된 게시글 ID 저장
        currentPostId = postId;
        
        // 게시글 상세 정보 표시
        document.getElementById("detailTitle").textContent = mockPost.title;
        document.getElementById("detailWriter").textContent = mockPost.writer;
        document.getElementById("detailDate").textContent = mockPost.date;
        document.getElementById("detailViews").textContent = mockPost.views;
        document.getElementById("detailContent").innerHTML = mockPost.content;
        
        // 수정/삭제 버튼 표시 (작성자인 경우에만)
        const footer = document.getElementById("postDetailFooter");
        footer.innerHTML = "";
        
        if (mockPost.isWriter) {
            footer.innerHTML = `
                <button type="button" class="btn btn-outline-primary" id="editPostBtn">수정</button>
                <button type="button" class="btn btn-outline-danger" id="deletePostBtn">삭제</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            `;
            
            // 수정 버튼 이벤트
            document.getElementById("editPostBtn").addEventListener("click", () => {
                postDetailModal.hide();
                showEditPostModal(mockPost);
            });
            
            // 삭제 버튼 이벤트
            document.getElementById("deletePostBtn").addEventListener("click", () => {
                deletePost(postId);
            });
        } else {
            footer.innerHTML = `
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            `;
        }
        
        // 댓글 표시
        displayComments(mockPost.comments);
        
        // 모달 표시
        postDetailModal.show();
    } catch (error) {
        console.error("게시글 상세 정보 로드 오류:", error);
    }
}

// 댓글 표시
function displayComments(comments) {
    const commentsList = document.getElementById("commentsList");
    commentsList.innerHTML = "";
    
    if (comments.length === 0) {
        commentsList.innerHTML = "<p class='text-muted'>댓글이 없습니다.</p>";
        return;
    }
    
    comments.forEach(comment => {
        const commentItem = document.createElement("div");
        commentItem.className = "comment-item border-bottom pb-2 mb-2";
        commentItem.innerHTML = `
            <div class="d-flex justify-content-between">
                <div>
                    <strong>${comment.writer}</strong>
                    <span class="text-muted ms-2">${comment.date}</span>
                </div>
                ${comment.writer === currentUser ? `
                <div>
                    <button class="btn btn-sm text-danger delete-comment" data-id="${comment.id}">삭제</button>
                </div>
                ` : ''}
            </div>
            <div class="mt-1">${comment.content}</div>
        `;
        
        // 댓글 삭제 버튼 이벤트
        const deleteBtn = commentItem.querySelector(".delete-comment");
        if (deleteBtn) {
            deleteBtn.addEventListener("click", () => {
                deleteComment(comment.id);
            });
        }
        
        commentsList.appendChild(commentItem);
    });
}

// 게시글 수정 모달 표시
function showEditPostModal(post) {
    document.getElementById("editPostId").value = post.id;
    document.getElementById("editPostTitle").value = post.title;
    document.getElementById("editPostContent").value = post.content.replace(/<br>/g, '\n');
    
    editPostModal.show();
}

// 게시글 등록
async function submitPost() {
    const title = document.getElementById("postTitle").value.trim();
    const content = document.getElementById("postContent").value.trim();
    
    if (!title || !content) {
        alert("제목과 내용을 모두 입력해주세요.");
        return;
    }
    
    try {
        // 서버에 게시글 등록 (실제로는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "board-write",
        //         title,
        //         content
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("등록할 게시글:", { title, content });
        
        alert("게시글이 등록되었습니다!");
        
        // 모달 닫기 및 폼 초기화
        writePostModal.hide();
        document.getElementById("postForm").reset();
        
        // 게시글 목록 다시 로드
        loadPosts(1);
    } catch (error) {
        console.error("게시글 등록 오류:", error);
        alert("게시글 등록 중 오류가 발생했습니다.");
    }
}

// 게시글 수정
async function updatePost() {
    const postId = document.getElementById("editPostId").value;
    const title = document.getElementById("editPostTitle").value.trim();
    const content = document.getElementById("editPostContent").value.trim();
    
    if (!title || !content) {
        alert("제목과 내용을 모두 입력해주세요.");
        return;
    }
    
    try {
        // 서버에 게시글 수정 (실제로는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "board-update",
        //         id: postId,
        //         title,
        //         content
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("수정할 게시글:", { id: postId, title, content });
        
        alert("게시글이 수정되었습니다!");
        
        // 모달 닫기
        editPostModal.hide();
        
        // 게시글 상세 정보 다시 불러오기
        viewPostDetail(postId);
    } catch (error) {
        console.error("게시글 수정 오류:", error);
        alert("게시글 수정 중 오류가 발생했습니다.");
    }
}

// 게시글 삭제
async function deletePost(postId) {
    if (!confirm("정말로 게시글을 삭제하시겠습니까?")) {
        return;
    }
    
    try {
        // 서버에 게시글 삭제 요청 (실제로는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "board-delete",
        //         id: postId
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("삭제할 게시글:", { id: postId });
        
        alert("게시글이 삭제되었습니다!");
        
        // 모달 닫기
        postDetailModal.hide();
        
        // 게시글 목록 다시 로드
        loadPosts(currentPage);
    } catch (error) {
        console.error("게시글 삭제 오류:", error);
        alert("게시글 삭제 중 오류가 발생했습니다.");
    }
}

// 댓글 등록
async function submitComment() {
    const content = document.getElementById("commentContent").value.trim();
    if (!content) {
        alert("댓글 내용을 입력해주세요.");
        return;
    }
    
    // 로그인 여부 확인
    if (!isLoggedIn()) {
        alert("로그인 후 이용 가능합니다.");
        return;
    }
    
    try {
        // 서버에 댓글 등록 (실제로는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "comment-write",
        //         postId: currentPostId,
        //         content
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("등록할 댓글:", { postId: currentPostId, content });
        
        alert("댓글이 등록되었습니다!");
        
        // 댓글 입력창 초기화
        document.getElementById("commentContent").value = "";
        
        // 게시글 상세 정보 다시 불러오기 (댓글 포함)
        viewPostDetail(currentPostId);
    } catch (error) {
        console.error("댓글 등록 오류:", error);
        alert("댓글 등록 중 오류가 발생했습니다.");
    }
}

// 댓글 삭제
async function deleteComment(commentId) {
    if (!confirm("정말로 댓글을 삭제하시겠습니까?")) {
        return;
    }
    
    try {
        // 서버에 댓글 삭제 요청 (실제로는 서버에 POST 요청)
        // const response = await fetch("/auth", {
        //     method: "POST",
        //     headers: {
        //         "Content-Type": "application/x-www-form-urlencoded",
        //     },
        //     body: new URLSearchParams({
        //         action: "comment-delete",
        //         id: commentId
        //     }).toString()
        // });
        // const result = await response.json();
        
        // 임시 응답 시뮬레이션
        console.log("삭제할 댓글:", { id: commentId });
        
        alert("댓글이 삭제되었습니다!");
        
        // 게시글 상세 정보 다시 불러오기 (댓글 포함)
        viewPostDetail(currentPostId);
    } catch (error) {
        console.error("댓글 삭제 오류:", error);
        alert("댓글 삭제 중 오류가 발생했습니다.");
    }
}
</script>
</html>