package com.bubbles.pojo.dto.response;

public class RecentActivityResponse {
    private String type;
    private String title;
    private String description;
    private String time;

    public RecentActivityResponse() {}

    public RecentActivityResponse(String type, String title, String description, String time) {
        this.type = type;
        this.title = title;
        this.description = description;
        this.time = time;
    }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
}
