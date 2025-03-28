package com.ssafy.live.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/tourism")
public class TourismController extends HttpServlet implements ControllerHelper {

    private static final long serialVersionUID = 1L;
    private final String serviceKey = "YOUR_SERVICE_KEY"; // 실제 서비스키로 교체 필요

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = preProcessing(request, response);
        
        switch (action) {
            case "area-based-list" -> getAreaBasedList(request, response);
            case "content-type-list" -> getContentTypeList(request, response);
            case "detail-common" -> getDetailCommon(request, response);
            case "detail-info" -> getDetailInfo(request, response);
            case "detail-image" -> getDetailImage(request, response);
            default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 지역기반 관광정보 조회
     */
    private void getAreaBasedList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 요청 파라미터 받기
            String areaCode = request.getParameter("areaCode"); // 지역코드
            String sigunguCode = request.getParameter("sigunguCode"); // 시군구코드
            String contentTypeId = request.getParameter("contentTypeId"); // 관광타입 ID
            String pageNo = request.getParameter("pageNo") != null ? request.getParameter("pageNo") : "1"; // 페이지 번호
            
            // API 호출용 URL 생성
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); // 한 페이지 결과 개수
            urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode(pageNo, "UTF-8")); // 페이지 번호
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); // OS 구분
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8")); // 서비스명
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); // 응답 포맷
            
            // 선택적 파라미터 추가
            if (areaCode != null && !areaCode.isEmpty()) {
                urlBuilder.append("&" + URLEncoder.encode("areaCode", "UTF-8") + "=" + URLEncoder.encode(areaCode, "UTF-8"));
            }
            if (sigunguCode != null && !sigunguCode.isEmpty()) {
                urlBuilder.append("&" + URLEncoder.encode("sigunguCode", "UTF-8") + "=" + URLEncoder.encode(sigunguCode, "UTF-8"));
            }
            if (contentTypeId != null && !contentTypeId.isEmpty()) {
                urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode(contentTypeId, "UTF-8"));
            }
            
            // API 호출 및 결과 처리
            String result = callExternalApi(urlBuilder.toString());
            toJSON(parseApiResponse(result), response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 관광타입별 관광정보 조회
     */
    private void getContentTypeList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 요청 파라미터 받기
            String contentTypeId = request.getParameter("contentTypeId"); // 관광타입 ID
            String areaCode = request.getParameter("areaCode"); // 지역코드
            String sigunguCode = request.getParameter("sigunguCode"); // 시군구코드
            String pageNo = request.getParameter("pageNo") != null ? request.getParameter("pageNo") : "1"; // 페이지 번호
            
            // API 호출용 URL 생성
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); // 한 페이지 결과 개수
            urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode(pageNo, "UTF-8")); // 페이지 번호
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); // OS 구분
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8")); // 서비스명
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); // 응답 포맷
            urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode(contentTypeId, "UTF-8")); // 필수 관광타입
            
            // 선택적 파라미터 추가
            if (areaCode != null && !areaCode.isEmpty()) {
                urlBuilder.append("&" + URLEncoder.encode("areaCode", "UTF-8") + "=" + URLEncoder.encode(areaCode, "UTF-8"));
            }
            if (sigunguCode != null && !sigunguCode.isEmpty()) {
                urlBuilder.append("&" + URLEncoder.encode("sigunguCode", "UTF-8") + "=" + URLEncoder.encode(sigunguCode, "UTF-8"));
            }
            
            // API 호출 및 결과 처리
            String result = callExternalApi(urlBuilder.toString());
            toJSON(parseApiResponse(result), response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 공통정보 조회
     */
    private void getDetailCommon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 요청 파라미터 받기
            String contentId = request.getParameter("contentId"); // 콘텐츠 ID
            
            // 파라미터 검증
            if (contentId == null || contentId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "콘텐츠 ID는 필수입니다.");
                return;
            }
            
            // API 호출용 URL 생성
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailCommon1");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); // OS 구분
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8")); // 서비스명
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); // 응답 포맷
            urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); // 콘텐츠 ID
            urlBuilder.append("&" + URLEncoder.encode("defaultYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 기본정보 포함 여부
            urlBuilder.append("&" + URLEncoder.encode("firstImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 대표이미지 포함 여부
            urlBuilder.append("&" + URLEncoder.encode("areacodeYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 지역코드 포함 여부
            urlBuilder.append("&" + URLEncoder.encode("addrinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 주소 포함 여부
            urlBuilder.append("&" + URLEncoder.encode("mapinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 좌표 포함 여부
            urlBuilder.append("&" + URLEncoder.encode("overviewYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 개요 포함 여부
            
            // API 호출 및 결과 처리
            String result = callExternalApi(urlBuilder.toString());
            toJSON(parseApiResponse(result), response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 소개정보 조회
     */
    private void getDetailInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 요청 파라미터 받기
            String contentId = request.getParameter("contentId"); // 콘텐츠 ID
            String contentTypeId = request.getParameter("contentTypeId"); // 관광타입 ID
            
            // 파라미터 검증
            if (contentId == null || contentId.isEmpty() || contentTypeId == null || contentTypeId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "콘텐츠 ID와 콘텐츠 타입 ID는 필수입니다.");
                return;
            }
            
            // API 호출용 URL 생성
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailIntro1");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); // OS 구분
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8")); // 서비스명
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); // 응답 포맷
            urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); // 콘텐츠 ID
            urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode(contentTypeId, "UTF-8")); // 콘텐츠 타입 ID
            
            // API 호출 및 결과 처리
            String result = callExternalApi(urlBuilder.toString());
            toJSON(parseApiResponse(result), response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 이미지정보 조회
     */
    private void getDetailImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 요청 파라미터 받기
            String contentId = request.getParameter("contentId"); // 콘텐츠 ID
            
            // 파라미터 검증
            if (contentId == null || contentId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "콘텐츠 ID는 필수입니다.");
                return;
            }
            
            // API 호출용 URL 생성
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailImage1");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); // OS 구분
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8")); // 서비스명
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); // 응답 포맷
            urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "=" + URLEncoder.encode(contentId, "UTF-8")); // 콘텐츠 ID
            urlBuilder.append("&" + URLEncoder.encode("imageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 이미지 조회 여부
            urlBuilder.append("&" + URLEncoder.encode("subImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 서브이미지 조회 여부
            
            // API 호출 및 결과 처리
            String result = callExternalApi(urlBuilder.toString());
            toJSON(parseApiResponse(result), response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 외부 API 호출 메서드
     */
    private String callExternalApi(String apiUrl) throws IOException {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        
        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }
        
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        
        return sb.toString();
    }

    /**
     * API 응답 파싱 메서드
     */
    private List<Map<String, Object>> parseApiResponse(String jsonStr) throws IOException {
        List<Map<String, Object>> resultList = new ArrayList<>();
        
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(jsonStr);
        
        // response -> body -> items -> item 접근
        JsonNode response = rootNode.path("response");
        JsonNode body = response.path("body");
        JsonNode items = body.path("items");
        JsonNode item = items.path("item");
        
        // item이 배열인 경우
        if (item.isArray()) {
            for (JsonNode node : item) {
                Map<String, Object> itemMap = new HashMap<>();
                node.fields().forEachRemaining(entry -> {
                    itemMap.put(entry.getKey(), entry.getValue().asText());
                });
                resultList.add(itemMap);
            }
        } 
        // item이 단일 객체인 경우
        else if (item.isObject()) {
            Map<String, Object> itemMap = new HashMap<>();
            item.fields().forEachRemaining(entry -> {
                itemMap.put(entry.getKey(), entry.getValue().asText());
            });
            resultList.add(itemMap);
        }
        
        return resultList;
    }
}