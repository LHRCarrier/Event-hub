package com.bubbles.pojo.dto.response;

/**
 * 登录响应数据传输对象
 */
public class LoginResponse {

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 用户名
     */
    private String username;

    /**
     * 用户角色
     */
    private String role;

    /**
     * JWT令牌
     */
    private String token;

    /**
     * 用户头像URL
     */
    private String avatarUrl;

    public LoginResponse() {}

    public LoginResponse(Integer userId, String username, String role, String token, String avatarUrl) {
        this.userId = userId;
        this.username = username;
        this.role = role;
        this.token = token;
        this.avatarUrl = avatarUrl;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}