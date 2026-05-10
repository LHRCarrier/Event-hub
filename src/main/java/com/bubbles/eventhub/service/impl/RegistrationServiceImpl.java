package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.request.RegistrationRequest;
import com.bubbles.eventhub.dto.response.ParticipantResponse;
import com.bubbles.eventhub.dto.response.RegistrationResponse;
import com.bubbles.eventhub.entity.Event;
import com.bubbles.eventhub.entity.Registration;
import com.bubbles.eventhub.entity.User;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.EventMapper;
import com.bubbles.eventhub.mapper.RegistrationMapper;
import com.bubbles.eventhub.mapper.UserMapper;
import com.bubbles.eventhub.service.RegistrationService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 注册服务实现类
 * 负责处理事件注册和参与者管理的业务逻辑
 */
@Service
public class RegistrationServiceImpl implements RegistrationService {

    private final RegistrationMapper registrationMapper;
    private final EventMapper eventMapper;
    private final UserMapper userMapper;

    public RegistrationServiceImpl(RegistrationMapper registrationMapper, EventMapper eventMapper, UserMapper userMapper) {
        this.registrationMapper = registrationMapper;
        this.eventMapper = eventMapper;
        this.userMapper = userMapper;
    }

    /**
     * 用户注册参与事件
     * 特殊说明：注册时自动设置状态为REGISTERED；同一用户不能重复注册同一事件
     * @param request 注册请求参数，包含事件ID和用户ID
     * @throws BusinessException 事件不存在、用户不存在或已注册该事件时抛出异常
     */
    @Override
    @Transactional
    public void registerEvent(RegistrationRequest request) {
        Event event = eventMapper.selectById(request.getEventId());
        if (event == null) {
            throw new BusinessException(404, "事件不存在");
        }

        User user = userMapper.selectById(request.getUserId());
        if (user == null) {
            throw new BusinessException(404, "用户不存在");
        }

        if (registrationMapper.countByEventAndUser(request.getEventId(), request.getUserId()) > 0) {
            throw new BusinessException(400, "已注册该事件");
        }

        Registration registration = new Registration();
        registration.setEventId(request.getEventId());
        registration.setUserId(request.getUserId());
        registration.setStatus("REGISTERED");

        registrationMapper.insert(registration);
    }

    /**
     * 取消事件注册
     * @param registrationId 注册记录ID
     * @throws BusinessException 注册记录不存在时抛出异常
     */
    @Override
    @Transactional
    public void cancelRegistration(Integer registrationId) {
        Registration registration = registrationMapper.selectById(registrationId);
        if (registration == null) {
            throw new BusinessException(404, "注册记录不存在");
        }
        registrationMapper.deleteById(registrationId);
    }

    /**
     * 获取用户的注册记录列表
     * @param userId 用户ID
     * @return 用户参与的所有事件注册记录列表
     * @throws BusinessException 用户不存在时抛出异常
     */
    @Override
    public List<RegistrationResponse> getUserRegistrations(Integer userId) {
        if (userMapper.selectById(userId) == null) {
            throw new BusinessException(404, "用户不存在");
        }

        List<Registration> registrations = registrationMapper.findByUserId(userId);
        return registrations.stream()
            .map(this::convertToRegistrationResponse)
            .collect(Collectors.toList());
    }

    /**
     * 获取事件的参与者列表
     * @param eventId 事件ID
     * @return 参与该事件的所有用户信息列表
     * @throws BusinessException 事件不存在时抛出异常
     */
    @Override
    public List<ParticipantResponse> getEventParticipants(Integer eventId) {
        if (eventMapper.selectById(eventId) == null) {
            throw new BusinessException(404, "事件不存在");
        }

        List<Registration> registrations = registrationMapper.findByEventId(eventId);
        return registrations.stream()
            .map(this::convertToParticipantResponse)
            .collect(Collectors.toList());
    }

    /**
     * 获取事件的参与人数
     * @param eventId 事件ID
     * @return 该事件的已注册参与人数
     */
    @Override
    public int getParticipantCount(Integer eventId) {
        return registrationMapper.countByEventId(eventId);
    }

    /**
     * 获取注册记录总数
     * @return 系统中所有注册记录的数量
     */
    @Override
    public int getTotalRegistrations() {
        return registrationMapper.selectCount(null).intValue();
    }

    /**
     * 将Registration实体转换为RegistrationResponse
     * @param registration 注册实体
     * @return 注册响应对象，包含事件名称、日期和地点
     */
    private RegistrationResponse convertToRegistrationResponse(Registration registration) {
        RegistrationResponse response = new RegistrationResponse();
        response.setRegistrationId(registration.getRegistrationId());
        response.setEventId(registration.getEventId());

        Event event = eventMapper.selectById(registration.getEventId());
        if (event != null) {
            response.setEventName(event.getName());
            response.setDate(event.getDate());
            response.setLocation(event.getLocation());
        }

        response.setRegisterTime(registration.getRegisterTime());
        return response;
    }

    /**
     * 将Registration实体转换为ParticipantResponse
     * @param registration 注册实体
     * @return 参与者响应对象，包含用户基本信息
     */
    private ParticipantResponse convertToParticipantResponse(Registration registration) {
        ParticipantResponse response = new ParticipantResponse();

        User user = userMapper.selectById(registration.getUserId());
        if (user != null) {
            response.setUserId(user.getUserId());
            response.setUsername(user.getUsername());
            response.setRealName(user.getRealName());
            response.setEmail(user.getEmail());
        }

        response.setRegisterTime(registration.getRegisterTime());
        return response;
    }
}