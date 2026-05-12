package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.request.CommunityCreateRequest;
import com.bubbles.eventhub.dto.request.CommunityUpdateRequest;
import com.bubbles.eventhub.dto.response.CommunityResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.entity.Community;
import com.bubbles.eventhub.entity.CommunityMember;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.CommunityMapper;
import com.bubbles.eventhub.mapper.CommunityMemberMapper;
import com.bubbles.eventhub.mapper.EventMapper;
import com.bubbles.eventhub.service.CommunityService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/**
 * 社区服务实现类
 */
@Service
public class CommunityServiceImpl implements CommunityService {

    private final CommunityMapper communityMapper;
    private final CommunityMemberMapper communityMemberMapper;
    private final EventMapper eventMapper;

    public CommunityServiceImpl(CommunityMapper communityMapper, 
                               CommunityMemberMapper communityMemberMapper,
                               EventMapper eventMapper) {
        this.communityMapper = communityMapper;
        this.communityMemberMapper = communityMemberMapper;
        this.eventMapper = eventMapper;
    }

    @Override
    @Transactional
    public CommunityResponse createCommunity(CommunityCreateRequest request, Integer creatorUserId) {
        Community community = new Community();
        community.setName(request.getName());
        community.setDescription(request.getDescription());
        community.setLogoUrl(request.getLogoUrl());
        community.setStatus("ACTIVE");
        community.setCreateTime(new Date());
        community.setUpdateTime(new Date());

        communityMapper.insert(community);

        CommunityMember member = new CommunityMember();
        member.setCommunityId(community.getCommunityId());
        member.setUserId(creatorUserId);
        member.setRole("ADMIN");
        member.setStatus("ACTIVE");
        member.setJoinTime(new Date());

        communityMemberMapper.insert(member);

        return convertToResponse(community);
    }

    @Override
    public CommunityResponse getCommunityById(Integer communityId) {
        Community community = communityMapper.selectById(communityId);
        if (community == null) {
            throw new BusinessException(404, "社区不存在");
        }
        return convertToResponse(community);
    }

    @Override
    public PageResponse<CommunityResponse> getCommunities(int page, int size, String keyword) {
        Page<Community> pageObj = new Page<>(page, size);
        IPage<Community> communityPage;

        LambdaQueryWrapper<Community> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Community::getStatus, "ACTIVE");

        if (keyword != null && !keyword.isEmpty()) {
            queryWrapper.like(Community::getName, keyword);
        }

        communityPage = communityMapper.selectPage(pageObj, queryWrapper);

        PageResponse<CommunityResponse> response = new PageResponse<>();
        response.setList(communityPage.getRecords().stream().map(this::convertToResponse).toList());
        response.setTotal((int) communityPage.getTotal());
        response.setPage(page);
        response.setSize(size);

        return response;
    }

    @Override
    @Transactional
    public CommunityResponse updateCommunity(Integer communityId, CommunityUpdateRequest request, Integer userId) {
        Community community = communityMapper.selectById(communityId);
        if (community == null) {
            throw new BusinessException(404, "社区不存在");
        }

        if (request.getName() != null) {
            community.setName(request.getName());
        }
        if (request.getDescription() != null) {
            community.setDescription(request.getDescription());
        }
        if (request.getLogoUrl() != null) {
            community.setLogoUrl(request.getLogoUrl());
        }
        community.setUpdateTime(new Date());

        communityMapper.updateById(community);

        return convertToResponse(community);
    }

    @Override
    @Transactional
    public void deleteCommunity(Integer communityId, Integer userId) {
        Community community = communityMapper.selectById(communityId);
        if (community == null) {
            throw new BusinessException(404, "社区不存在");
        }

        community.setStatus("INACTIVE");
        community.setUpdateTime(new Date());
        communityMapper.updateById(community);
    }

    @Override
    public Integer countMembers(Integer communityId) {
        return communityMemberMapper.countMembers(communityId);
    }

    @Override
    public Integer countEvents(Integer communityId) {
        LambdaQueryWrapper<com.bubbles.eventhub.entity.Event> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(com.bubbles.eventhub.entity.Event::getCommunityId, communityId);
        return eventMapper.selectCount(queryWrapper).intValue();
    }

    private CommunityResponse convertToResponse(Community community) {
        CommunityResponse response = new CommunityResponse();
        response.setCommunityId(community.getCommunityId());
        response.setName(community.getName());
        response.setDescription(community.getDescription());
        response.setLogoUrl(community.getLogoUrl());
        response.setStatus(community.getStatus());
        response.setMemberCount(countMembers(community.getCommunityId()));
        response.setEventCount(countEvents(community.getCommunityId()));
        response.setCreateTime(community.getCreateTime());
        response.setUpdateTime(community.getUpdateTime());
        return response;
    }
}