package com.bubbles.server.controller.admin;

import com.bubbles.pojo.dto.response.*;
import com.bubbles.server.service.DashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/dashboard")
@Tag(name = "Admin Dashboard API", description = "System statistics and overview (admin only)")
public class AdminDashboardController {

    private final DashboardService dashboardService;

    public AdminDashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/stats")
    @Operation(summary = "Get Stats", description = "Get dashboard statistics including users, events, registrations (admin only)")
    public ResponseEntity<ApiResponse<DashboardStatsResponse>> getStats() {
        DashboardStatsResponse response = dashboardService.getStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/registration-stats")
    @Operation(summary = "Get Registration Stats", description = "Get event registration statistics for dashboard (admin only)")
    public ResponseEntity<ApiResponse<List<EventResponse>>> getRegistrationStats() {
        List<EventResponse> response = dashboardService.getRegistrationStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/chart-data")
    @Operation(summary = "Get Chart Data", description = "Get all dashboard chart data including trends, categories, community activity, registration status and recent activities")
    public ResponseEntity<ApiResponse<DashboardChartDataResponse>> getChartData() {
        DashboardChartDataResponse response = new DashboardChartDataResponse();
        response.setTrendData(dashboardService.getTrendData());
        response.setCategoryStats(dashboardService.getCategoryStats());
        response.setCommunityStats(dashboardService.getCommunityStats());
        response.setStatusStats(dashboardService.getRegistrationStatusStats());
        response.setRecentActivities(dashboardService.getRecentActivities());
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
