package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.CommunityCreateRequest;
import com.bubbles.eventhub.dto.request.CommunityUpdateRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CommunityResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.service.CommunityMemberService;
import com.bubbles.eventhub.service.CommunityService;
import com.bubbles.eventhub.util.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * 社区管理控制器
 */
@RestController
@RequestMapping("/api/communities")
@Tag(name = "社区管理接口", description = "社区的创建、查询、更新和删除操作")
public class CommunityController {

    private final CommunityService communityService;
    private final CommunityMemberService memberService;
    private final JwtUtil jwtUtil;

    public CommunityController(CommunityService communityService,
                             CommunityMemberService memberService,
                             JwtUtil jwtUtil) {
        this.communityService = communityService;
        this.memberService = memberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping
    @Operation(summary = "创建社区", description = "创建新社区，创建者自动成为管理员")
    public ResponseEntity<ApiResponse<CommunityResponse>> createCommunity(
            @Valid @RequestBody CommunityCreateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityResponse response = communityService.createCommunity(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    @GetMapping
    @Operation(summary = "获取社区列表", description = "分页获取社区列表，支持关键字搜索")
    public ResponseEntity<ApiResponse<PageResponse<CommunityResponse>>> getCommunities(
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "搜索关键字") @RequestParam(name = "keyword", required = false) String keyword) {
        PageResponse<CommunityResponse> response = communityService.getCommunities(page, size, keyword);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{communityId}")
    @Operation(summary = "获取社区详情", description = "根据社区ID获取社区详细信息")
    public ResponseEntity<ApiResponse<CommunityResponse>> getCommunityById(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId) {
        CommunityResponse response = communityService.getCommunityById(communityId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{communityId}")
    @Operation(summary = "更新社区", description = "更新社区信息（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody CommunityUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限更新社区"));
        }
        communityService.updateCommunity(communityId, request, userId);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{communityId}")
    @Operation(summary = "删除社区", description = "删除社区（仅系统管理员）")
    public ResponseEntity<ApiResponse<Void>> deleteCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        String role = getCurrentUserRole(httpRequest);
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限删除社区"));
        }
        Integer userId = getCurrentUserId(httpRequest);
        communityService.deleteCommunity(communityId, userId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
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