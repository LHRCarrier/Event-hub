package com.bubbles.pojo.dto.response;

import java.util.List;

public class DashboardChartDataResponse {
    private List<TrendDataResponse> trendData;
    private List<CategoryStatResponse> categoryStats;
    private List<CommunityStatResponse> communityStats;
    private List<RegistrationStatusStatResponse> statusStats;
    private List<RecentActivityResponse> recentActivities;

    public List<TrendDataResponse> getTrendData() { return trendData; }
    public void setTrendData(List<TrendDataResponse> trendData) { this.trendData = trendData; }
    public List<CategoryStatResponse> getCategoryStats() { return categoryStats; }
    public void setCategoryStats(List<CategoryStatResponse> categoryStats) { this.categoryStats = categoryStats; }
    public List<CommunityStatResponse> getCommunityStats() { return communityStats; }
    public void setCommunityStats(List<CommunityStatResponse> communityStats) { this.communityStats = communityStats; }
    public List<RegistrationStatusStatResponse> getStatusStats() { return statusStats; }
    public void setStatusStats(List<RegistrationStatusStatResponse> statusStats) { this.statusStats = statusStats; }
    public List<RecentActivityResponse> getRecentActivities() { return recentActivities; }
    public void setRecentActivities(List<RecentActivityResponse> recentActivities) { this.recentActivities = recentActivities; }
}
