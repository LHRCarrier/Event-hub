package com.bubbles.pojo.dto.request;

import jakarta.validation.constraints.Size;

/**
 * 社区更新请求DTO
 */
public class CommunityUpdateRequest {

    @Size(max = 100, message = "社区名称长度不能超过100个字符")
    private String name;

    @Size(max = 500, message = "社区描述长度不能超过500个字符")
    private String description;

    private String logoUrl;

    public CommunityUpdateRequest() {}

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }
}