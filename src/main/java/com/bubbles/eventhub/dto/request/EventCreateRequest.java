package com.bubbles.eventhub.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 事件创建请求数据传输对象
 */
public class EventCreateRequest {

    /**
     * 事件名称，最大长度100个字符
     */
    @NotBlank(message = "事件名称不能为空")
    @Size(max = 100, message = "事件名称长度不能超过100个字符")
    private String name;

    /**
     * 事件日期时间，格式：yyyy-MM-dd HH:mm
     */
    @NotBlank(message = "事件日期不能为空")
    private String date;

    /**
     * 事件地点，最大长度200个字符
     */
    @NotBlank(message = "事件地点不能为空")
    @Size(max = 200, message = "事件地点长度不能超过200个字符")
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
     * 社区ID
     */
    private Integer communityId;

    public EventCreateRequest() {}

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

    public Integer getCommunityId() {
        return communityId;
    }

    public void setCommunityId(Integer communityId) {
        this.communityId = communityId;
    }
}