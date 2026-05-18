package com.bubbles.server.service.impl;

import com.bubbles.pojo.dto.request.CommunityApplyRequest;
import com.bubbles.pojo.dto.response.CommunityApplicationResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.pojo.entity.Community;
import com.bubbles.pojo.entity.CommunityApplication;
import com.bubbles.pojo.entity.CommunityMember;
import com.bubbles.pojo.entity.User;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.mapper.CommunityApplicationMapper;
import com.bubbles.server.mapper.CommunityMapper;
import com.bubbles.server.mapper.CommunityMemberMapper;
import com.bubbles.server.mapper.UserMapper;
import com.bubbles.server.service.CommunityApplicationService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 社区加入申请服务实现类
 */
@Service
public class CommunityApplicationServiceImpl implements CommunityApplicationService {

    private static final Logger logger = LoggerFactory.getLogger(CommunityApplicationServiceImpl.class);

    private final CommunityApplicationMapper applicationMapper;
    private final CommunityMapper communityMapper;
    private final UserMapper userMapper;
    private final CommunityMemberMapper memberMapper;

    public CommunityApplicationServiceImpl(CommunityApplicationMapper applicationMapper,
                                          CommunityMapper communityMapper,
                                          UserMapper userMapper,
                                          CommunityMemberMapper memberMapper) {
        this.applicationMapper = applicationMapper;
        this.communityMapper = communityMapper;
        this.userMapper = userMapper;
        this.memberMapper = memberMapper;
    }

    @Override
    @Transactional
    public CommunityApplicationResponse applyToJoin(Integer communityId, Integer userId, CommunityApplyRequest request) {
        Community community = communityMapper.selectById(communityId);
        if (community == null || !"ACTIVE".equals(community.getStatus())) {
            throw new BusinessException(404, "社区不存在或已停用");
        }

        CommunityMember existingMember = memberMapper.selectByCommunityAndUser(communityId, userId);
        if (existingMember != null && "ACTIVE".equals(existingMember.getStatus())) {
            throw new BusinessException(400, "您已加入该社区");
        }

        if (hasPendingApplication(communityId, userId)) {
            throw new BusinessException(400, "您已提交过申请，请等待审批");
        }

        CommunityApplication application = new CommunityApplication();
        application.setCommunityId(communityId);
        application.setUserId(userId);
        application.setMessage(request != null ? request.getMessage() : null);
        application.setStatus("PENDING");
        application.setApplyTime(new Date());

        applicationMapper.insert(application);
        logger.info("用户 {} 申请加入社区 {}", userId, communityId);

        return convertToResponse(application);
    }

    @Override
    public PageResponse<CommunityApplicationResponse> getApplicationsByCommunity(Integer communityId, String status, int page, int size) {
        Page<CommunityApplication> pageRequest = new Page<>(page, size);
        IPage<CommunityApplication> pageResult;
        
        if (status != null && !status.isEmpty()) {
            pageResult = applicationMapper.selectPageByCommunityAndStatus(pageRequest, communityId, status);
        } else {
            pageResult = applicationMapper.selectPage(pageRequest,
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<CommunityApplication>()
                    .eq(CommunityApplication::getCommunityId, communityId)
            );
        }
        
        List<CommunityApplicationResponse> list = pageResult.getRecords().stream()
                .map(this::convertToResponse)
                .toList();
        
        return new PageResponse<>(list, (int) pageResult.getTotal(), page, size);
    }

    @Override
    @Transactional
    public void approveApplication(Integer applicationId, Integer approverId) {
        CommunityApplication application = applicationMapper.selectById(applicationId);
        if (application == null) {
            throw new BusinessException(404, "申请不存在");
        }

        if (!"PENDING".equals(application.getStatus())) {
            throw new BusinessException(400, "申请状态不允许操作");
        }

        application.setStatus("APPROVED");
        application.setApproveTime(new Date());
        application.setApproveBy(approverId);
        applicationMapper.updateById(application);

        CommunityMember member = new CommunityMember();
        member.setCommunityId(application.getCommunityId());
        member.setUserId(application.getUserId());
        member.setRole("MEMBER");
        member.setStatus("ACTIVE");
        member.setSource("APPLICATION");
        member.setApplyTime(application.getApplyTime());
        member.setApproveTime(new Date());
        member.setApprovedBy(approverId);
        member.setJoinTime(new Date());
        memberMapper.insert(member);

        logger.info("管理员 {} 批准用户 {} 加入社区 {}", approverId, application.getUserId(), application.getCommunityId());
    }

    @Override
    @Transactional
    public void rejectApplication(Integer applicationId, Integer approverId, String reason) {
        CommunityApplication application = applicationMapper.selectById(applicationId);
        if (application == null) {
            throw new BusinessException(404, "申请不存在");
        }

        if (!"PENDING".equals(application.getStatus())) {
            throw new BusinessException(400, "申请状态不允许操作");
        }

        application.setStatus("REJECTED");
        application.setApproveTime(new Date());
        application.setApproveBy(approverId);
        application.setRejectReason(reason);
        applicationMapper.updateById(application);

        logger.info("管理员 {} 拒绝用户 {} 加入社区 {}，原因：{}", approverId, application.getUserId(), application.getCommunityId(), reason);
    }

    @Override
    public PageResponse<CommunityApplicationResponse> getUserApplications(Integer userId, int page, int size) {
        Page<CommunityApplication> pageRequest = new Page<>(page, size);
        IPage<CommunityApplication> pageResult = applicationMapper.selectPageByUserId(pageRequest, userId);
        
        List<CommunityApplicationResponse> list = pageResult.getRecords().stream()
                .map(this::convertToResponse)
                .toList();
        
        return new PageResponse<>(list, (int) pageResult.getTotal(), page, size);
    }

    @Override
    public boolean hasPendingApplication(Integer communityId, Integer userId) {
        return applicationMapper.countPendingApplications(communityId, userId) > 0;
    }

    @Override
    public int countPendingApplications(Integer communityId) {
        return applicationMapper.countPendingApplicationsByCommunity(communityId);
    }

    private CommunityApplicationResponse convertToResponse(CommunityApplication application) {
        CommunityApplicationResponse response = new CommunityApplicationResponse();
        response.setApplicationId(application.getApplicationId());
        response.setCommunityId(application.getCommunityId());
        response.setUserId(application.getUserId());
        response.setMessage(application.getMessage());
        response.setStatus(application.getStatus());
        response.setApplyTime(application.getApplyTime());
        response.setApproveTime(application.getApproveTime());
        response.setRejectReason(application.getRejectReason());

        Community community = communityMapper.selectById(application.getCommunityId());
        if (community != null) {
            response.setCommunityName(community.getName());
        }

        User user = userMapper.selectById(application.getUserId());
        if (user != null) {
            response.setUsername(user.getUsername());
        }

        return response;
    }
}