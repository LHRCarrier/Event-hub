package com.bubbles.server.service;

import com.bubbles.pojo.dto.request.LoginRequest;
import com.bubbles.pojo.dto.request.RegisterRequest;
import com.bubbles.pojo.dto.response.LoginResponse;

/**
 * 认证服务接口
 * 提供用户登录和注册功能
 */
public interface AuthService {

    /**
     * 用户登录
     * @param request 登录请求参数，包含用户名和密码
     * @return 登录成功返回用户信息和JWT令牌
     * @throws BusinessException 用户名或密码错误时抛出异常
     */
    LoginResponse login(LoginRequest request);

    /**
     * 用户注册
     * @param request 注册请求参数，包含用户名、密码、邮箱等
     * @throws BusinessException 用户名已存在或邮箱已被注册时抛出异常
     */
    void register(RegisterRequest request);
}