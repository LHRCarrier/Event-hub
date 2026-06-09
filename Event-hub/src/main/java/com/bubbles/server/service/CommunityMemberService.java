package com.bubbles.server.service;

import com.bubbles.pojo.dto.response.CommunityMemberResponse;
import com.bubbles.pojo.dto.response.CommunityResponse;
import com.bubbles.pojo.dto.response.PageResponse;

import java.util.List;

/**
 * 社区成员服务接口
 */
public interface CommunityMemberService {

    void joinCommunity(Integer communityId, Integer userId);

    void leaveCommunity(Integer communityId, Integer userId);

    void updateMemberRole(Integer memberId, String role, Integer operatorUserId);

    void removeMember(Integer memberId, Integer operatorUserId);

    boolean isMember(Integer communityId, Integer userId);

    String getMemberRole(Integer communityId, Integer userId);

    boolean isAdmin(Integer communityId, Integer userId);

    PageResponse<CommunityMemberResponse> getCommunityMembers(Integer communityId, int page, int size);

    List<CommunityResponse> getUserCommunities(Integer userId);

    int countUserCommunities(Integer userId);

    List<CommunityMemberResponse> getRecentMembers(Integer communityId, int limit);

    int countPendingApplications(Integer communityId);
}