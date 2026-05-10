package com.bubbles.eventhub.dto.response;

import java.util.Date;

/**
 * 事件响应数据传输对象
 */
public class EventResponse {

    /**
     * 事件ID
     */
    private Integer eventId;

    /**
     * 事件名称
     */
    private String name;

    /**
     * 事件日期时间
     */
    private Date date;

    /**
     * 事件地点
     */
    private String location;

    /**
     * 事件描述
     */
    private String description;

    /**
     * 分类ID
     */
    private Integer categoryId;

    /**
     * 分类名称
     */
    private String categoryName;

    /**
     * 事件状态
     */
    private String status;

    /**
     * 已报名参与人数
     */
    private Integer participantCount;

    /**
     * 创建时间
     */
    private Date createTime;

    public EventResponse() {}

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getParticipantCount() {
        return participantCount;
    }

    public void setParticipantCount(Integer participantCount) {
        this.participantCount = participantCount;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}