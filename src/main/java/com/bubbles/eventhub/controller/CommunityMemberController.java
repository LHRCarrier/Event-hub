package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CommunityMemberResponse;
import com.bubbles.eventhub.dto.response.CommunityResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.service.CommunityMemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
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

    public CommunityMemberController(CommunityMemberService communityMemberService) {
        this.communityMemberService = communityMemberService;
    }

    @PostMapping("/join")
    @Operation(summary = "加入社区", description = "用户加入指定社区")
    public ResponseEntity<ApiResponse<Void>> joinCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId) {
        communityMemberService.joinCommunity(communityId, 1);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("加入成功", null));
    }

    @PostMapping("/leave")
    @Operation(summary = "退出社区", description = "用户退出指定社区")
    public ResponseEntity<ApiResponse<Void>> leaveCommunity(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId) {
        communityMemberService.leaveCommunity(communityId, 1);
        return ResponseEntity.ok(ApiResponse.success("退出成功", null));
    }

    @GetMapping
    @Operation(summary = "获取社区成员列表", description = "获取社区的成员列表")
    public ResponseEntity<ApiResponse<PageResponse<CommunityMemberResponse>>> getCommunityMembers(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "页码") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size) {
        PageResponse<CommunityMemberResponse> response = communityMemberService.getCommunityMembers(communityId, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{memberId}/role")
    @Operation(summary = "更新成员角色", description = "更新成员在社区中的角色（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateMemberRole(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "成员ID") @PathVariable(name = "memberId") Integer memberId,
            @RequestBody RoleUpdateRequest request) {
        communityMemberService.updateMemberRole(memberId, request.getRole(), 1);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{memberId}")
    @Operation(summary = "移除成员", description = "从社区中移除成员（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> removeMember(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId,
            @Parameter(description = "成员ID") @PathVariable(name = "memberId") Integer memberId) {
        communityMemberService.removeMember(memberId, 1);
        return ResponseEntity.ok(ApiResponse.success("移除成功", null));
    }

    @GetMapping("/check")
    @Operation(summary = "检查成员身份", description = "检查当前用户是否为社区成员")
    public ResponseEntity<ApiResponse<MemberCheckResponse>> checkMembership(
            @Parameter(description = "社区ID") @PathVariable(name = "communityId") Integer communityId) {
        boolean isMember = communityMemberService.isMember(communityId, 1);
        String role = communityMemberService.getMemberRole(communityId, 1);
        MemberCheckResponse response = new MemberCheckResponse(isMember, role);
        return ResponseEntity.ok(ApiResponse.success(response));
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