package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityMemberResponse;
import com.bubbles.pojo.dto.response.PageResponse;
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
@RequestMapping("/api/communities/{communityId}/members")
@Tag(name = "Community Member API", description = "Community member join, leave, and role management operations")
public class UserCommunityMemberController {

    private final CommunityMemberService communityMemberService;
    private final JwtUtil jwtUtil;

    public UserCommunityMemberController(CommunityMemberService communityMemberService, JwtUtil jwtUtil) {
        this.communityMemberService = communityMemberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/join")
    @Operation(summary = "Join Community", description = "User joins specified community (submits application if approval required)")
    public ResponseEntity<ApiResponse<Void>> joinCommunity(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.joinCommunity(communityId, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Join successful", null));
    }

    @PostMapping("/leave")
    @Operation(summary = "Leave Community", description = "User leaves specified community")
    public ResponseEntity<ApiResponse<Void>> leaveCommunity(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.leaveCommunity(communityId, userId);
        return ResponseEntity.ok(ApiResponse.success("Leave successful", null));
    }

    @GetMapping
    @Operation(summary = "Get Community Members", description = "Get community member list")
    public ResponseEntity<ApiResponse<PageResponse<CommunityMemberResponse>>> getCommunityMembers(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Page number") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!communityMemberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "You are not a member of this community"));
        }
        PageResponse<CommunityMemberResponse> response = communityMemberService.getCommunityMembers(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{memberId}/role")
    @Operation(summary = "Update Member Role", description = "Update member role in community (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateMemberRole(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Member ID") @PathVariable(name = "memberId") Integer memberId,
            @RequestBody RoleUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.updateMemberRole(memberId, request.getRole(), userId);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @DeleteMapping("/{memberId}")
    @Operation(summary = "Remove Member", description = "Remove member from community (admin only)")
    public ResponseEntity<ApiResponse<Void>> removeMember(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "Member ID") @PathVariable(name = "memberId") Integer memberId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.removeMember(memberId, userId);
        return ResponseEntity.ok(ApiResponse.success("Removal successful", null));
    }

    @GetMapping("/check")
    @Operation(summary = "Check Membership", description = "Check if current user is a community member")
    public ResponseEntity<ApiResponse<MemberCheckResponse>> checkMembership(
            @Parameter(description = "Community ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        boolean isMember = communityMemberService.isMember(communityId, userId);
        String role = communityMemberService.getMemberRole(communityId, userId);
        MemberCheckResponse response = new MemberCheckResponse(isMember, role);
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

    public static class RoleUpdateRequest {
        private String role;

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }
    }

    public static class MemberCheckResponse {
        private boolean isMember;
        private String role;

        public MemberCheckResponse(boolean isMember, String role) {
            this.isMember = isMember;
            this.role = role;
        }

        public boolean isMember() {
            return isMember;
        }

        public void setMember(boolean member) {
            isMember = member;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }
    }
}
