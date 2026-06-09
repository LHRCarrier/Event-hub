package com.bubbles.pojo.dto.response;

public class TrendDataResponse {
    private String month;
    private Integer count;

    public TrendDataResponse() {}

    public TrendDataResponse(String month, Integer count) {
        this.month = month;
        this.count = count;
    }

    public String getMonth() { return month; }
    public void setMonth(String month) { this.month = month; }
    public Integer getCount() { return count; }
    public void setCount(Integer count) { this.count = count; }
}
