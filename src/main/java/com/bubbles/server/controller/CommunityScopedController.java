package com.bubbles.server.controller;

import com.bubbles.pojo.dto.request.CategoryCreateRequest;
import com.bubbles.pojo.dto.request.EventCreateRequest;
import com.bubbles.pojo.dto.request.EventUpdateRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CategoryResponse;
import com.bubbles.pojo.dto.response.CommunityMemberResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.pojo.dto.response.RegistrationResponse;
import com.bubbles.server.service.*;
import com.bubbles.common.utils.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 社区级API控制器
 * 所有接口需要社区成员身份访问
 */
@RestController
@RequestMapping("/api/c/{communityId}")
@Tag(name = "社区级API", description = "社区专属功能接口")
public class CommunityScopedController {

    private final CommunityService communityService;
    private final CommunityMemberService memberService;
    private final EventService eventService;
    private final RegistrationService registrationService;
    private final CommunityPermissionService permissionService;
    private final CategoryService categoryService;
    private final UserService userService;
    private final JwtUtil jwtUtil;

    public CommunityScopedController(CommunityService communityService,
                                   CommunityMemberService memberService,
                                   EventService eventService,
                                   RegistrationService registrationService,
                                   CommunityPermissionService permissionService,
                                   CategoryService categoryService,
                                   UserService userService,
                                   JwtUtil jwtUtil) {
        this.communityService = communityService;
        this.memberService = memberService;
        this.eventService = eventService;
        this.registrationService = registrationService;
        this.permissionService = permissionService;
        this.categoryService = categoryService;
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }

    @GetMapping("/home")
    @Operation(summary = "社区首页", description = "获取社区首页数据")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCommunityHome(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }

        Map<String, Object> data = new HashMap<>();
        data.put("community", communityService.getCommunityById(communityId));
        data.put("events", eventService.getEventsByCommunity(communityId, 1, 5).getList());
        data.put("role", memberService.getMemberRole(communityId, userId));

        Map<String, Object> stats = new HashMap<>();
        stats.put("memberCount", memberService.countUserCommunities(communityId));
        stats.put("eventCount", communityService.countEvents(communityId));
        stats.put("upcomingEvents", eventService.getUpcomingEventsByCommunity(communityId).size());
        data.put("stats", stats);

        data.put("recentMembers", memberService.getRecentMembers(communityId, 5));

        if (memberService.isAdmin(communityId, userId)) {
            data.put("pendingApplications", memberService.countPendingApplications(communityId));
        }

        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping("/events")
    @Operation(summary = "社区活动列表", description = "获取社区活动列表")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getCommunityEvents(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }

        PageResponse<EventResponse> response = eventService.getEventsByCommunity(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/events")
    @Operation(summary = "创建社区活动", description = "创建社区活动（仅管理员）")
    public ResponseEntity<ApiResponse<EventResponse>> createCommunityEvent(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Valid @RequestBody EventCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限创建活动"));
        }

        request.setCommunityId(communityId);
        EventResponse response = eventService.createEvent(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    @GetMapping("/events/{eventId}")
    @Operation(summary = "活动详情", description = "获取社区活动详情")
    public ResponseEntity<ApiResponse<EventResponse>> getEventDetail(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "活动ID") @PathVariable(name = "eventId") Integer eventId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }

        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/events/{eventId}")
    @Operation(summary = "更新活动", description = "更新社区活动（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateCommunityEvent(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "活动ID") @PathVariable(name = "eventId") Integer eventId,
            @RequestBody EventUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限更新活动"));
        }

        eventService.updateEvent(eventId, request, userId);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/events/{eventId}")
    @Operation(summary = "删除活动", description = "删除社区活动（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> deleteCommunityEvent(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "活动ID") @PathVariable(name = "eventId") Integer eventId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限删除活动"));
        }

        eventService.deleteEvent(eventId, userId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }

    @GetMapping("/registrations")
    @Operation(summary = "我的注册记录", description = "获取用户在社区的活动注册记录")
    public ResponseEntity<ApiResponse<List<RegistrationResponse>>> getMyRegistrations(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }

        List<RegistrationResponse> registrations = registrationService.getUserRegistrations(userId).stream()
                .filter(r -> {
                    Integer eventCommunityId = eventService.getEventById(r.getEventId()).getCommunityId();
                    return communityId.equals(eventCommunityId) || eventCommunityId == null;
                })
                .toList();

        return ResponseEntity.ok(ApiResponse.success(registrations));
    }

    @GetMapping("/members")
    @Operation(summary = "社区成员列表", description = "获取社区成员列表")
    public ResponseEntity<ApiResponse<PageResponse<CommunityMemberResponse>>> getCommunityMembers(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }

        PageResponse<CommunityMemberResponse> response = memberService.getCommunityMembers(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/dashboard/stats")
    @Operation(summary = "社区统计", description = "获取社区统计数据（社区管理员或系统管理员）")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCommunityStats(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        boolean isCommunityAdmin = memberService.isAdmin(communityId, userId);
        boolean isSystemAdmin = "ADMIN".equals(userService.getUserRole(userId));
        if (!isCommunityAdmin && !isSystemAdmin) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看统计数据"));
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("memberCount", memberService.countUserCommunities(communityId));
        stats.put("eventCount", communityService.countEvents(communityId));
        stats.put("upcomingEvents", eventService.getUpcomingEventsByCommunity(communityId).size());

        return ResponseEntity.ok(ApiResponse.success(stats));
    }

    @GetMapping("/categories")
    @Operation(summary = "获取社区分类列表", description = "获取社区关联的分类列表")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getCommunityCategories(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限访问该社区"));
        }
        List<CategoryResponse> categories = categoryService.getCategoriesByCommunity(communityId);
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @PostMapping("/categories")
    @Operation(summary = "创建社区分类", description = "创建社区专属分类（仅管理员）")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCommunityCategory(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody CategoryCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限创建分类"));
        }
        CategoryResponse category = categoryService.createCommunityCategory(communityId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("分类创建成功", category));
    }

    private Integer getCurrentUserId(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            String token = authorization.substring(7);
            return jwtUtil.getUserIdFromToken(token);
        }
        return null;
    }
}