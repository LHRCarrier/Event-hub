package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.CommunityApplyRequest;
import com.bubbles.eventhub.dto.request.ApplicationApprovalRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CommunityApplicationResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.service.CommunityApplicationService;
import com.bubbles.eventhub.service.CommunityMemberService;
import com.bubbles.eventhub.util.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 社区加入申请控制器
 */
@RestController
@RequestMapping("/api/communities")
@Tag(name = "社区申请接口", description = "社区加入申请的提交、审批等操作")
public class CommunityApplicationController {

    private final CommunityApplicationService applicationService;
    private final CommunityMemberService memberService;
    private final JwtUtil jwtUtil;

    public CommunityApplicationController(CommunityApplicationService applicationService,
                                       CommunityMemberService memberService,
                                       JwtUtil jwtUtil) {
        this.applicationService = applicationService;
        this.memberService = memberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/{communityId}/apply")
    @Operation(summary = "申请加入社区", description = "用户申请加入指定社区")
    public ResponseEntity<ApiResponse<CommunityApplicationResponse>> applyToJoin(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody(required = false) CommunityApplyRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityApplicationResponse response = applicationService.applyToJoin(communityId, userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("申请已提交", response));
    }

    @GetMapping("/{communityId}/applications")
    @Operation(summary = "获取申请列表", description = "获取社区的加入申请列表（仅管理员）")
    public ResponseEntity<ApiResponse<PageResponse<CommunityApplicationResponse>>> getApplications(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "状态筛选") @RequestParam(name = "status", required = false) String status,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看申请列表"));
        }
        PageResponse<CommunityApplicationResponse> response = applicationService.getApplicationsByCommunity(communityId, status, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{communityId}/applications/{applicationId}")
    @Operation(summary = "审批申请", description = "审批用户的加入申请（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> approveApplication(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "申请ID") @PathVariable(name = "applicationId") Integer applicationId,
            @RequestBody ApplicationApprovalRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限审批申请"));
        }

        if ("APPROVED".equals(request.getStatus())) {
            applicationService.approveApplication(applicationId, userId);
            return ResponseEntity.ok(ApiResponse.success("已批准", null));
        } else if ("REJECTED".equals(request.getStatus())) {
            applicationService.rejectApplication(applicationId, userId, request.getRejectReason());
            return ResponseEntity.ok(ApiResponse.success("已拒绝", null));
        }

        return ResponseEntity.badRequest().body(ApiResponse.error(400, "无效的审批状态"));
    }

    @GetMapping("/users/{userId}/applications")
    @Operation(summary = "获取我的申请", description = "获取用户提交的加入申请")
    public ResponseEntity<ApiResponse<PageResponse<CommunityApplicationResponse>>> getUserApplications(
            @Parameter(description = "用户ID") @PathVariable(name = "userId") Integer userId,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看他人申请"));
        }
        PageResponse<CommunityApplicationResponse> response = applicationService.getUserApplications(userId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
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