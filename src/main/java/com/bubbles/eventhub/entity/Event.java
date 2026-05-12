package com.bubbles.eventhub.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

/**
 * 事件实体类
 * 对应数据库中的events表
 */
@TableName("events")
public class Event {

    /**
     * 事件ID，自增主键
     */
    @TableId(value = "event_id", type = IdType.AUTO)
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
     * 分类ID，外键关联categories表
     */
    private Integer categoryId;

    /**
     * 社区ID，外键关联communities表
     */
    private Integer communityId;

    /**
     * 事件状态，如：UPCOMING（即将到来）、PAST（已结束）
     */
    private String status;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    public Event() {}

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

    public Integer getCommunityId() {
        return communityId;
    }

    public void setCommunityId(Integer communityId) {
        this.communityId = communityId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}