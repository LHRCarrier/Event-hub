package com.bubbles.server.service.impl;

import com.bubbles.pojo.dto.response.*;
import com.bubbles.server.mapper.CommunityCreateApplicationMapper;
import com.bubbles.server.mapper.CommunityMapper;
import com.bubbles.server.mapper.EventMapper;
import com.bubbles.server.mapper.RegistrationMapper;
import com.bubbles.server.service.*;

import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final UserService userService;
    private final EventService eventService;
    private final RegistrationService registrationService;
    private final CategoryService categoryService;
    private final RegistrationMapper registrationMapper;
    private final EventMapper eventMapper;
    private final CommunityMapper communityMapper;
    private final CommunityCreateApplicationMapper communityCreateApplicationMapper;

    public DashboardServiceImpl(UserService userService, EventService eventService,
                               RegistrationService registrationService, CategoryService categoryService,
                               RegistrationMapper registrationMapper, EventMapper eventMapper,
                               CommunityMapper communityMapper,
                               CommunityCreateApplicationMapper communityCreateApplicationMapper) {
        this.userService = userService;
        this.eventService = eventService;
        this.registrationService = registrationService;
        this.categoryService = categoryService;
        this.registrationMapper = registrationMapper;
        this.eventMapper = eventMapper;
        this.communityMapper = communityMapper;
        this.communityCreateApplicationMapper = communityCreateApplicationMapper;
    }

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

    @Override
    public List<EventResponse> getRegistrationStats() {
        return eventService.getEvents(1, 10, "", null, "ALL").getList();
    }

    @Override
    public List<TrendDataResponse> getTrendData() {
        List<Map<String, Object>> rows = registrationMapper.countMonthlyRegistrations();
        // Fill in missing months with 0
        Map<String, Integer> dataMap = new LinkedHashMap<>();
        for (Map<String, Object> row : rows) {
            dataMap.put((String) row.get("month"), ((Number) row.get("count")).intValue());
        }
        List<TrendDataResponse> result = new ArrayList<>();
        for (int i = 11; i >= 0; i--) {
            String month = LocalDateTime.now().minusMonths(i).format(DateTimeFormatter.ofPattern("yyyy-MM"));
            result.add(new TrendDataResponse(month, dataMap.getOrDefault(month, 0)));
        }
        return result;
    }

    @Override
    public List<CategoryStatResponse> getCategoryStats() {
        List<Map<String, Object>> rows = eventMapper.countEventsByCategory();
        return rows.stream()
            .map(row -> new CategoryStatResponse(
                (String) row.get("name"),
                ((Number) row.get("count")).intValue()))
            .collect(Collectors.toList());
    }

    @Override
    public List<CommunityStatResponse> getCommunityStats() {
        List<Map<String, Object>> rows = communityMapper.findTopByMemberCount(10);
        return rows.stream()
            .map(row -> new CommunityStatResponse(
                (String) row.get("name"),
                ((Number) row.get("member_count")).intValue()))
            .collect(Collectors.toList());
    }

    @Override
    public List<RegistrationStatusStatResponse> getRegistrationStatusStats() {
        List<Map<String, Object>> rows = communityCreateApplicationMapper.countByStatus();
        return rows.stream()
            .map(row -> new RegistrationStatusStatResponse(
                (String) row.get("status"),
                ((Number) row.get("count")).intValue()))
            .collect(Collectors.toList());
    }

    @Override
    public List<RecentActivityResponse> getRecentActivities() {
        class ActivityItem {
            final RecentActivityResponse response;
            final LocalDateTime sortTime;
            ActivityItem(RecentActivityResponse r, LocalDateTime t) { response = r; sortTime = t; }
        }

        List<ActivityItem> items = new ArrayList<>();

        List<Map<String, Object>> registrations = registrationMapper.findRecentRegistrations(3);
        for (Map<String, Object> r : registrations) {
            LocalDateTime ts = (LocalDateTime) r.get("time");
            items.add(new ActivityItem(new RecentActivityResponse(
                "registration",
                "New registration",
                ((String) r.get("username")) + " registered for " + ((String) r.get("eventName")),
                formatRelativeTime(ts)
            ), ts));
        }

        List<Map<String, Object>> events = eventMapper.findRecentEvents(3);
        for (Map<String, Object> e : events) {
            LocalDateTime ts = (LocalDateTime) e.get("time");
            items.add(new ActivityItem(new RecentActivityResponse(
                "event",
                "New event created",
                (String) e.get("name"),
                formatRelativeTime(ts)
            ), ts));
        }

        List<Map<String, Object>> communities = communityMapper.findRecentCommunities(3);
        for (Map<String, Object> c : communities) {
            LocalDateTime ts = (LocalDateTime) c.get("time");
            items.add(new ActivityItem(new RecentActivityResponse(
                "community",
                "New community created",
                (String) c.get("name"),
                formatRelativeTime(ts)
            ), ts));
        }

        items.sort((a, b) -> b.sortTime.compareTo(a.sortTime));
        List<RecentActivityResponse> result = new ArrayList<>();
        for (int i = 0; i < Math.min(items.size(), 8); i++) {
            result.add(items.get(i).response);
        }
        return result;
    }

    private String formatRelativeTime(LocalDateTime then) {
        LocalDateTime now = LocalDateTime.now();
        Duration duration = Duration.between(then, now);

        if (duration.toMinutes() < 1) return "Just now";
        if (duration.toMinutes() < 60) return duration.toMinutes() + " minutes ago";
        if (duration.toHours() < 24) return duration.toHours() + " hours ago";
        return duration.toDays() + " days ago";
    }
}
