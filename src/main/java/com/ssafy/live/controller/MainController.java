package com.ssafy.live.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.ssafy.live.model.service.BasicSimpleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/main")
public class MainController extends HttpServlet implements ControllerHelper {

    private static final long serialVersionUID = 1L;

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = preProcessing(request, response);
        switch (action) {
        case "index" -> forward(request, response, "/index.jsp");
        case "gugu-form" -> forward(request, response, "/gugu/gugu-form.jsp");
        case "gugu" -> gugu(request, response);
        case "make-cookie" -> makeCookie(request, response);
        case "check-cookie" -> forward(request, response, "/status/check-cookie.jsp");
        case "cart-form" -> forward(request, response, "/status/cart-form.jsp");
        case "add-to-cart" -> addToCart(request, response);
        case "buy" -> buy(request, response);
        case "member-problem" -> makeProblem(request, response);
        default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void makeCookie(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setupCookie("for-domain", "container_root", 60 * 10, "/", response);
        setupCookie("just-1-min", "1분-유지-쿠키", 60 * 1, null, response);
        setupCookie("status-path", URLEncoder.encode("status 경로에 저장된 쿠키", "UTF-8"), -1, "/mvc3/status", response);
        setupCookie("immediate-del", "010-1234-5678", 0, "/", response);
        //forward(request, response, "/status/check-cookie.jsp"); // forward로 했을 때의 문제점 - 응답이 내려간적이 없음
        redirect(request, response, "/main?action=check-cookie");
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<String> cart = Optional.ofNullable((List<String>) session.getAttribute("cart"))
                .orElseGet(() -> {
                    List<String> newCart = new ArrayList<>();
                    session.setAttribute("cart", newCart);
                    return newCart;
                });
        cart.add(request.getParameter("data"));
        toJSON(cart, response);
    }

    private void buy(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().removeAttribute("cart");
        toJSON(Map.of("status", "ok"), response);
    }

    private void gugu(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int dan = Integer.parseInt(request.getParameter("dan"));
            Map<String, Integer> result = BasicSimpleService.getService().getGugu(dan);
            request.setAttribute("result", result);
            Cookie resentGugu = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if (c.getName().equals("recentGugu")) {
                        resentGugu = c;
                    }
                }
            }
            if (resentGugu == null) {
                setupCookie("recentGugu", dan + "", 60 * 10, null, response);
            } else {
                String pre = resentGugu.getValue();
                System.out.println("쿠키 유효 기간: " + resentGugu.getMaxAge());
                setupCookie("recentGugu", pre + "-" + dan, 60 * 10, null, response);// 쿠키의 value로 사용할 수 있는 값 고민
            }
            forward(request, response, "/gugu/gugu-result.jsp");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("alertMsg", e.getMessage());
            forward(request, response, "/gugu/gugu-form.jsp");
        } catch (RuntimeException e) {
            e.printStackTrace();
            String query = URLEncoder.encode("구구단 " + request.getParameter("dan") + "단", "UTF-8");
            response.sendRedirect("https://www.google.com/search?q=" + query);
        }
    }

    private void makeProblem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ArithmeticException 발생
        @SuppressWarnings("unused")
        int i = 1 / 0;
        forward(request, response, "/member/member-list.jsp");
    }

    private void template(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

}
