package com.bubbles.pojo.dto.request;

import jakarta.validation.constraints.Size;

/**
 * 社区加入申请请求DTO
 */
public class CommunityApplyRequest {

    @Size(max = 255, message = "申请留言不能超过255个字符")
    private String message;

    public CommunityApplyRequest() {}

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}