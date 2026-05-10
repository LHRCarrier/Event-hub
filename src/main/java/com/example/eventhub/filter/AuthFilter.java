package com.example.eventhub.filter;

import com.example.eventhub.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * JWT认证过滤器
 * 验证所有API请求的JWT令牌（除登录和注册接口外）
 */
@Component
public class AuthFilter implements Filter {

    private final JwtUtil jwtUtil;

    public AuthFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    /**
     * 执行过滤器逻辑
     * 特殊说明：/api/auth/login 和 /api/auth/register 路径无需认证
     * @param request 请求对象
     * @param response 响应对象
     * @param chain 过滤器链
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        String authorization = httpRequest.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            handleUnauthorized(httpRequest, httpResponse);
            return;
        }

        String token = authorization.substring(7);
        try {
            jwtUtil.validateToken(token);
            chain.doFilter(request, response);
        } catch (Exception e) {
            handleUnauthorized(httpRequest, httpResponse);
        }
    }

    /**
     * 处理未授权请求，区分API和网页请求
     * @param request HTTP请求
     * @param response HTTP响应
     */
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getServletPath();
        String acceptHeader = request.getHeader("Accept");
        String contentType = request.getHeader("Content-Type");
        
        boolean isApiRequest = path.startsWith("/api/") 
            || (acceptHeader != null && acceptHeader.contains("application/json"))
            || (contentType != null && contentType.contains("application/json"));

        if (isApiRequest) {
            sendErrorResponse(response, 401, "未授权访问");
        } else {
            String contextPath = request.getContextPath();
            String redirectUrl = contextPath + "/login.jsp";
            
            String originalUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                originalUrl += "?" + request.getQueryString();
            }
            
            if (!originalUrl.equals(contextPath + "/login.jsp") && !originalUrl.equals(contextPath + "/register.jsp")
                    && !originalUrl.equals(contextPath + "/login.html") && !originalUrl.equals(contextPath + "/register.html")) {
                request.getSession().setAttribute("redirect_url", originalUrl);
            }
            
            response.sendRedirect(redirectUrl);
        }
    }

    /**
     * 判断路径是否为公开路径（无需认证）
     * @param path 请求路径
     * @return true表示公开路径，false表示需要认证
     */
    private boolean isPublicPath(String path) {
        return path.startsWith("/api/auth/login") 
            || path.startsWith("/api/auth/register")
            || path.equals("/login.jsp")
            || path.equals("/register.jsp")
            || path.equals("/login.html")
            || path.equals("/register.html")
            || path.equals("/")
            || path.equals("/index.jsp")
            || path.startsWith("/static/")
            || path.startsWith("/swagger-ui/")
            || path.startsWith("/api-docs/")
            || path.startsWith("/v3/api-docs/")
            || path.equals("/swagger-ui.html")
            || path.equals("/doc.html")
            || path.startsWith("/knife4j/");
    }

    /**
     * 发送JSON格式的错误响应
     * @param response 响应对象
     * @param status HTTP状态码
     * @param message 错误消息
     */
    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter writer = response.getWriter();
        writer.write("{\"code\":" + status + ",\"message\":\"" + message + "\"}");
        writer.flush();
        writer.close();
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}