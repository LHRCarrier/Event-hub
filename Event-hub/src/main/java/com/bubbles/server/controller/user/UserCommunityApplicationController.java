package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.request.CommunityApplyRequest;
import com.bubbles.pojo.dto.request.ApplicationApprovalRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityApplicationResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.server.service.CommunityApplicationService;
import com.bubbles.server.service.CommunityMemberService;
import com.bubbles.common.utils.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/communities")
@Tag(name = "Community Application API", description = "Community join application submission and approval operations")
public class UserCommunityApplicationController {

    private final CommunityApplicationService applicationService;
    private final CommunityMemberService memberService;
    private final JwtUtil jwtUtil;

    public UserCommunityApplicationController(CommunityApplicationService applicationService,
                                              CommunityMemberService memberService,
                                              JwtUtil jwtUtil) {
        this.applicationService = applicationService;
        this.memberService = memberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/{communityId}/apply")
    @Operation(summary = "Apply to Join Community", description = "User applies to join specified community")
    public ResponseEntity<ApiResponse<CommunityApplicationResponse>> applyToJoin(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @RequestBody(required = false) CommunityApplyRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        CommunityApplicationResponse response = applicationService.applyToJoin(communityId, userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Application submitted", response));
    }

    @GetMapping("/{communityId}/applications")
    @Operation(summary = "Get Applications", description = "Get community join applications (admin only)")
    public ResponseEntity<ApiResponse<PageResponse<CommunityApplicationResponse>>> getApplications(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Status filter") @RequestParam(name = "status", required = false) String status,
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to view applications"));
        }
        PageResponse<CommunityApplicationResponse> response = applicationService.getApplicationsByCommunity(communityId, status, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{communityId}/applications/{applicationId}")
    @Operation(summary = "Approve Application", description = "Approve user's join application (admin only)")
    public ResponseEntity<ApiResponse<Void>> approveApplication(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Application ID") @PathVariable(name = "applicationId") Integer applicationId,
            @RequestBody ApplicationApprovalRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!memberService.isAdmin(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to approve applications"));
        }

        if ("APPROVED".equals(request.getStatus())) {
            applicationService.approveApplication(applicationId, userId);
            return ResponseEntity.ok(ApiResponse.success("Approved", null));
        } else if ("REJECTED".equals(request.getStatus())) {
            applicationService.rejectApplication(applicationId, userId, request.getRejectReason());
            return ResponseEntity.ok(ApiResponse.success("Rejected", null));
        }

        return ResponseEntity.badRequest().body(ApiResponse.error(400, "Invalid approval status"));
    }

    @GetMapping("/users/{userId}/applications")
    @Operation(summary = "Get My Applications", description = "Get user's submitted join applications")
    public ResponseEntity<ApiResponse<PageResponse<CommunityApplicationResponse>>> getUserApplications(
            @Parameter(description = "User ID") @PathVariable(name = "userId") Integer userId,
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "No permission to view others' applications"));
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
