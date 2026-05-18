package com.bubbles.server.controller;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityMemberResponse;
import com.bubbles.pojo.dto.response.CommunityResponse;
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

import java.util.List;

/**
 * 社区成员管理控制器
 */
@RestController
@RequestMapping("/api/communities/{communityId}/members")
@Tag(name = "社区成员管理接口", description = "社区成员的加入、退出、角色管理等操作")
public class CommunityMemberController {

    private final CommunityMemberService communityMemberService;
    private final JwtUtil jwtUtil;

    public CommunityMemberController(CommunityMemberService communityMemberService, JwtUtil jwtUtil) {
        this.communityMemberService = communityMemberService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/join")
    @Operation(summary = "加入社区", description = "用户加入指定社区（社区需要审核时提交申请）")
    public ResponseEntity<ApiResponse<Void>> joinCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.joinCommunity(communityId, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("加入成功", null));
    }

    @PostMapping("/leave")
    @Operation(summary = "退出社区", description = "用户退出指定社区")
    public ResponseEntity<ApiResponse<Void>> leaveCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.leaveCommunity(communityId, userId);
        return ResponseEntity.ok(ApiResponse.success("退出成功", null));
    }

    @GetMapping
    @Operation(summary = "获取社区成员列表", description = "获取社区的成员列表")
    public ResponseEntity<ApiResponse<PageResponse<CommunityMemberResponse>>> getCommunityMembers(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        if (!communityMemberService.isMember(communityId, userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "您不是该社区成员"));
        }
        PageResponse<CommunityMemberResponse> response = communityMemberService.getCommunityMembers(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{memberId}/role")
    @Operation(summary = "更新成员角色", description = "更新成员在社区中的角色（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateMemberRole(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "成员ID") @PathVariable(name = "memberId") Integer memberId,
            @RequestBody RoleUpdateRequest request,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.updateMemberRole(memberId, request.getRole(), userId);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{memberId}")
    @Operation(summary = "移除成员", description = "从社区中移除成员（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> removeMember(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "成员ID") @PathVariable(name = "memberId") Integer memberId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        communityMemberService.removeMember(memberId, userId);
        return ResponseEntity.ok(ApiResponse.success("移除成功", null));
    }

    @GetMapping("/check")
    @Operation(summary = "检查成员身份", description = "检查当前用户是否为社区成员")
    public ResponseEntity<ApiResponse<MemberCheckResponse>> checkMembership(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            HttpServletRequest httpRequest) {
        Integer userId = getCurrentUserId(httpRequest);
        boolean isMember = communityMemberService.isMember(communityId, userId);
        String role = communityMemberService.getMemberRole(communityId, userId);
        MemberCheckResponse response = new MemberCheckResponse(isMember, role);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/users/{userId}/communities")
    @Operation(summary = "获取用户社区列表", description = "获取用户加入的社区列表")
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> getUserCommunities(
            @Parameter(description = "用户ID") @PathVariable(name = "userId") Integer userId,
            HttpServletRequest httpRequest) {
        Integer currentUserId = getCurrentUserId(httpRequest);
        if (!currentUserId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(403, "无权限查看他人社区"));
        }
        List<CommunityResponse> response = communityMemberService.getUserCommunities(userId);
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