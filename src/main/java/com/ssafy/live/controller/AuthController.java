package com.ssafy.live.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.live.model.dto.Address;
import com.ssafy.live.model.dto.Board;
import com.ssafy.live.model.dto.Comment;
import com.ssafy.live.model.dto.Hotplace;
import com.ssafy.live.model.dto.Member;
import com.ssafy.live.model.dto.Page;
import com.ssafy.live.model.dto.SearchCondition;
import com.ssafy.live.model.dto.TravelPlace;
import com.ssafy.live.model.dto.TravelPlan;
import com.ssafy.live.model.service.AddressService;
import com.ssafy.live.model.service.BasicAddressService;
import com.ssafy.live.model.service.BasicMemberService;
import com.ssafy.live.model.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(urlPatterns = "/auth")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@SuppressWarnings("serial")
public class AuthController extends HttpServlet implements ControllerHelper {

    private final MemberService mService = BasicMemberService.getService();
    private final AddressService aService = BasicAddressService.getService();

    // SGIS API 키
    private final String keyVworld = "757E13C9-7A44-33C3-AC49-FAA00732D434";
    private final String keySgisServiceId = "07f757fc8fbe4816b51d"; // 서비스 id
    private final String keySgisSecurity = "c9f1064aecfb4a25bf96"; // 보안 key
    private final String keyData = "/nY0dthdgiMTSxqSb0jK/5+kT6LxtTwCBm9nJJVzdpFBuODsmJYh50YC8FSYus3E/wGpBZvR2JhLjJaJuw44jw=="; // data.go.kr 인증키

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = preProcessing(request, response);
        System.out.println("Action: " + action);
        
        try {
            switch (action) {
                // 기존 기능
                case "member-detail" -> memberDetail(request, response);
                case "member-list" -> memberList(request, response);
                case "member-delete" -> memberDelete(request, response);
                case "member-modify-form" -> memberModifyForm(request, response);
                case "member-modify" -> memberModify(request, response);
                case "address-delete" -> addressDelete(request, response);
                case "address-insert" -> addressInsert(request, response);
                
                // 여행 계획 기능
                case "travel-plan-form" -> travelPlanForm(request, response);
                case "travel-plan-list" -> travelPlanList(request, response);
                case "travel-plan-detail" -> travelPlanDetail(request, response);
                case "travel-plan-insert" -> travelPlanInsert(request, response);
                case "travel-plan-update" -> travelPlanUpdate(request, response);
                case "travel-plan-delete" -> travelPlanDelete(request, response);
                
                // 핫플레이스 기능
                case "hotplace-form" -> hotplaceForm(request, response);
                case "hotplace-list" -> hotplaceList(request, response);
                case "hotplace-detail" -> hotplaceDetail(request, response);
                case "hotplace-insert" -> hotplaceInsert(request, response);
                case "hotplace-delete" -> hotplaceDelete(request, response);
                
                // 게시판 기능
                case "board-form" -> boardForm(request, response);
                case "board-list" -> boardList(request, response);
                case "board-detail" -> boardDetail(request, response);
                case "board-write" -> boardWrite(request, response);
                case "board-update" -> boardUpdate(request, response);
                case "board-delete" -> boardDelete(request, response);
                case "comment-write" -> commentWrite(request, response);
                case "comment-delete" -> commentDelete(request, response);
                
                default -> forward(request, response, "/error/404.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            forward(request, response, "/error/500.jsp");
        }
    }

    // 기존 메서드들...
    private void memberDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        try {
            Member member = mService.selectDetail(email);
            request.setAttribute("member", member);
            request.setAttribute("key_vworld", keyVworld);
            request.setAttribute("key_sgis_service_id", keySgisServiceId);
            request.setAttribute("key_sgis_security", keySgisSecurity);
            request.setAttribute("key_data", keyData);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("alertMsg", e.getMessage());
        }
        forward(request, response, "/member/member-detail.jsp");
    }

