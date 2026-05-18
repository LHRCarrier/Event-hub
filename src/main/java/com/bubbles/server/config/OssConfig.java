package com.bubbles.server.config;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.bubbles.common.properties.AliOssProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OssConfig {

    private static final Logger logger = LoggerFactory.getLogger(OssConfig.class);

    private final AliOssProperties aliOssProperties;

    public OssConfig(AliOssProperties aliOssProperties) {
        this.aliOssProperties = aliOssProperties;
    }

    @Bean
    public OSS ossClient() {
        logger.info("Initializing OSS client with endpoint: {}", aliOssProperties.getEndpoint());
        return new OSSClientBuilder().build(
            aliOssProperties.getEndpoint(),
            aliOssProperties.getAccessKeyId(),
            aliOssProperties.getAccessKeySecret()
        );
    }

    public String getBucketName() {
        return aliOssProperties.getBucketName();
    }

    public String getCdnDomain() {
        return aliOssProperties.getCdnDomain();
    }

    public String getEndpoint() {
        return aliOssProperties.getEndpoint();
    }

    public String getAccessKeyId() {
        return aliOssProperties.getAccessKeyId();
    }

    public String getAccessKeySecret() {
        return aliOssProperties.getAccessKeySecret();
    }
}