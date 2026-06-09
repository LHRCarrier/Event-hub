package com.bubbles.common.utils;

import com.aliyun.oss.ClientException;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.OSSException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;

public class AliOssUtil {

    private static final Logger log = LoggerFactory.getLogger(AliOssUtil.class);

    private String endpoint;
    private String accessKeyId;
    private String accessKeySecret;
    private String bucketName;

    public AliOssUtil() {}

    public AliOssUtil(String endpoint, String accessKeyId, String accessKeySecret, String bucketName) {
        this.endpoint = endpoint;
        this.accessKeyId = accessKeyId;
        this.accessKeySecret = accessKeySecret;
        this.bucketName = bucketName;
    }

    public String upload(byte[] bytes, String objectName) {
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        try {
            ossClient.putObject(bucketName, objectName, new ByteArrayInputStream(bytes));
        } catch (OSSException oe) {
            log.error("OSSException occurred: Error Message={}, Error Code={}, Request ID={}, Host ID={}",
                    oe.getErrorMessage(), oe.getErrorCode(), oe.getRequestId(), oe.getHostId());
            throw new RuntimeException("OSS上传失败: " + oe.getErrorMessage());
        } catch (ClientException ce) {
            log.error("ClientException occurred: Error Message={}", ce.getMessage());
            throw new RuntimeException("网络连接失败: " + ce.getMessage());
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }

        StringBuilder stringBuilder = new StringBuilder("https://");
        stringBuilder
                .append(bucketName)
                .append(".")
                .append(endpoint)
                .append("/")
                .append(objectName);

        log.info("文件上传到:{}", stringBuilder.toString());

        return stringBuilder.toString();
    }

    public void delete(String objectName) {
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        try {
            if (ossClient.doesObjectExist(bucketName, objectName)) {
                ossClient.deleteObject(bucketName, objectName);
                log.info("文件删除成功: {}", objectName);
            }
        } catch (OSSException oe) {
            log.error("OSS删除失败: Error Message={}, Error Code={}, Request ID={}",
                    oe.getErrorMessage(), oe.getErrorCode(), oe.getRequestId());
            throw new RuntimeException("OSS删除失败: " + oe.getErrorMessage());
        } catch (ClientException ce) {
            log.error("ClientException occurred: Error Message={}", ce.getMessage());
            throw new RuntimeException("网络连接失败: " + ce.getMessage());
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }

    public boolean doesObjectExist(String objectName) {
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        try {
            return ossClient.doesObjectExist(bucketName, objectName);
        } catch (OSSException oe) {
            log.error("OSS检查文件失败: Error Message={}", oe.getErrorMessage());
            return false;
        } catch (ClientException ce) {
            log.error("ClientException occurred: Error Message={}", ce.getMessage());
            return false;
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getAccessKeyId() {
        return accessKeyId;
    }

    public void setAccessKeyId(String accessKeyId) {
        this.accessKeyId = accessKeyId;
    }

    public String getAccessKeySecret() {
        return accessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret) {
        this.accessKeySecret = accessKeySecret;
    }

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }
}