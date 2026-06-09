package com.bubbles.server.service;

import com.bubbles.pojo.dto.response.*;

import java.util.List;

public interface DashboardService {

    DashboardStatsResponse getStats();

    List<EventResponse> getRegistrationStats();

    List<TrendDataResponse> getTrendData();

    List<CategoryStatResponse> getCategoryStats();

    List<CommunityStatResponse> getCommunityStats();

    List<RegistrationStatusStatResponse> getRegistrationStatusStats();

    List<RecentActivityResponse> getRecentActivities();
}