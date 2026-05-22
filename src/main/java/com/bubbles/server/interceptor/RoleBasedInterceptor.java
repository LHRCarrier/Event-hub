package com.bubbles.server.interceptor;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.common.utils.JwtUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 基于角色的权限拦截器
 * 拦截 /api/admin/ 开头的请求，验证用户是否为管理员
 */
@Component
public class RoleBasedInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(RoleBasedInterceptor.class);

    private final JwtUtil jwtUtil;
    private final ObjectMapper objectMapper;

    public RoleBasedInterceptor(JwtUtil jwtUtil, ObjectMapper objectMapper) {
        this.jwtUtil = jwtUtil;
        this.objectMapper = objectMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestUri = request.getRequestURI();
        
        // 只处理 /api/admin/ 开头的请求
        if (!requestUri.startsWith("/api/admin/")) {
            return true;
        }

        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "未登录");
            return false;
        }

        String token = authorization.substring(7);
        String userRole = null;
        try {
            userRole = jwtUtil.getRoleFromToken(token);
        } catch (Exception e) {
            logger.warn("无效的JWT token: {}", e.getMessage());
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "token无效");
            return false;
        }

        if (!"ADMIN".equals(userRole)) {
            logger.warn("非管理员用户试图访问管理接口");
            sendErrorResponse(response, HttpStatus.FORBIDDEN, "无权访问管理接口");
            return false;
        }

        return true;
    }

    private void sendErrorResponse(HttpServletResponse response, HttpStatus status, String message) throws Exception {
        response.setStatus(status.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        
        ApiResponse<Void> apiResponse = ApiResponse.error(status.value(), message);
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }
}
