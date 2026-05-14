package com.bubbles.eventhub.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 社区创建申请请求DTO
 */
public class CommunityCreateApplicationRequest {

    @NotBlank(message = "社区名称不能为空")
    @Size(min = 3, max = 100, message = "社区名称长度必须在3-100个字符之间")
    private String name;

    @Size(max = 2000, message = "社区描述不能超过2000个字符")
    private String description;

    @Size(max = 255, message = "Logo URL不能超过255个字符")
    private String logoUrl;

    public CommunityCreateApplicationRequest() {}

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