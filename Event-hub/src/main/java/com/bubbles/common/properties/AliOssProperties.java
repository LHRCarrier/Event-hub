package com.bubbles.common.properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AliOssProperties {

    @Value("${spring.alioss.endpoint}")
    private String endpoint;

    @Value("${spring.alioss.access-key-id}")
    private String accessKeyId;

    @Value("${spring.alioss.access-key-secret}")
    private String accessKeySecret;

    @Value("${spring.alioss.bucket-name}")
    private String bucketName;

    @Value("${spring.alioss.cdn-domain}")
    private String cdnDomain;

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

    public String getCdnDomain() {
        return cdnDomain;
    }

    public void setCdnDomain(String cdnDomain) {
        this.cdnDomain = cdnDomain;
    }
}