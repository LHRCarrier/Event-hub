package com.bubbles.server.service;

import com.bubbles.pojo.dto.request.CommunityApplyRequest;
import com.bubbles.pojo.dto.response.CommunityApplicationResponse;
import com.bubbles.pojo.dto.response.PageResponse;

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