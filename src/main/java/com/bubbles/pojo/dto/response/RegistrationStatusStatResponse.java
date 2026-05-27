package com.bubbles.pojo.dto.response;

public class RegistrationStatusStatResponse {
    private String status;
    private Integer count;

    public RegistrationStatusStatResponse() {}

    public RegistrationStatusStatResponse(String status, Integer count) {
        this.status = status;
        this.count = count;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getCount() { return count; }
    public void setCount(Integer count) { this.count = count; }
}
