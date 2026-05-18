package com.bubbles.server.controller;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CommunityResponse;
import com.bubbles.server.service.CommunityMemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户社区关系控制器
 */
@RestController
@RequestMapping("/api/users/{userId}/communities")
@Tag(name = "用户社区接口", description = "获取用户加入的社区列表")
public class UserCommunityController {

    private final CommunityMemberService communityMemberService;

    public UserCommunityController(CommunityMemberService communityMemberService) {
        this.communityMemberService = communityMemberService;
    }

    @GetMapping
    @Operation(summary = "获取用户社区列表", description = "获取用户加入的所有社区")
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> getUserCommunities(
            @Parameter(description = "用户ID") @PathVariable(name = "userId") Integer userId) {
        List<CommunityResponse> response = communityMemberService.getUserCommunities(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/count")
    @Operation(summary = "获取用户社区数量", description = "获取用户加入的社区数量")
    public ResponseEntity<ApiResponse<Integer>> countUserCommunities(
            @Parameter(description = "用户ID") @PathVariable(name = "userId") Integer userId) {
        int count = communityMemberService.countUserCommunities(userId);
        return ResponseEntity.ok(ApiResponse.success(count));
    }
}