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
@Tag(name = "Admin User API", description = "User management operations (admin only)")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    @Operation(summary = "Get Users", description = "Get user list with pagination and keyword search (admin only)")
    public ResponseEntity<ApiResponse<PageResponse<UserResponse>>> getUsers(
            @Parameter(description = "Page number (starting from 1)") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "Search keyword") @RequestParam(name = "keyword", required = false) String keyword) {
        PageResponse<UserResponse> response = userService.getUsers(page, size, keyword);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{userId}")
    @Operation(summary = "Get User Detail", description = "Get user details by ID (admin only)")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId) {
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{userId}")
    @Operation(summary = "Update User", description = "Update user email, phone and real name (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateUser(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId,
            @RequestBody UpdateUserRequest request) {
        userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @PostMapping("/{userId}/disable")
    @Operation(summary = "Disable User", description = "Disable specified user (soft delete) (admin only)")
    public ResponseEntity<ApiResponse<Void>> disableUser(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId) {
        userService.disableUser(userId);
        return ResponseEntity.ok(ApiResponse.success("Disabled successfully", null));
    }

    @PostMapping("/{userId}/enable")
    @Operation(summary = "Enable User", description = "Enable specified user (admin only)")
    public ResponseEntity<ApiResponse<Void>> enableUser(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId) {
        userService.enableUser(userId);
        return ResponseEntity.ok(ApiResponse.success("Enabled successfully", null));
    }
}
