package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.ApplicationApprovalRequest;
import com.bubbles.eventhub.dto.request.CommunityCreateApplicationRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CommunityCreateApplicationResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.service.CommunityCreateApplicationService;
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
 * 社区创建申请控制器
 */
@RestController
@RequestMapping("/api/community-applications")
@Tag(name = "社区创建申请接口", description = "社区创建申请的提交、审批等操作")
public class CommunityCreateApplicationController {

    private final CommunityCreateApplicationService applicationService;
    private final JwtUtil jwtUtil;

    public CommunityCreateApplicationController(CommunityCreateApplicationService applicationService,
                                              JwtUtil jwtUtil) {
        this.applicationService = applicationService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping
    @Operation(summary = "申请创建社区", description = "用户申请创建新社区")
    public ResponseEntity<ApiResponse<CommunityCreateApplicationResponse>> applyToCreate(
            @Valid @RequestBody CommunityCreateApplicationRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityCreateApplicationResponse response = applicationService.applyToCreate(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("申请已提交，请等待审批", response));
    }

    @GetMapping
    @Operation(summary = "获取所有申请", description = "获取所有社区创建申请（仅系统管理员）")
    public ResponseEntity<ApiResponse<PageResponse<CommunityCreateApplicationResponse>>> getAllApplications(
            @Parameter(description = "状态筛选") @RequestParam(name = "status", required = false) String status,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        String role = getCurrentUserRole(httpRequest);
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看申请"));
        }
        PageResponse<CommunityCreateApplicationResponse> response = applicationService.getAllApplications(status, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{applicationId}")
    @Operation(summary = "审批创建申请", description = "审批社区创建申请（仅系统管理员）")
    public ResponseEntity<ApiResponse<Void>> approveApplication(
            @Parameter(description = "申请ID") @PathVariable(name = "applicationId") Integer applicationId,
            @RequestBody ApplicationApprovalRequest request,
            HttpServletRequest httpRequest) {
        String role = getCurrentUserRole(httpRequest);
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限审批申请"));
        }
        Integer userId = getCurrentUserId(httpRequest);

        if ("APPROVED".equals(request.getStatus())) {
            applicationService.approveApplication(applicationId, userId);
            return ResponseEntity.ok(ApiResponse.success("已批准社区创建", null));
        } else if ("REJECTED".equals(request.getStatus())) {
            applicationService.rejectApplication(applicationId, userId, request.getRejectReason());
            return ResponseEntity.ok(ApiResponse.success("已拒绝", null));
        }

        return ResponseEntity.badRequest().body(ApiResponse.error(400, "无效的审批状态"));
    }

    @GetMapping("/users/{userId}")
    @Operation(summary = "获取我的创建申请", description = "获取用户提交的社区创建申请")
    public ResponseEntity<ApiResponse<List<CommunityCreateApplicationResponse>>> getUserApplications(
            @Parameter(description = "用户ID") @PathVariable(name = "userId") Integer userId,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看他人申请"));
        }
        List<CommunityCreateApplicationResponse> response = applicationService.getUserApplications(userId);
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

    private String getCurrentUserRole(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            String token = authorization.substring(7);
            return jwtUtil.getRoleFromToken(token);
        }
        return null;
    }
}
