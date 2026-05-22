package com.bubbles.server.controller.admin;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.DashboardStatsResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.server.service.DashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/dashboard")
@Tag(name = "管理仪表盘接口", description = "系统统计数据和概览信息（仅管理员）")
public class AdminDashboardController {

    private final DashboardService dashboardService;

    public AdminDashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/stats")
    @Operation(summary = "获取统计数据", description = "获取仪表盘统计数据，包括用户数、事件数、注册数等核心指标（仅管理员）")
    public ResponseEntity<ApiResponse<DashboardStatsResponse>> getStats() {
        DashboardStatsResponse response = dashboardService.getStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/registration-stats")
    @Operation(summary = "获取注册统计", description = "获取事件注册统计数据，用于仪表盘展示（仅管理员）")
    public ResponseEntity<ApiResponse<List<EventResponse>>> getRegistrationStats() {
        List<EventResponse> response = dashboardService.getRegistrationStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
