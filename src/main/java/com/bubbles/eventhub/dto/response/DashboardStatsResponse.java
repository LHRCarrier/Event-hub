package com.bubbles.eventhub.dto.response;

/**
 * 仪表盘统计数据响应数据传输对象
 */
public class DashboardStatsResponse {

    /**
     * 总用户数
     */
    private Integer totalUsers;

    /**
     * 总事件数
     */
    private Integer totalEvents;

    /**
     * 总注册数
     */
    private Integer totalRegistrations;

    /**
     * 总分类数
     */
    private Integer totalCategories;

    /**
     * 即将到来的事件数
     */
    private Integer upcomingEvents;

    /**
     * 活跃用户数
     */
    private Integer activeUsers;

    public DashboardStatsResponse() {}

    public Integer getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(Integer totalUsers) {
        this.totalUsers = totalUsers;
    }

    public Integer getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(Integer totalEvents) {
        this.totalEvents = totalEvents;
    }

    public Integer getTotalRegistrations() {
        return totalRegistrations;
    }

    public void setTotalRegistrations(Integer totalRegistrations) {
        this.totalRegistrations = totalRegistrations;
    }

    public Integer getTotalCategories() {
        return totalCategories;
    }

    public void setTotalCategories(Integer totalCategories) {
        this.totalCategories = totalCategories;
    }

    public Integer getUpcomingEvents() {
        return upcomingEvents;
    }

    public void setUpcomingEvents(Integer upcomingEvents) {
        this.upcomingEvents = upcomingEvents;
    }

    public Integer getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(Integer activeUsers) {
        this.activeUsers = activeUsers;
    }
}