    private void memberList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> keyMap = Map.of("1", "name", "2", "email");
        String key = request.getParameter("key");
        if (key != null) {
            key = keyMap.getOrDefault(key, "");
        }
        String word = request.getParameter("word");
        int currentPage = Integer.parseInt(request.getParameter("currentPage"));
        try {
            Page<Member> page = mService.search(new SearchCondition(key, word, currentPage));
            request.setAttribute("page", page);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("alertMsg", e.getMessage());
        }
        forward(request, response, "/member/member-list.jsp");
    }

    private void memberModifyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        try {
            Member member = mService.selectDetail(email);
            request.setAttribute("member", member);
            forward(request, response, "/member/member-modify-form.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("alertMsg", e.getMessage());
            redirect(request, response, "/auth?action=member-detail&email=" + email);
        }
    }

    private void memberModify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        int mno = Integer.parseInt(request.getParameter("mno"));

        try {
            Member member = new Member(mno, name, email, password, role);
            mService.update(member);
            // 세션 사용자의 경우 이름 변경해주기
            HttpSession session = request.getSession();
            if (((Member) session.getAttribute("loginUser")).getEmail().equals(member.getEmail())) {
                session.setAttribute("loginUser", member);
            }
            // post redirect get
            redirect(request, response, "/auth?action=member-detail&email=" + email);
        } catch (SQLException e) {
            e.printStackTrace();
            // 다시 member detail 상황으로 이동
            HttpSession session = request.getSession();
            session.setAttribute("alertMsg", e.getMessage());
            redirect(request, response, "/auth?action=member-detail&email=" + email);
        }
    }

    private void addressInsert(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int mno = Integer.parseInt(request.getParameter("mno"));
            String title = request.getParameter("addr_title");
            String main = request.getParameter("addr_main");
            String detail = request.getParameter("addr_detail");
            String x = request.getParameter("x");
            String y = request.getParameter("y");
            String email = request.getParameter("email");
            Address addr = new Address(0, mno, title, main, detail, x, y);
            aService.registAddress(addr);
            Member member = mService.selectDetail(email);
            toJSON(member.getAddresses(), response);
        } catch (SQLException e) {
            e.printStackTrace();
            toJSON(Map.of("error", e.getMessage()), response);
        }
    }

    private void addressDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int ano = Integer.parseInt(request.getParameter("ano"));
            String email = request.getParameter("email");
            aService.deleteAddress(ano);
            Member member = mService.selectDetail(email);
            toJSON(member.getAddresses(), response);
        } catch (SQLException e) {
            e.printStackTrace();
            toJSON(Map.of("error", e.getMessage()), response);
        }
    }

    private void memberDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int mno = Integer.parseInt(request.getParameter("mno"));
        String email = request.getParameter("email");
        try {
            mService.delete(mno);
            HttpSession session = request.getSession();
            if (session.getAttribute("loginUser") instanceof Member m && m.getEmail().equals(email)) {
                session.invalidate();
                redirect(request, response, "/");
            }
            else {
                session.setAttribute("alertMsg", "삭제 성공");
                redirect(request, response, "/auth?action=member-list&currentPage=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            forward(request, response, "/member/member-detail.jsp");
        }
    }

    // 여행 계획 관련 메서드
    private void travelPlanForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 지도 API 키 설정
        request.setAttribute("key_vworld", keyVworld);
        request.setAttribute("key_sgis_service_id", keySgisServiceId);
        request.setAttribute("key_sgis_security", keySgisSecurity);
        request.setAttribute("key_data", keyData);
        
        forward(request, response, "/travel/travel-plan.jsp");
    }

    private void travelPlanList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 로그인 사용자의 여행 계획 목록 조회 (임시 데이터)
        List<TravelPlan> planList = new ArrayList<>();
        // 실제로는 DB에서 조회
        
        // 임시 데이터 생성
        TravelPlan plan1 = new TravelPlan(1, 1, "서울 여행", "2025-04-15", "2025-04-17", "서울 핵심 관광지 탐방", 300000, "2025-03-28", null);
        TravelPlan plan2 = new TravelPlan(2, 1, "제주도 힐링 여행", "2025-05-20", "2025-05-23", "제주도 동부 지역 중심", 500000, "2025-03-27", null);
        planList.add(plan1);
        planList.add(plan2);
        
        request.setAttribute("planList", planList);
        forward(request, response, "/travel/travel-plan-list.jsp");
    }

    private void travelPlanDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int planId = Integer.parseInt(request.getParameter("planId"));
        
        // 여행 계획 상세 정보 조회 (임시 데이터)
        TravelPlan plan = new TravelPlan(planId, 1, "서울 여행", "2025-04-15", "2025-04-17", "서울 핵심 관광지 탐방", 300000, "2025-03-28", null);
        
        // 여행 장소 목록 (임시 데이터)
        List<TravelPlace> places = new ArrayList<>();
        places.add(new TravelPlace(planId, "경복궁", "서울특별시 종로구 세종로 1-1", "126.976799", "37.579617", 1, "조선의 법궁, 꼭 세자빈과 함께!"));
        places.add(new TravelPlace(planId, "남산타워", "서울특별시 용산구 남산공원길 105", "126.988228", "37.551163", 2, "서울의 전망을 한눈에"));
        places.add(new TravelPlace(planId, "광장시장", "서울특별시 종로구 종로5가 395-8", "126.999908", "37.570483", 3, "전통시장에서 맛보는 서울의 맛"));
        
        plan.setPlaces(places);
        
        // 지도 API 키 설정
        request.setAttribute("key_vworld", keyVworld);
        request.setAttribute("key_sgis_service_id", keySgisServiceId);
        request.setAttribute("key_sgis_security", keySgisSecurity);
        request.setAttribute("key_data", keyData);
        
        request.setAttribute("plan", plan);
        forward(request, response, "/travel/travel-plan-detail.jsp");
    }

    private void travelPlanInsert(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Form에서 JSON으로 전송된 여행 계획 데이터 파싱
        String planDataJson = request.getParameter("planData");
        
        // 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        try {
            // JSON 파싱
            ObjectMapper mapper = new ObjectMapper();
            TravelPlan plan = mapper.readValue(planDataJson, TravelPlan.class);
            
            // 사용자 번호 설정
            plan.setMno(loginUser.getMno());
            
            // DB에 저장 (실제 구현에서는 서비스 레이어 호출)
            // travelPlanService.saveTravelPlan(plan);
            
            // 저장 성공 응답
            toJSON(Map.of("success", true, "message", "여행 계획이 성공적으로 저장되었습니다.", "planId", 1), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "여행 계획 저장 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void travelPlanUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Form에서 JSON으로 전송된 여행 계획 데이터 파싱
        String planDataJson = request.getParameter("planData");
        
        try {
            // JSON 파싱
            ObjectMapper mapper = new ObjectMapper();
            TravelPlan plan = mapper.readValue(planDataJson, TravelPlan.class);
            
            // DB에 업데이트 (실제 구현에서는 서비스 레이어 호출)
            // travelPlanService.updateTravelPlan(plan);
            
            // 업데이트 성공 응답
            toJSON(Map.of("success", true, "message", "여행 계획이 성공적으로 수정되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "여행 계획 수정 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void travelPlanDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int planId = Integer.parseInt(request.getParameter("planId"));
        
        try {
            // DB에서 삭제 (실제 구현에서는 서비스 레이어 호출)
            // travelPlanService.deleteTravelPlan(planId);
            
            // 삭제 성공 응답
            toJSON(Map.of("success", true, "message", "여행 계획이 성공적으로 삭제되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "여행 계획 삭제 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    // 핫플레이스 관련 메서드
    private void hotplaceForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 지도 API 키 설정
        request.setAttribute("key_vworld", keyVworld);
        request.setAttribute("key_sgis_service_id", keySgisServiceId);
        request.setAttribute("key_sgis_security", keySgisSecurity);
        request.setAttribute("key_data", keyData);
        
        forward(request, response, "/hotplace/hotplace.jsp");
    }

    private void hotplaceList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 핫플레이스 목록 조회 (임시 데이터)
        List<Hotplace> hotplaceList = new ArrayList<>();
        
        // 임시 데이터 생성
        Hotplace hotplace1 = new Hotplace(1, 1, "서울숲 산책로", "서울특별시 성동구 성수동1가 685-6", "127.0374", "37.5444", "attraction", "도심 속 자연을 느낄 수 있는 멋진 공원입니다.", "2025-03-15", "/api/placeholder/300/200", "2025-03-28");
        hotplace1.setWriterName("홍길동");
        
        Hotplace hotplace2 = new Hotplace(2, 2, "을지로 미진식당", "서울특별시 중구 을지로 119", "126.9918", "37.5664", "restaurant", "을지로 맛집! 김치찌개가 정말 맛있어요.", "2025-03-10", "/api/placeholder/300/200", "2025-03-27");
        hotplace2.setWriterName("김철수");
        
        hotplaceList.add(hotplace1);
        hotplaceList.add(hotplace2);
        
        // JSON 응답
        toJSON(hotplaceList, response);
    }

    private void hotplaceDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int hotplaceId = Integer.parseInt(request.getParameter("hotplaceId"));
        
        // 핫플레이스 상세 정보 조회 (임시 데이터)
        Hotplace hotplace = new Hotplace(hotplaceId, 1, "서울숲 산책로", "서울특별시 성동구 성수동1가 685-6", "127.0374", "37.5444", "attraction", "도심 속 자연을 느낄 수 있는 멋진 공원입니다. 주말에 가족과 함께 방문했는데 공기도 좋고 산책하기 좋았어요.", "2025-03-15", "/api/placeholder/300/200", "2025-03-28");
        hotplace.setWriterName("홍길동");
        
        // JSON 응답
        toJSON(hotplace, response);
    }

    private void hotplaceInsert(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        try {
            // 폼 데이터 가져오기
            String title = request.getParameter("title");
            String address = request.getParameter("address");
            String x = request.getParameter("x");
            String y = request.getParameter("y");
            String placeType = request.getParameter("placeType");
            String description = request.getParameter("description");
            String visitDate = request.getParameter("visitDate");
            
            // 이미지 파일 처리
            Part filePart = request.getPart("image");
            String imageUrl = "/api/placeholder/300/200"; // 기본 이미지 URL
            
            if (filePart != null && filePart.getSize() > 0) {
                // 실제 이미지 저장 로직 (실제 구현에서는 파일 저장 및 URL 생성)
                // String fileName = ... // 저장된 파일명
                // imageUrl = "/uploads/" + fileName;
            }
            
            // 핫플레이스 객체 생성
            Hotplace hotplace = new Hotplace(loginUser.getMno(), title, address, x, y, placeType, description, visitDate);
            hotplace.setImageUrl(imageUrl);
            
            // DB에 저장 (실제 구현에서는 서비스 레이어 호출)
            // hotplaceService.saveHotplace(hotplace);
            
            // 저장 성공 응답
            toJSON(Map.of("success", true, "message", "핫플레이스가 성공적으로 등록되었습니다.", "hotplaceId", 1), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "핫플레이스 등록 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void hotplaceDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int hotplaceId = Integer.parseInt(request.getParameter("hotplaceId"));
        
        try {
            // DB에서 삭제 (실제 구현에서는 서비스 레이어 호출)
            // hotplaceService.deleteHotplace(hotplaceId);
            
            // 삭제 성공 응답
            toJSON(Map.of("success", true, "message", "핫플레이스가 성공적으로 삭제되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "핫플레이스 삭제 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    // 게시판 관련 메서드
    private void boardForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "/board/community-board.jsp");
    }

    private void boardList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 요청 파라미터
        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        
        // 게시글 목록 조회 (임시 데이터)
        List<Board> boardList = new ArrayList<>();
        
        // 임시 데이터 생성
        Board board1 = new Board(1, 1, "제주도 여행 추천 코스", "제주도 3박 4일 여행 코스를 공유합니다!", 142, "2025-03-25", null);
        board1.setWriterName("여행자A");
        
        Board board2 = new Board(2, 2, "부산 해운대 맛집 추천해주세요", "다음 주에 부산 여행을 계획 중인데, 해운대 근처 맛집 추천 부탁드립니다!", 89, "2025-03-24", null);
        board2.setWriterName("맛집탐험가");
        
        boardList.add(board1);
        boardList.add(board2);
        
        // 검색 조건이 있으면 필터링 (실제 구현에서는 DB 쿼리로 처리)
        if (searchType != null && searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // 필터링 로직
        }
        
        // 페이징 처리 (임시)
        int totalItems = 10;
        int totalPages = (int) Math.ceil((double) totalItems / 5); // 페이지당 5개 항목
        
        // JSON 응답
        Map<String, Object> result = Map.of(
            "posts", boardList,
            "totalPages", totalPages,
            "currentPage", currentPage
        );
        
        toJSON(result, response);
    }

    private void boardDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int boardId = Integer.parseInt(request.getParameter("id"));
        
        // 게시글 상세 정보 조회 (임시 데이터)
        Board board = new Board(boardId, 1, "제주도 여행 추천 코스", "제주도 3박 4일 여행 코스를 공유합니다!", 143, "2025-03-25", null);
        board.setWriterName("여행자A");
        
        // 댓글 목록 (임시 데이터)
        List<Comment> comments = new ArrayList<>();
        Comment comment1 = new Comment(1, boardId, 2, "좋은 정보 감사합니다!", "2025-03-26");
        comment1.setWriterName("여행준비중");
        
        Comment comment2 = new Comment(2, boardId, 3, "한라산 등반 코스는 어떤 코스로 가셨나요?", "2025-03-26");
        comment2.setWriterName("등산러버");
        
        comments.add(comment1);
        comments.add(comment2);
        board.setComments(comments);
        
        // 로그인 사용자가 작성자인지 확인
        HttpSession session = request.getSession();
        Member loginUser = (Member) session.getAttribute("loginUser");
        boolean isWriter = loginUser != null && loginUser.getMno() == board.getMno();
        
        // JSON 응답
        Map<String, Object> result = Map.of(
            "id", board.getBoardId(),
            "title", board.getTitle(),
            "content", board.getContent(),
            "writer", board.getWriterName(),
            "date", board.getCreatedAt(),
            "views", board.getViewCount(),
            "comments", comments,
            "isWriter", isWriter
        );
        
        toJSON(result, response);
    }

    private void boardWrite(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        try {
            // 폼 데이터 가져오기
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            // 게시글 객체 생성
            Board board = new Board(loginUser.getMno(), title, content);
            
            // DB에 저장 (실제 구현에서는 서비스 레이어 호출)
            // boardService.saveBoard(board);
            
            // 저장 성공 응답
            toJSON(Map.of("success", true, "message", "게시글이 성공적으로 등록되었습니다.", "boardId", 1), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "게시글 등록 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void boardUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 폼 데이터 가져오기
            int boardId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            // DB에 업데이트 (실제 구현에서는 서비스 레이어 호출)
            // boardService.updateBoard(boardId, title, content);
            
            // 업데이트 성공 응답
            toJSON(Map.of("success", true, "message", "게시글이 성공적으로 수정되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "게시글 수정 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void boardDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int boardId = Integer.parseInt(request.getParameter("id"));
        
        try {
            // DB에서 삭제 (실제 구현에서는 서비스 레이어 호출)
            // boardService.deleteBoard(boardId);
            
            // 삭제 성공 응답
            toJSON(Map.of("success", true, "message", "게시글이 성공적으로 삭제되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "게시글 삭제 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void commentWrite(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        try {
            // 폼 데이터 가져오기
            int boardId = Integer.parseInt(request.getParameter("postId"));
            String content = request.getParameter("content");
            
            // 댓글 객체 생성
            Comment comment = new Comment(boardId, loginUser.getMno(), content);
            
            // DB에 저장 (실제 구현에서는 서비스 레이어 호출)
            // commentService.saveComment(comment);
            
            // 저장 성공 응답
            toJSON(Map.of("success", true, "message", "댓글이 성공적으로 등록되었습니다.", "commentId", 1), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "댓글 등록 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }

    private void commentDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int commentId = Integer.parseInt(request.getParameter("id"));
        
        try {
            // DB에서 삭제 (실제 구현에서는 서비스 레이어 호출)
            // commentService.deleteComment(commentId);
            
            // 삭제 성공 응답
            toJSON(Map.of("success", true, "message", "댓글이 성공적으로 삭제되었습니다."), response);
        } catch (Exception e) {
            e.printStackTrace();
            toJSON(Map.of("success", false, "message", "댓글 삭제 중 오류가 발생했습니다: " + e.getMessage()), response);
        }
    }
}