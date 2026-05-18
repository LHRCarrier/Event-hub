package com.bubbles.server.service.impl;

import com.bubbles.common.utils.AliOssUtil;
import com.bubbles.server.config.OssConfig;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.service.OssUploadService;
import net.coobird.thumbnailator.Thumbnails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
public class OssUploadServiceImpl implements OssUploadService {

    private static final Logger logger = LoggerFactory.getLogger(OssUploadServiceImpl.class);

    private static final long MAX_FILE_SIZE = 2 * 1024 * 1024;

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png");

    private static final List<String> ALLOWED_CONTENT_TYPES = Arrays.asList(
            "image/jpeg",
            "image/jpg",
            "image/png"
    );

    private static final int AVATAR_WIDTH = 200;
    private static final int AVATAR_HEIGHT = 200;

    private final AliOssUtil aliOssUtil;
    private final OssConfig ossConfig;

    public OssUploadServiceImpl(OssConfig ossConfig) {
        this.ossConfig = ossConfig;
        this.aliOssUtil = new AliOssUtil(
                ossConfig.getEndpoint(),
                ossConfig.getAccessKeyId(),
                ossConfig.getAccessKeySecret(),
                ossConfig.getBucketName()
        );
    }

    @Override
    public String uploadAvatar(Integer userId, MultipartFile file) {
        validateFile(file);

        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String newFilename = generateRandomFilename(userId, extension);
        String objectKey = "avatars/" + newFilename;

        try {
            byte[] compressedBytes = compressImage(file.getInputStream(), extension);
            String avatarUrl = aliOssUtil.upload(compressedBytes, objectKey);
            
            logger.info("Avatar uploaded successfully for user {}: {}", userId, avatarUrl);
            return avatarUrl;

        } catch (IOException e) {
            logger.error("Failed to compress image", e);
            throw new BusinessException(500, "图片压缩失败");
        } catch (RuntimeException e) {
            logger.error("Failed to upload avatar to OSS", e);
            throw new BusinessException(500, "头像上传失败，请稍后重试");
        }
    }

    @Override
    public void deleteAvatar(String avatarUrl) {
        if (avatarUrl == null || avatarUrl.isEmpty()) {
            return;
        }

        String objectKey = extractObjectKey(avatarUrl);
        
        try {
            aliOssUtil.delete(objectKey);
            logger.info("Avatar deleted: {}", objectKey);
        } catch (RuntimeException e) {
            logger.error("Failed to delete avatar", e);
            throw new BusinessException(500, "头像删除失败");
        }
    }

    @Override
    public String getAvatarUrl(String avatarPath) {
        if (avatarPath == null || avatarPath.isEmpty()) {
            return null;
        }

        String cdnDomain = ossConfig.getCdnDomain();
        if (cdnDomain != null && !cdnDomain.isEmpty()) {
            return "https://" + cdnDomain + "/" + avatarPath;
        } else {
            return "https://" + ossConfig.getBucketName() + "." + ossConfig.getEndpoint() + "/" + avatarPath;
        }
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException(400, "请选择要上传的头像文件");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isEmpty()) {
            throw new BusinessException(400, "文件名不能为空");
        }

        String extension = getFileExtension(originalFilename).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new BusinessException(400, "仅支持jpg/jpeg/png格式的图片");
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new BusinessException(400, "文件类型不支持，请上传图片文件");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new BusinessException(400, "文件大小不能超过2MB");
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }

    private String generateRandomFilename(Integer userId, String extension) {
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return "user_" + userId + "_" + uuid + "." + extension;
    }

    private byte[] compressImage(InputStream inputStream, String extension) throws IOException {
        BufferedImage originalImage = ImageIO.read(inputStream);
        
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        
        Thumbnails.of(originalImage)
                .size(AVATAR_WIDTH, AVATAR_HEIGHT)
                .outputFormat(extension.equalsIgnoreCase("png") ? "png" : "jpg")
                .outputQuality(0.8)
                .toOutputStream(outputStream);

        return outputStream.toByteArray();
    }

    private String extractObjectKey(String avatarUrl) {
        if (avatarUrl.contains("avatars/")) {
            return avatarUrl.substring(avatarUrl.indexOf("avatars/"));
        }
        return avatarUrl;
    }
}