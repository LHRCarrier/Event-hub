package com.bubbles.server.service;

import com.bubbles.pojo.dto.request.RegistrationRequest;
import com.bubbles.pojo.dto.response.ParticipantResponse;
import com.bubbles.pojo.dto.response.RegistrationResponse;
import com.bubbles.common.exception.BusinessException;

import java.util.List;

/**
 * 注册服务接口
 * 提供事件注册和参与者管理功能
 */
public interface RegistrationService {

    /**
     * 用户注册参与事件
     * @param request 注册请求参数，包含事件ID和用户ID
     * @throws BusinessException 事件不存在、用户不存在或已注册该事件时抛出异常
     */
    void registerEvent(RegistrationRequest request);

    /**
     * 取消事件注册
     * @param registrationId 注册记录ID
     * @throws BusinessException 注册记录不存在时抛出异常
     */
    void cancelRegistration(Integer registrationId);

    /**
     * 获取用户的注册记录列表
     * @param userId 用户ID
     * @return 用户参与的所有事件注册记录列表
     * @throws BusinessException 用户不存在时抛出异常
     */
    List<RegistrationResponse> getUserRegistrations(Integer userId);

    /**
     * 获取事件的参与者列表
     * @param eventId 事件ID
     * @return 参与该事件的所有用户信息列表
     * @throws BusinessException 事件不存在时抛出异常
     */
    List<ParticipantResponse> getEventParticipants(Integer eventId);

    /**
     * 获取事件的参与人数
     * @param eventId 事件ID
     * @return 该事件的已注册参与人数
     */
    int getParticipantCount(Integer eventId);

    /**
     * 获取注册记录总数
     * @return 系统中所有注册记录的数量
     */
    int getTotalRegistrations();

    /**
     * 检查用户是否已注册指定事件
     * @param eventId 事件ID
     * @param userId 用户ID
     * @return 如果已注册返回true，否则返回false
     */
    boolean checkRegistration(Integer eventId, Integer userId);
}