package com.bubbles.server.service;

import com.bubbles.pojo.dto.request.CommunityCreateApplicationRequest;
import com.bubbles.pojo.dto.response.CommunityCreateApplicationResponse;
import com.bubbles.pojo.dto.response.PageResponse;

import java.util.List;

/**
 * 社区创建申请服务接口
 */
public interface CommunityCreateApplicationService {

    CommunityCreateApplicationResponse applyToCreate(CommunityCreateApplicationRequest request, Integer applicantId);

    PageResponse<CommunityCreateApplicationResponse> getAllApplications(String status, int page, int size);

    void approveApplication(Integer applicationId, Integer approverId);

    void rejectApplication(Integer applicationId, Integer approverId, String reason);

    List<CommunityCreateApplicationResponse> getUserApplications(Integer userId);
}
