package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.CommunityCreateRequest;
import com.bubbles.eventhub.dto.request.CommunityUpdateRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CommunityResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.service.CommunityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
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

    public CommunityController(CommunityService communityService) {
        this.communityService = communityService;
    }

    @PostMapping
    @Operation(summary = "创建社区", description = "创建新社区，创建者自动成为管理员")
    public ResponseEntity<ApiResponse<CommunityResponse>> createCommunity(
            @Valid @RequestBody CommunityCreateRequest request) {
        CommunityResponse response = communityService.createCommunity(request, 1);
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
            @RequestBody CommunityUpdateRequest request) {
        communityService.updateCommunity(communityId, request, 1);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{communityId}")
    @Operation(summary = "删除社区", description = "删除社区（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> deleteCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId) {
        communityService.deleteCommunity(communityId, 1);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}