package com.bubbles.eventhub.interceptor;

import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.service.CommunityMemberService;
import com.bubbles.eventhub.util.JwtUtil;
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
 * 社区权限拦截器
 * 拦截社区级API请求，验证用户是否为社区成员
 */
@Component
public class CommunityPermissionInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(CommunityPermissionInterceptor.class);

    private final JwtUtil jwtUtil;
    private final CommunityMemberService memberService;
    private final ObjectMapper objectMapper;

    public CommunityPermissionInterceptor(JwtUtil jwtUtil,
                                         CommunityMemberService memberService,
                                         ObjectMapper objectMapper) {
        this.jwtUtil = jwtUtil;
        this.memberService = memberService;
        this.objectMapper = objectMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestUri = request.getRequestURI();
        
        if (!requestUri.startsWith("/api/c/")) {
            return true;
        }

        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "未登录");
            return false;
        }

        String token = authorization.substring(7);
        Integer userId = null;
        try {
            userId = jwtUtil.getUserIdFromToken(token);
        } catch (Exception e) {
            logger.warn("无效的JWT token: {}", e.getMessage());
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "token无效");
            return false;
        }

        if (userId == null) {
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "用户未登录");
            return false;
        }

        String[] parts = requestUri.split("/");
        if (parts.length < 4) {
            sendErrorResponse(response, HttpStatus.BAD_REQUEST, "无效的请求路径");
            return false;
        }

        Integer communityId;
        try {
            communityId = Integer.parseInt(parts[3]);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, HttpStatus.BAD_REQUEST, "无效的社区ID");
            return false;
        }

        boolean isMember = memberService.isMember(communityId, userId);
        if (!isMember) {
            logger.warn("用户 {} 试图访问非成员社区 {}", userId, communityId);
            sendErrorResponse(response, HttpStatus.FORBIDDEN, "您不是该社区成员");
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