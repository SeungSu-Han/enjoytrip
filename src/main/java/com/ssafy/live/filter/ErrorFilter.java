package com.ssafy.live.filter;

import java.io.IOException;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter(dispatcherTypes = { DispatcherType.ERROR }, urlPatterns = { "/*" })

@SuppressWarnings("serial")
public class ErrorFilter extends HttpFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;

        //        Enumeration<String> enums = req.getAttributeNames();
        //        while (enums.hasMoreElements()) {
        //            String attr = enums.nextElement();
        //            System.out.println(attr + " : " + req.getAttribute(attr));
        //        }

        // 에러 로깅
        System.out.println("-------------------- Error Filter에 의한 감시 --------------------");
        System.out.println("Request URI: " + req.getAttribute("jakarta.servlet.error.request_uri"));
        System.out.println("Query String: " + req.getAttribute("jakarta.servlet.error.query_string"));
        System.out.println("Status Code: " + req.getAttribute("jakarta.servlet.error.status_code"));
        System.out.println("Exception: " + req.getAttribute("jakarta.servlet.error.exception"));
        System.out.println("--------------------------------------------------------");
        chain.doFilter(request, response);

    }
}
