package com.bubbles.server.controller.admin;

import com.bubbles.pojo.dto.request.ApplicationApprovalRequest;
import com.bubbles.pojo.dto.request.CommunityCreateApplicationRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityCreateApplicationResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.server.service.CommunityCreateApplicationService;
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
@RequestMapping("/api")
@Tag(name = "Community Creation Application API", description = "Community creation application query and approval")
public class AdminCommunityApplicationController {

    private final CommunityCreateApplicationService applicationService;
    private final JwtUtil jwtUtil;

    public AdminCommunityApplicationController(CommunityCreateApplicationService applicationService,
                                               JwtUtil jwtUtil) {
        this.applicationService = applicationService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/community-applications")
    @Operation(summary = "Submit Community Creation Application", description = "Submit new community creation application for admin approval")
    public ResponseEntity<ApiResponse<CommunityCreateApplicationResponse>> submitApplication(
            @Valid @RequestBody CommunityCreateApplicationRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityCreateApplicationResponse response = applicationService.applyToCreate(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Application submitted, waiting for approval", response));
    }

    @GetMapping("/admin/community-applications")
    @Operation(summary = "Get All Applications", description = "Get all community creation applications with status filter (admin only)")
    public ResponseEntity<ApiResponse<PageResponse<CommunityCreateApplicationResponse>>> getAllApplications(
            @Parameter(description = "Status filter") @RequestParam(name = "status", required = false) String status,
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size) {
        PageResponse<CommunityCreateApplicationResponse> response = applicationService.getAllApplications(status, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/admin/community-applications/{applicationId}")
    @Operation(summary = "Approve Application", description = "Approve or reject community creation application (admin only)")
    public ResponseEntity<ApiResponse<Void>> approveApplication(
            @Parameter(description = "Application ID") @PathVariable(name = "applicationId") Integer applicationId,
            @RequestBody ApplicationApprovalRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);

        if ("APPROVED".equals(request.getStatus())) {
            applicationService.approveApplication(applicationId, userId);
            return ResponseEntity.ok(ApiResponse.success("Community creation approved", null));
        } else if ("REJECTED".equals(request.getStatus())) {
            applicationService.rejectApplication(applicationId, userId, request.getRejectReason());
            return ResponseEntity.ok(ApiResponse.success("Rejected", null));
        }

        return ResponseEntity.badRequest().body(ApiResponse.error(400, "Invalid approval status"));
    }

    @GetMapping("/community-applications/users/{userId}")
    @Operation(summary = "Get User Applications", description = "Get user's submitted community creation applications")
    public ResponseEntity<ApiResponse<List<CommunityCreateApplicationResponse>>> getUserApplications(
            @Parameter(description = "User ID") @PathVariable(name = "userId") Integer userId,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to view others' applications"));
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
}
