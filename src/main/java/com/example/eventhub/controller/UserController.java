package com.example.eventhub.controller;

import com.example.eventhub.dto.request.UpdateUserRequest;
import com.example.eventhub.dto.response.ApiResponse;
import com.example.eventhub.dto.response.PageResponse;
import com.example.eventhub.dto.response.UserResponse;
import com.example.eventhub.exception.BusinessException;
import com.example.eventhub.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@Tag(name = "用户管理接口", description = "用户的查询、更新和删除操作")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * 分页获取用户列表
     * 支持按关键字搜索用户名或真实姓名
     * @param page 页码，从1开始
     * @param size 每页数量，默认10
     * @param keyword 搜索关键字，用于匹配用户名或真实姓名（非必填）
     * @return 分页的用户列表
     */
    @GetMapping
    @Operation(summary = "获取用户列表", description = "分页获取用户列表，支持关键字搜索")
    public ResponseEntity<ApiResponse<PageResponse<UserResponse>>> getUsers(
            @Parameter(description = "页码，从1开始", example = "1") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量", example = "10") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "搜索关键字") @RequestParam(name = "keyword", required = false) String keyword) {
        PageResponse<UserResponse> response = userService.getUsers(page, size, keyword);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 根据用户ID获取用户详情
     * @param userId 用户ID
     * @return 用户详细信息
     * @throws BusinessException 用户不存在时抛出异常
     */
    @GetMapping("/{userId}")
    @Operation(summary = "获取用户详情", description = "根据用户ID获取用户详细信息")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 更新用户信息
     * @param userId 要更新的用户ID
     * @param request 用户更新请求参数，包含邮箱、电话和真实姓名
     * @return 更新成功返回空响应
     * @throws BusinessException 用户不存在或邮箱已被使用时抛出异常
     */
    @PutMapping("/{userId}")
    @Operation(summary = "更新用户信息", description = "更新用户的邮箱、电话和真实姓名")
    public ResponseEntity<ApiResponse<Void>> updateUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId,
            @RequestBody UpdateUserRequest request) {
        userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    /**
     * 删除用户
     * @param userId 要删除的用户ID
     * @return 删除成功返回空响应
     * @throws BusinessException 用户不存在时抛出异常
     */
    @DeleteMapping("/{userId}")
    @Operation(summary = "删除用户", description = "删除指定用户")
    public ResponseEntity<ApiResponse<Void>> deleteUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        userService.deleteUser(userId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}