package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.entity.User;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.mapper.UserMapper;
import com.bubbles.server.service.OssUploadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/avatar")
@Tag(name = "Avatar API", description = "User avatar upload and management")
public class UserAvatarController {

    private static final Logger logger = LoggerFactory.getLogger(UserAvatarController.class);

    private final OssUploadService ossUploadService;
    private final UserMapper userMapper;

    public UserAvatarController(OssUploadService ossUploadService, UserMapper userMapper) {
        this.ossUploadService = ossUploadService;
        this.userMapper = userMapper;
    }

    @PostMapping(value = "/upload/{userId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload Avatar", description = "Upload and update user avatar, supports jpg/jpeg/png, max 2MB")
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadAvatar(
            @Parameter(description = "User ID", required = true) @PathVariable("userId") Integer userId,
            @Parameter(description = "Avatar file", required = true) @RequestParam("file") MultipartFile file) {

        logger.info("Received avatar upload request for user: {}", userId);

        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(404, "User not found");
        }

        String oldAvatarUrl = user.getAvatarUrl();

        String newAvatarUrl = ossUploadService.uploadAvatar(userId, file);

        user.setAvatarUrl(newAvatarUrl);
        user.setUpdateTime(new Date());
        userMapper.updateById(user);

        if (oldAvatarUrl != null && !oldAvatarUrl.isEmpty()) {
            try {
                ossUploadService.deleteAvatar(oldAvatarUrl);
            } catch (Exception e) {
                logger.warn("Failed to delete old avatar: {}", oldAvatarUrl, e);
            }
        }

        Map<String, String> result = new HashMap<>();
        result.put("avatarUrl", newAvatarUrl);

        logger.info("Avatar uploaded successfully for user {}: {}", userId, newAvatarUrl);
        return ResponseEntity.ok(ApiResponse.success("Avatar uploaded successfully", result));
    }

    @DeleteMapping("/{userId}")
    @Operation(summary = "Delete Avatar", description = "Delete user avatar and restore default")
    public ResponseEntity<ApiResponse<Void>> deleteAvatar(
            @Parameter(description = "User ID", required = true) @PathVariable("userId") Integer userId) {

        logger.info("Received avatar delete request for user: {}", userId);

        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(404, "User not found");
        }

        String avatarUrl = user.getAvatarUrl();
        if (avatarUrl != null && !avatarUrl.isEmpty()) {
            ossUploadService.deleteAvatar(avatarUrl);
            
            user.setAvatarUrl(null);
            user.setUpdateTime(new Date());
            userMapper.updateById(user);
        }

        logger.info("Avatar deleted successfully for user: {}", userId);
        return ResponseEntity.ok(ApiResponse.success("Avatar deleted successfully", null));
    }
}
