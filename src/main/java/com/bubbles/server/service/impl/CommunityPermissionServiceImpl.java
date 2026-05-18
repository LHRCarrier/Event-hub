package com.bubbles.server.service.impl;

import com.bubbles.pojo.entity.Event;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.mapper.EventMapper;
import com.bubbles.server.mapper.UserMapper;
import com.bubbles.server.service.CommunityMemberService;
import com.bubbles.server.service.CommunityPermissionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * 社区权限服务实现类
 */
@Service
public class CommunityPermissionServiceImpl implements CommunityPermissionService {

    private static final Logger logger = LoggerFactory.getLogger(CommunityPermissionServiceImpl.class);

    private final CommunityMemberService memberService;
    private final EventMapper eventMapper;
    private final UserMapper userMapper;

    public CommunityPermissionServiceImpl(CommunityMemberService memberService,
                                         EventMapper eventMapper,
                                         UserMapper userMapper) {
        this.memberService = memberService;
        this.eventMapper = eventMapper;
        this.userMapper = userMapper;
    }

    @Override
    public AccessLevel checkCommunityAccess(Integer communityId, Integer userId) {
        if (userId == null) {
            return AccessLevel.NONE;
        }

        String role = memberService.getMemberRole(communityId, userId);
        if ("ADMIN".equals(role)) {
            return AccessLevel.ADMIN;
        } else if ("MEMBER".equals(role)) {
            return AccessLevel.MEMBER;
        }
        return AccessLevel.NONE;
    }

    @Override
    public boolean checkEventCreatePermission(Integer communityId, Integer userId) {
        if (userId == null) {
            return false;
        }
        return memberService.isAdmin(communityId, userId);
    }

    @Override
    public boolean checkEventAccessPermission(Integer eventId, Integer userId) {
        if (userId == null) {
            return false;
        }

        Event event = eventMapper.selectById(eventId);
        if (event == null) {
            throw new BusinessException(404, "事件不存在");
        }

        if (event.getCommunityId() == null) {
            return true;
        }

        return memberService.isMember(event.getCommunityId(), userId);
    }

    @Override
    public boolean checkRegistrationPermission(Integer eventId, Integer userId) {
        if (userId == null) {
            return false;
        }

        Event event = eventMapper.selectById(eventId);
        if (event == null) {
            throw new BusinessException(404, "事件不存在");
        }

        if (event.getCommunityId() == null) {
            return true;
        }

        return memberService.isMember(event.getCommunityId(), userId);
    }

    @Override
    public boolean checkCommunityAdminPermission(Integer communityId, Integer userId) {
        if (userId == null) {
            return false;
        }
        return memberService.isAdmin(communityId, userId);
    }

    @Override
    public boolean checkCommunityMemberPermission(Integer communityId, Integer userId) {
        if (userId == null) {
            return false;
        }
        return memberService.isMember(communityId, userId);
    }
}