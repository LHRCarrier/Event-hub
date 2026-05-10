package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.DashboardStatsResponse;
import com.bubbles.eventhub.dto.response.EventResponse;
import com.bubbles.eventhub.service.DashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
@Tag(name = "仪表盘接口", description = "系统统计数据和概览信息")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    /**
     * 获取仪表盘统计数据
     * 统计系统中用户、事件、注册、分类等核心指标的汇总数据
     * @return 包含总用户数、总事件数、总注册数、总分类数、即将到来的事件数和活跃用户数
     */
    @GetMapping("/stats")
    @Operation(summary = "获取统计数据", description = "获取仪表盘统计数据，包括用户数、事件数、注册数等核心指标")
    public ResponseEntity<ApiResponse<DashboardStatsResponse>> getStats() {
        DashboardStatsResponse response = dashboardService.getStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 获取注册统计数据
     * 返回最近的事件列表及其注册情况，用于仪表盘展示
     * @return 事件列表，默认返回前10条
     */
    @GetMapping("/registration-stats")
    @Operation(summary = "获取注册统计", description = "获取事件注册统计数据，用于仪表盘展示")
    public ResponseEntity<ApiResponse<List<EventResponse>>> getRegistrationStats() {
        List<EventResponse> response = dashboardService.getRegistrationStats();
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}