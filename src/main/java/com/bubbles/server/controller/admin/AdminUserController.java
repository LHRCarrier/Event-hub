package com.bubbles.server.controller.admin;

import com.bubbles.pojo.dto.request.UpdateUserRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.pojo.dto.response.UserResponse;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/users")
@Tag(name = "管理用户接口", description = "用户的查询、更新、禁用/启用等管理操作（仅管理员）")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    @Operation(summary = "获取用户列表", description = "分页获取用户列表，支持关键字搜索（仅管理员）")
    public ResponseEntity<ApiResponse<PageResponse<UserResponse>>> getUsers(
            @Parameter(description = "页码，从1开始") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "搜索关键字") @RequestParam(name = "keyword", required = false) String keyword) {
        PageResponse<UserResponse> response = userService.getUsers(page, size, keyword);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{userId}")
    @Operation(summary = "获取用户详情", description = "根据用户ID获取用户详细信息（仅管理员）")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{userId}")
    @Operation(summary = "更新用户信息", description = "更新用户的邮箱、电话和真实姓名（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId,
            @RequestBody UpdateUserRequest request) {
        userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @PostMapping("/{userId}/disable")
    @Operation(summary = "禁用用户", description = "禁用指定用户（逻辑删除）（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> disableUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        userService.disableUser(userId);
        return ResponseEntity.ok(ApiResponse.success("禁用成功", null));
    }

    @PostMapping("/{userId}/enable")
    @Operation(summary = "启用用户", description = "启用指定用户（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> enableUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        userService.enableUser(userId);
        return ResponseEntity.ok(ApiResponse.success("启用成功", null));
    }
}
