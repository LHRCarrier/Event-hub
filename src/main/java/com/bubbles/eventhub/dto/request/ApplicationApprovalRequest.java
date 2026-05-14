package com.bubbles.eventhub.dto.request;

/**
 * 申请审批请求DTO
 */
public class ApplicationApprovalRequest {

    private String status;
    private String rejectReason;

    public ApplicationApprovalRequest() {}

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }
}