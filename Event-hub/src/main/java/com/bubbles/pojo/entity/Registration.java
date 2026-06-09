package com.bubbles.pojo.entity;

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

    /**
     * 报名来源：WEB-网站 APP-手机APP WECHAT-微信
     */
    private String source;

    /**
     * 签到码
     */
    private String checkinCode;

    /**
     * 签到时间
     */
    private Date checkinTime;

    /**
     * 取消时间
     */
    private Date cancelTime;

    /**
     * 取消原因
     */
    private String cancelReason;

    /**
     * 备注信息
     */
    private String remark;

    /**
     * 事件名称（扩展属性，用于关联查询）
     */
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String eventName;

    /**
     * 事件日期（扩展属性，用于关联查询）
     */
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private Date eventDate;

    /**
     * 用户名（扩展属性，用于关联查询）
     */
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String username;

    /**
     * 用户邮箱（扩展属性，用于关联查询）
     */
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String email;

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

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getCheckinCode() {
        return checkinCode;
    }

    public void setCheckinCode(String checkinCode) {
        this.checkinCode = checkinCode;
    }

    public Date getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(Date checkinTime) {
        this.checkinTime = checkinTime;
    }

    public Date getCancelTime() {
        return cancelTime;
    }

    public void setCancelTime(Date cancelTime) {
        this.cancelTime = cancelTime;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
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
}