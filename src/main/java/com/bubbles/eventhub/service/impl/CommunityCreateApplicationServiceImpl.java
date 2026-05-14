package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.request.CommunityCreateApplicationRequest;
import com.bubbles.eventhub.dto.response.CommunityCreateApplicationResponse;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.entity.Community;
import com.bubbles.eventhub.entity.CommunityCreateApplication;
import com.bubbles.eventhub.entity.CommunityMember;
import com.bubbles.eventhub.entity.User;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.CommunityCreateApplicationMapper;
import com.bubbles.eventhub.mapper.CommunityMapper;
import com.bubbles.eventhub.mapper.CommunityMemberMapper;
import com.bubbles.eventhub.mapper.UserMapper;
import com.bubbles.eventhub.service.CommunityCreateApplicationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 社区创建申请服务实现类
 */
@Service
public class CommunityCreateApplicationServiceImpl implements CommunityCreateApplicationService {

    private static final Logger logger = LoggerFactory.getLogger(CommunityCreateApplicationServiceImpl.class);

    private final CommunityCreateApplicationMapper applicationMapper;
    private final CommunityMapper communityMapper;
    private final CommunityMemberMapper memberMapper;
    private final UserMapper userMapper;

    public CommunityCreateApplicationServiceImpl(CommunityCreateApplicationMapper applicationMapper,
                                               CommunityMapper communityMapper,
                                               CommunityMemberMapper memberMapper,
                                               UserMapper userMapper) {
        this.applicationMapper = applicationMapper;
        this.communityMapper = communityMapper;
        this.memberMapper = memberMapper;
        this.userMapper = userMapper;
    }

    @Override
    @Transactional
    public CommunityCreateApplicationResponse applyToCreate(CommunityCreateApplicationRequest request, Integer applicantId) {
        if (applicationMapper.countByName(request.getName()) > 0) {
            throw new BusinessException(400, "社区名称已存在");
        }

        CommunityCreateApplication application = new CommunityCreateApplication();
        application.setName(request.getName());
        application.setDescription(request.getDescription());
        application.setLogoUrl(request.getLogoUrl());
        application.setApplicantId(applicantId);
        application.setStatus("PENDING");
        application.setApplyTime(new Date());

        applicationMapper.insert(application);
        logger.info("用户 {} 申请创建社区: {}", applicantId, request.getName());

        return convertToResponse(application);
    }

    @Override
    public PageResponse<CommunityCreateApplicationResponse> getAllApplications(String status, int page, int size) {
        Page<CommunityCreateApplication> pageRequest = new Page<>(page, size);
        LambdaQueryWrapper<CommunityCreateApplication> queryWrapper = new LambdaQueryWrapper<>();
        
        if (status != null && !status.isEmpty()) {
            queryWrapper.eq(CommunityCreateApplication::getStatus, status);
        }
        queryWrapper.orderByDesc(CommunityCreateApplication::getApplyTime);
        
        IPage<CommunityCreateApplication> pageResult = applicationMapper.selectPage(pageRequest, queryWrapper);
        
        logger.info("Fetched {} applications from database", pageResult.getRecords().size());
        if (!pageResult.getRecords().isEmpty()) {
            CommunityCreateApplication first = pageResult.getRecords().get(0);
            logger.info("First application: id={}, name={}, applicantId={}", 
                first.getApplicationId(), first.getName(), first.getApplicantId());
        }
        
        List<CommunityCreateApplicationResponse> list = pageResult.getRecords().stream()
                .map(this::convertToResponse)
                .toList();
        
        return new PageResponse<>(list, (int) pageResult.getTotal(), page, size);
    }

    @Override
    @Transactional
    public void approveApplication(Integer applicationId, Integer approverId) {
        CommunityCreateApplication application = applicationMapper.selectById(applicationId);
        if (application == null) {
            throw new BusinessException(404, "申请不存在");
        }

        if (!"PENDING".equals(application.getStatus())) {
            throw new BusinessException(400, "申请状态不允许操作");
        }

        Community community = new Community();
        community.setName(application.getName());
        community.setDescription(application.getDescription());
        community.setLogoUrl(application.getLogoUrl());
        community.setRequireApproval(true);
        community.setCreatorId(application.getApplicantId());
        community.setStatus("ACTIVE");
        community.setCreateTime(new Date());
        community.setUpdateTime(new Date());
        communityMapper.insert(community);

        CommunityMember member = new CommunityMember();
        member.setCommunityId(community.getCommunityId());
        member.setUserId(application.getApplicantId());
        member.setRole("ADMIN");
        member.setStatus("ACTIVE");
        member.setSource("DIRECT");
        member.setApplyTime(application.getApplyTime());
        member.setApproveTime(new Date());
        member.setApprovedBy(approverId);
        member.setJoinTime(new Date());
        memberMapper.insert(member);

        application.setStatus("APPROVED");
        application.setApproveTime(new Date());
        application.setApproveBy(approverId);
        applicationMapper.updateById(application);

        logger.info("管理员 {} 批准用户 {} 创建社区: {}", approverId, application.getApplicantId(), application.getName());
    }

    @Override
    @Transactional
    public void rejectApplication(Integer applicationId, Integer approverId, String reason) {
        CommunityCreateApplication application = applicationMapper.selectById(applicationId);
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

        logger.info("管理员 {} 拒绝用户 {} 创建社区的申请: {}", approverId, application.getApplicantId(), application.getName());
    }

    @Override
    public List<CommunityCreateApplicationResponse> getUserApplications(Integer userId) {
        List<CommunityCreateApplication> applications = applicationMapper.selectByApplicantId(userId);
        return applications.stream().map(this::convertToResponse).toList();
    }

    private CommunityCreateApplicationResponse convertToResponse(CommunityCreateApplication application) {
        CommunityCreateApplicationResponse response = new CommunityCreateApplicationResponse();
        response.setApplicationId(application.getApplicationId());
        response.setName(application.getName());
        response.setDescription(application.getDescription());
        response.setLogoUrl(application.getLogoUrl());
        response.setApplicantId(application.getApplicantId());
        response.setStatus(application.getStatus());
        response.setApplyTime(application.getApplyTime());
        response.setApproveTime(application.getApproveTime());
        response.setRejectReason(application.getRejectReason());

        User user = userMapper.selectById(application.getApplicantId());
        if (user != null) {
            response.setApplicantName(user.getUsername());
        }

        return response;
    }
}
