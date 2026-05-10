package com.bubbles.eventhub.dto.request;

/**
 * 事件更新请求数据传输对象
 * 所有字段均为可选，仅更新提供的字段
 */
public class EventUpdateRequest {

    /**
     * 事件名称
     */
    private String name;

    /**
     * 事件日期时间，格式：yyyy-MM-dd HH:mm
     */
    private String date;

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

    public EventUpdateRequest() {}

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
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
}