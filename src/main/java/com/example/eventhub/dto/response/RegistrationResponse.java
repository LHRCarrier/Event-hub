package com.example.eventhub.dto.response;

import java.util.Date;

/**
 * 注册记录响应数据传输对象
 */
public class RegistrationResponse {

    /**
     * 注册记录ID
     */
    private Integer registrationId;

    /**
     * 事件ID
     */
    private Integer eventId;

    /**
     * 事件名称
     */
    private String eventName;

    /**
     * 事件日期
     */
    private Date date;

    /**
     * 事件地点
     */
    private String location;

    /**
     * 注册时间
     */
    private Date registerTime;

    public RegistrationResponse() {}

    public Integer getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Integer registrationId) {
        this.registrationId = registrationId;
    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(Date registerTime) {
        this.registerTime = registerTime;
    }
}