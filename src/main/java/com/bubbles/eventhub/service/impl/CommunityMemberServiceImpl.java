package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.response.CommunityMemberResponse;
import com.bubbles.eventhub.dto.response.CommunityResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.entity.Community;
import com.bubbles.eventhub.entity.CommunityMember;
import com.bubbles.eventhub.entity.User;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.CommunityMapper;
import com.bubbles.eventhub.mapper.CommunityMemberMapper;
import com.bubbles.eventhub.mapper.UserMapper;
import com.bubbles.eventhub.service.CommunityMemberService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 社区成员服务实现类
 */
@Service
public class CommunityMemberServiceImpl implements CommunityMemberService {

    private final CommunityMemberMapper communityMemberMapper;
    private final CommunityMapper communityMapper;
    private final UserMapper userMapper;

    public CommunityMemberServiceImpl(CommunityMemberMapper communityMemberMapper,
                                     CommunityMapper communityMapper,
                                     UserMapper userMapper) {
        this.communityMemberMapper = communityMemberMapper;
        this.communityMapper = communityMapper;
        this.userMapper = userMapper;
    }

    @Override
    @Transactional
    public void joinCommunity(Integer communityId, Integer userId) {
        Community community = communityMapper.selectById(communityId);
        if (community == null || !"ACTIVE".equals(community.getStatus())) {
            throw new BusinessException(404, "社区不存在或已停用");
        }

        CommunityMember existingMember = communityMemberMapper.selectByCommunityAndUser(communityId, userId);
        if (existingMember != null && "ACTIVE".equals(existingMember.getStatus())) {
            throw new BusinessException(400, "已加入该社区");
        }

        if (existingMember != null) {
            existingMember.setStatus("ACTIVE");
            existingMember.setJoinTime(new Date());
            communityMemberMapper.updateById(existingMember);
        } else {
            CommunityMember member = new CommunityMember();
            member.setCommunityId(communityId);
            member.setUserId(userId);
            member.setRole("MEMBER");
            member.setStatus("ACTIVE");
            member.setJoinTime(new Date());
            communityMemberMapper.insert(member);
        }
    }

    @Override
    @Transactional
    public void leaveCommunity(Integer communityId, Integer userId) {
        CommunityMember member = communityMemberMapper.selectByCommunityAndUser(communityId, userId);
        if (member == null) {
            throw new BusinessException(400, "您不是该社区成员");
        }

        if ("ADMIN".equals(member.getRole())) {
            LambdaQueryWrapper<CommunityMember> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(CommunityMember::getCommunityId, communityId);
            queryWrapper.eq(CommunityMember::getRole, "ADMIN");
            queryWrapper.eq(CommunityMember::getStatus, "ACTIVE");
            long adminCount = communityMemberMapper.selectCount(queryWrapper);
            if (adminCount <= 1) {
                throw new BusinessException(400, "您是该社区的唯一管理员，请先转移管理员权限");
            }
        }

        member.setStatus("INACTIVE");
        communityMemberMapper.updateById(member);
    }

    @Override
    @Transactional
    public void updateMemberRole(Integer memberId, String role, Integer operatorUserId) {
        CommunityMember member = communityMemberMapper.selectById(memberId);
        if (member == null) {
            throw new BusinessException(404, "成员不存在");
        }

        String operatorRole = communityMemberMapper.getMemberRole(member.getCommunityId(), operatorUserId);
        if (!"ADMIN".equals(operatorRole)) {
            throw new BusinessException(403, "无权限修改成员角色");
        }

        member.setRole(role);
        communityMemberMapper.updateById(member);
    }

    @Override
    @Transactional
    public void removeMember(Integer memberId, Integer operatorUserId) {
        CommunityMember member = communityMemberMapper.selectById(memberId);
        if (member == null) {
            throw new BusinessException(404, "成员不存在");
        }

        String operatorRole = communityMemberMapper.getMemberRole(member.getCommunityId(), operatorUserId);
        if (!"ADMIN".equals(operatorRole)) {
            throw new BusinessException(403, "无权限移除成员");
        }

        if ("ADMIN".equals(member.getRole())) {
            LambdaQueryWrapper<CommunityMember> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(CommunityMember::getCommunityId, member.getCommunityId());
            queryWrapper.eq(CommunityMember::getRole, "ADMIN");
            queryWrapper.eq(CommunityMember::getStatus, "ACTIVE");
            long adminCount = communityMemberMapper.selectCount(queryWrapper);
            if (adminCount <= 1) {
                throw new BusinessException(400, "无法移除唯一的管理员");
            }
        }

        member.setStatus("INACTIVE");
        communityMemberMapper.updateById(member);
    }

    @Override
    public boolean isMember(Integer communityId, Integer userId) {
        CommunityMember member = communityMemberMapper.selectByCommunityAndUser(communityId, userId);
        return member != null && "ACTIVE".equals(member.getStatus());
    }

    @Override
    public String getMemberRole(Integer communityId, Integer userId) {
        return communityMemberMapper.getMemberRole(communityId, userId);
    }

    @Override
    public boolean isAdmin(Integer communityId, Integer userId) {
        String role = getMemberRole(communityId, userId);
        return "ADMIN".equals(role);
    }

    @Override
    public PageResponse<CommunityMemberResponse> getCommunityMembers(Integer communityId, int page, int size) {
        Page<CommunityMember> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<CommunityMember> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(CommunityMember::getCommunityId, communityId);
        queryWrapper.eq(CommunityMember::getStatus, "ACTIVE");
        queryWrapper.orderByDesc(CommunityMember::getJoinTime);

        IPage<CommunityMember> memberPage = communityMemberMapper.selectPage(pageObj, queryWrapper);

        PageResponse<CommunityMemberResponse> response = new PageResponse<>();
        response.setList(memberPage.getRecords().stream().map(this::convertToResponse).toList());
        response.setTotal((int) memberPage.getTotal());
        response.setPage(page);
        response.setSize(size);

        return response;
    }

    @Override
    public List<CommunityResponse> getUserCommunities(Integer userId) {
        List<CommunityMember> members = communityMemberMapper.selectByUserId(userId);
        
        return members.stream()
            .map(member -> {
                Community community = communityMapper.selectById(member.getCommunityId());
                if (community == null) return null;
                
                CommunityResponse response = new CommunityResponse();
                response.setCommunityId(community.getCommunityId());
                response.setName(community.getName());
                response.setDescription(community.getDescription());
                response.setLogoUrl(community.getLogoUrl());
                response.setRole(member.getRole());
                response.setJoinTime(member.getJoinTime());
                return response;
            })
            .filter(response -> response != null)
            .toList();
    }

    @Override
    public int countUserCommunities(Integer userId) {
        LambdaQueryWrapper<CommunityMember> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(CommunityMember::getUserId, userId);
        queryWrapper.eq(CommunityMember::getStatus, "ACTIVE");
        return communityMemberMapper.selectCount(queryWrapper).intValue();
    }

    private CommunityMemberResponse convertToResponse(CommunityMember member) {
        CommunityMemberResponse response = new CommunityMemberResponse();
        response.setMemberId(member.getMemberId());
        response.setCommunityId(member.getCommunityId());
        response.setUserId(member.getUserId());
        response.setRole(member.getRole());
        response.setStatus(member.getStatus());
        response.setJoinTime(member.getJoinTime());

        User user = userMapper.selectById(member.getUserId());
        if (user != null) {
            response.setUsername(user.getUsername());
            response.setRealName(user.getRealName());
            response.setEmail(user.getEmail());
        }

        return response;
    }
}