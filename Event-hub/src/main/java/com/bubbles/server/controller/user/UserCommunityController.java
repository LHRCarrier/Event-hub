package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.request.CommunityCreateRequest;
import com.bubbles.pojo.dto.request.CommunityUpdateRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.server.service.CommunityMemberService;
import com.bubbles.server.service.CommunityService;
import com.bubbles.common.utils.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/communities")
@Tag(name = "Community API", description = "Community creation, query, update and delete operations")
public class UserCommunityController {

    private final CommunityService communityService;
    private final CommunityMemberService memberService;
    private final JwtUtil jwtUtil;

    public UserCommunityController(CommunityService communityService,
                                   CommunityMemberService memberService,
                                   JwtUtil jwtUtil) {
        this.communityService = communityService;
        this.memberService = memberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping
    @Operation(summary = "Create Community", description = "Create new community, creator becomes admin automatically")
    public ResponseEntity<ApiResponse<CommunityResponse>> createCommunity(
            @Valid @RequestBody CommunityCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityResponse response = communityService.createCommunity(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Creation successful", response));
    }

    @GetMapping
    @Operation(summary = "Get Communities", description = "Get community list with pagination and keyword search")
    public ResponseEntity<ApiResponse<PageResponse<CommunityResponse>>> getCommunities(
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "Search keyword") @RequestParam(name = "keyword", required = false) String keyword) {
        PageResponse<CommunityResponse> response = communityService.getCommunities(page, size, keyword);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{communityId}")
    @Operation(summary = "Get Community Detail", description = "Get community details by community ID")
    public ResponseEntity<ApiResponse<CommunityResponse>> getCommunityById(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId) {
        CommunityResponse response = communityService.getCommunityById(communityId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{communityId}")
    @Operation(summary = "Update Community", description = "Update community information (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateCommunity(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody CommunityUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to update community"));
        }
        communityService.updateCommunity(communityId, request, userId);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @DeleteMapping("/{communityId}")
    @Operation(summary = "Delete Community", description = "Delete community (system admin only)")
    public ResponseEntity<ApiResponse<Void>> deleteCommunity(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        String role = getCurrentUserRole(httpRequest);
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to delete community"));
        }
        Integer userId = getCurrentUserId(httpRequest);
        communityService.deleteCommunity(communityId, userId);
        return ResponseEntity.ok(ApiResponse.success("Deletion successful", null));
    }

    @GetMapping("/users/{userId}")
    @Operation(summary = "Get User Communities", description = "Get all communities user has joined")
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> getUserCommunities(
            @Parameter(description = "User ID") @PathVariable(name = "userId") Integer userId,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to view others' communities"));
        }
        List<CommunityResponse> response = memberService.getUserCommunities(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/users/{userId}/count")
    @Operation(summary = "Count User Communities", description = "Get count of communities user has joined")
    public ResponseEntity<ApiResponse<Integer>> countUserCommunities(
            @Parameter(description = "User ID") @PathVariable(name = "userId") Integer userId) {
        int count = memberService.countUserCommunities(userId);
        return ResponseEntity.ok(ApiResponse.success(count));
    }

    private Integer getCurrentUserId(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            String token = authorization.substring(7);
            return jwtUtil.getUserIdFromToken(token);
        }
        return null;
    }

    private String getCurrentUserRole(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            String token = authorization.substring(7);
            return jwtUtil.getRoleFromToken(token);
        }
        return null;
    }
}
