package com.ssafy.live.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import com.ssafy.live.exception.RecordNotFoundException;
import com.ssafy.live.model.dto.Member;
import com.ssafy.live.model.service.BasicMemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/member")
public class MemberController extends HttpServlet implements ControllerHelper {

    private static final long serialVersionUID = 1L;
    private BasicMemberService mService = BasicMemberService.getService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = preProcessing(request, response);
        switch (action) {
        case "regist-member-form" -> forward(request, response, "/member/member-regist-form.jsp");
        case "regist-member" -> registMember(request, response);
        case "login-form" -> forward(request, response, "/member/login-form.jsp");
        case "login" -> login(request, response);
        case "logout" -> logout(request, response);
        case "checkEmail" -> checkEmailDuplicate(request, response);
        default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String rememberMe = request.getParameter("remember-me");
        try {
            Member member = mService.login(email, pass);
            request.getSession().setAttribute("loginUser", member);
            if (rememberMe == null) {
                setupCookie("rememberMe", "bye", 0, null, response);
            } else {
                setupCookie("rememberMe", email, 60 * 60 * 24 * 365, null, response);
            }
            redirect(request, response, "/");
        } catch (RecordNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("alertMsg", e.getMessage());
            forward(request, response, "/member/login-form.jsp");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().invalidate();
        redirect(request, response, "/");
    }

    private void registMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            Member member = new Member(name, email, password);
            mService.registMember(member);
            String message = "등록되었습니다. 로그인 후 사용해주세요.";
            HttpSession session = request.getSession();
            session.setAttribute("alertMsg", message);
            redirect(request, response, "/");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            forward(request, response, "/member/member-regist-form.jsp");
        }
    }

    private void checkEmailDuplicate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: 01-03. 전달된 email이 중복되지 않았는지 JSON으로 반환하는 메서드를 작성하세요.
        try {
            String email = request.getParameter("email");
            Member selected = mService.selectDetail(email);
            Map<String, Boolean> result = Map.of("canUse", selected == null);
            toJSON(result, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void template(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
