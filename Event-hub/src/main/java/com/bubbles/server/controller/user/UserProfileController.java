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
@Tag(name = "User Profile API", description = "User query and update operations")
public class UserProfileController {

    private final UserService userService;

    public UserProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/{userId}")
    @Operation(summary = "Get User Details", description = "Get user details by user ID")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId) {
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{userId}")
    @Operation(summary = "Update User Info", description = "Update user email, phone and real name")
    public ResponseEntity<ApiResponse<Void>> updateUser(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId,
            @RequestBody UpdateUserRequest request) {
        userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }
}
