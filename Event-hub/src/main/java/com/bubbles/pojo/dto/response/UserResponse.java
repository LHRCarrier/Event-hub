package com.bubbles.pojo.dto.response;

import java.util.Date;

/**
 * 用户响应数据传输对象
 */
public class UserResponse {

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 用户名
     */
    private String username;

    /**
     * 邮箱地址
     */
    private String email;

    /**
     * 电话号码
     */
    private String phone;

    /**
     * 真实姓名
     */
    private String realName;

    /**
     * 用户角色
     */
    private String role;

    /**
     * 用户状态，如：ACTIVE、INACTIVE
     */
    private String status;

    /**
     * 用户头像URL
     */
    private String avatarUrl;

    /**
     * 创建时间
     */
    private Date createTime;

    public UserResponse() {}

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}