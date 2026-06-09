package com.bubbles.pojo.dto.response;

public class CommunityStatResponse {
    private String name;
    private Integer memberCount;

    public CommunityStatResponse() {}

    public CommunityStatResponse(String name, Integer memberCount) {
        this.name = name;
        this.memberCount = memberCount;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getMemberCount() { return memberCount; }
    public void setMemberCount(Integer memberCount) { this.memberCount = memberCount; }
}
