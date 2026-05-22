package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.request.UpdateUserRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.UserResponse;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@Tag(name = "用户个人资料接口", description = "用户的查询、更新操作")
public class UserProfileController {

    private final UserService userService;

    public UserProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/{userId}")
    @Operation(summary = "获取用户详情", description = "根据用户ID获取用户详细信息")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{userId}")
    @Operation(summary = "更新用户信息", description = "更新用户的邮箱、电话和真实姓名")
    public ResponseEntity<ApiResponse<Void>> updateUser(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId,
            @RequestBody UpdateUserRequest request) {
        userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }
}
