package com.bubbles.server.service;

import org.springframework.web.multipart.MultipartFile;

public interface OssUploadService {

    String uploadAvatar(Integer userId, MultipartFile file);

    void deleteAvatar(String avatarUrl);

    String getAvatarUrl(String avatarPath);
}