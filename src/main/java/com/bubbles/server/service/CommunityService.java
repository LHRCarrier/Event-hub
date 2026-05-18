package com.bubbles.server.service;

import com.bubbles.pojo.dto.request.CommunityCreateRequest;
import com.bubbles.pojo.dto.request.CommunityUpdateRequest;
import com.bubbles.pojo.dto.response.CommunityResponse;
import com.bubbles.pojo.dto.response.PageResponse;

/**
 * 社区服务接口
 */
public interface CommunityService {

    CommunityResponse createCommunity(CommunityCreateRequest request, Integer creatorUserId);

    CommunityResponse getCommunityById(Integer communityId);

    PageResponse<CommunityResponse> getCommunities(int page, int size, String keyword);

    CommunityResponse updateCommunity(Integer communityId, CommunityUpdateRequest request, Integer userId);

    void deleteCommunity(Integer communityId, Integer userId);

    Integer countMembers(Integer communityId);

    Integer countEvents(Integer communityId);
}