package com.bubbles.server.service;

import com.bubbles.pojo.dto.response.DashboardStatsResponse;
import com.bubbles.pojo.dto.response.EventResponse;

import java.util.List;

/**
 * 仪表盘服务接口
 * 提供仪表盘统计数据和图表展示所需的数据
 */
public interface DashboardService {

    /**
     * 获取仪表盘统计数据
     * 汇总系统中用户、事件、注册、分类等核心指标
     * @return 包含总用户数、总事件数、总注册数、总分类数、即将到来的事件数和活跃用户数
     */
    DashboardStatsResponse getStats();

    /**
     * 获取注册统计数据
     * 返回最近的事件列表及其注册情况，用于仪表盘展示
     * @return 事件列表，默认返回前10条
     */
    List<EventResponse> getRegistrationStats();
}