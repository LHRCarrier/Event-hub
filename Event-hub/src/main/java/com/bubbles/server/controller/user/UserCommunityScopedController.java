package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.request.CategoryCreateRequest;
import com.bubbles.pojo.dto.request.EventCreateRequest;
import com.bubbles.pojo.dto.request.EventUpdateRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CategoryResponse;
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

@RestController
@RequestMapping("/api/c/{communityId}")
@Tag(name = "Community Scoped API", description = "Community-specific functionality")
public class UserCommunityScopedController {

    private final CommunityService communityService;
    private final CommunityMemberService memberService;
    private final EventService eventService;
    private final RegistrationService registrationService;
    private final CategoryService categoryService;
    private final UserService userService;
    private final JwtUtil jwtUtil;

    public UserCommunityScopedController(CommunityService communityService,
                                         CommunityMemberService memberService,
                                         EventService eventService,
                                         RegistrationService registrationService,
                                         CategoryService categoryService,
                                         UserService userService,
                                         JwtUtil jwtUtil) {
        this.communityService = communityService;
        this.memberService = memberService;
        this.eventService = eventService;
        this.registrationService = registrationService;
        this.categoryService = categoryService;
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }

    @GetMapping("/home")
    @Operation(summary = "Community Home", description = "Get community home page data")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCommunityHome(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "You are not a member of this community"));
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
    @Operation(summary = "Community Events", description = "Get community events list")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getCommunityEvents(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "You are not a member of this community"));
        }

        PageResponse<EventResponse> response = eventService.getEventsByCommunity(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/events")
    @Operation(summary = "Create Event", description = "Create community event (admin only)")
    public ResponseEntity<ApiResponse<EventResponse>> createCommunityEvent(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Valid @RequestBody EventCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to create events"));
        }

        request.setCommunityId(communityId);
        EventResponse response = eventService.createEvent(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Creation successful", response));
    }

    @GetMapping("/events/{eventId}")
    @Operation(summary = "Event Detail", description = "Get community event details")
    public ResponseEntity<ApiResponse<EventResponse>> getEventDetail(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Event ID") @PathVariable(name = "eventId") Integer eventId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "You are not a member of this community"));
        }

        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/events/{eventId}")
    @Operation(summary = "Update Event", description = "Update community event (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateCommunityEvent(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Event ID") @PathVariable(name = "eventId") Integer eventId,
            @RequestBody EventUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to update events"));
        }

        eventService.updateEvent(eventId, request, userId);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @DeleteMapping("/events/{eventId}")
    @Operation(summary = "Delete Event", description = "Delete community event (admin only)")
    public ResponseEntity<ApiResponse<Void>> deleteCommunityEvent(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Event ID") @PathVariable(name = "eventId") Integer eventId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to delete events"));
        }

        eventService.deleteEvent(eventId, userId);
        return ResponseEntity.ok(ApiResponse.success("Deletion successful", null));
    }

    @GetMapping("/registrations")
    @Operation(summary = "My Registrations", description = "Get user's event registrations in community")
    public ResponseEntity<ApiResponse<List<RegistrationResponse>>> getMyRegistrations(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "You are not a member of this community"));
        }

        List<RegistrationResponse> registrations = registrationService.getUserRegistrations(userId).stream()
                .filter(r -> {
                    Integer eventCommunityId = eventService.getEventById(r.getEventId()).getCommunityId();
                    return communityId.equals(eventCommunityId) || eventCommunityId == null;
                })
                .toList();

        return ResponseEntity.ok(ApiResponse.success(registrations));
    }

    @GetMapping("/dashboard/stats")
    @Operation(summary = "Community Stats", description = "Get community statistics (community admin or system admin)")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getCommunityStats(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        boolean isCommunityAdmin = memberService.isAdmin(communityId, userId);
        boolean isSystemAdmin = "ADMIN".equals(userService.getUserRole(userId));
        if (!isCommunityAdmin && !isSystemAdmin) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to view statistics"));
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("memberCount", memberService.countUserCommunities(communityId));
        stats.put("eventCount", communityService.countEvents(communityId));
        stats.put("upcomingEvents", eventService.getUpcomingEventsByCommunity(communityId).size());

        return ResponseEntity.ok(ApiResponse.success(stats));
    }

    @GetMapping("/categories")
    @Operation(summary = "Get Community Categories", description = "Get categories associated with community")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getCommunityCategories(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to access this community"));
        }
        List<CategoryResponse> categories = categoryService.getCategoriesByCommunity(communityId);
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @PostMapping("/categories")
    @Operation(summary = "Create Community Category", description = "Create community-specific category (admin only)")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCommunityCategory(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody CategoryCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to create categories"));
        }
        CategoryResponse category = categoryService.createCommunityCategory(communityId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Category created successfully", category));
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
