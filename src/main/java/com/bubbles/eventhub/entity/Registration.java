package com.bubbles.eventhub.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

/**
 * 注册记录实体类
 * 对应数据库中的registrations表，记录用户对事件的报名信息
 */
@TableName("registrations")
public class Registration {

    /**
     * 注册记录ID，自增主键
     */
    @TableId(value = "registration_id", type = IdType.AUTO)
    private Integer registrationId;

    /**
     * 事件ID，外键关联events表
     */
    private Integer eventId;

    /**
     * 用户ID，外键关联users表
     */
    private Integer userId;

    /**
     * 注册状态，如：REGISTERED（已注册）
     */
    private String status;

    /**
     * 注册时间
     */
    private Date registerTime;

    public Registration() {}

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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(Date registerTime) {
        this.registerTime = registerTime;
    }
}