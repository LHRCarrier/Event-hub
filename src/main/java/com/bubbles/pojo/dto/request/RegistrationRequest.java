package com.bubbles.pojo.dto.request;

/**
 * 事件注册请求数据传输对象
 */
public class RegistrationRequest {

    /**
     * 事件ID
     */
    private Integer eventId;

    /**
     * 用户ID
     */
    private Integer userId;

    public RegistrationRequest() {}

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}