package com.bubbles.server.service.impl;

import com.bubbles.pojo.dto.response.DashboardStatsResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.server.service.CategoryService;
import com.bubbles.server.service.DashboardService;
import com.bubbles.server.service.EventService;
import com.bubbles.server.service.RegistrationService;
import com.bubbles.server.service.UserService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 仪表盘服务实现类
 * 负责聚合各个服务的数据，提供仪表盘展示所需的统计数据
 */
@Service
public class DashboardServiceImpl implements DashboardService {

    private final UserService userService;
    private final EventService eventService;
    private final RegistrationService registrationService;
    private final CategoryService categoryService;

    public DashboardServiceImpl(UserService userService, EventService eventService,
                               RegistrationService registrationService, CategoryService categoryService) {
        this.userService = userService;
        this.eventService = eventService;
        this.registrationService = registrationService;
        this.categoryService = categoryService;
    }

    /**
     * 获取仪表盘统计数据
     * 特殊说明：通过调用各个服务层的统计方法，聚合系统中用户、事件、注册、分类等核心指标
     * @return 包含总用户数、总事件数、总注册数、总分类数、即将到来的事件数和活跃用户数的统计对象
     */
    @Override
    public DashboardStatsResponse getStats() {
        DashboardStatsResponse stats = new DashboardStatsResponse();
        stats.setTotalUsers(userService.getTotalUsers());
        stats.setTotalEvents(eventService.getTotalEvents());
        stats.setTotalRegistrations(registrationService.getTotalRegistrations());
        stats.setTotalCategories(categoryService.getTotalCategories());
        stats.setUpcomingEvents(eventService.getUpcomingEvents());
        stats.setActiveUsers(userService.getActiveUsers());
        return stats;
    }

    /**
     * 获取注册统计数据
     * 返回最近的事件列表及其注册情况，用于仪表盘展示
     * @return 事件列表，默认返回前10条
     */
    @Override
    public List<EventResponse> getRegistrationStats() {
        return eventService.getEvents(1, 10, "", null, "ALL").getList();
    }
}