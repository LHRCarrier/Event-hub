package com.bubbles.eventhub.service;

import com.bubbles.eventhub.dto.request.CommunityApplyRequest;
import com.bubbles.eventhub.dto.request.ApplicationApprovalRequest;
import com.bubbles.eventhub.dto.response.CommunityApplicationResponse;
import com.bubbles.eventhub.dto.response.PageResponse;

import java.util.List;

/**
 * 社区加入申请服务接口
 */
public interface CommunityApplicationService {

    CommunityApplicationResponse applyToJoin(Integer communityId, Integer userId, CommunityApplyRequest request);

    PageResponse<CommunityApplicationResponse> getApplicationsByCommunity(Integer communityId, String status, int page, int size);

    void approveApplication(Integer applicationId, Integer approverId);

    void rejectApplication(Integer applicationId, Integer approverId, String reason);

    PageResponse<CommunityApplicationResponse> getUserApplications(Integer userId, int page, int size);

    boolean hasPendingApplication(Integer communityId, Integer userId);

    int countPendingApplications(Integer communityId);
}