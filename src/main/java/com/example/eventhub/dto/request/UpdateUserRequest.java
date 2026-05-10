package com.example.eventhub.dto.request;

/**
 * 用户更新请求数据传输对象
 * 所有字段均为可选，仅更新提供的字段
 */
public class UpdateUserRequest {

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

    public UpdateUserRequest() {}

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
}