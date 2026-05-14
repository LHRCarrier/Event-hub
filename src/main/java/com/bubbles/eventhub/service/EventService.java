package com.bubbles.eventhub.service;

import com.bubbles.eventhub.dto.request.EventCreateRequest;
import com.bubbles.eventhub.dto.request.EventUpdateRequest;
import com.bubbles.eventhub.dto.response.EventResponse;
import com.bubbles.eventhub.dto.response.PageResponse;

import java.util.List;

/**
 * 事件服务接口
 * 提供事件的增删改查和搜索功能
 */
public interface EventService {

    /**
     * 创建新事件
     * @param request 事件创建请求参数，包含名称、日期、地点、描述和分类ID
     * @return 创建成功返回事件详情
     * @throws BusinessException 分类不存在时抛出异常
     */
    EventResponse createEvent(EventCreateRequest request);

    EventResponse createEvent(EventCreateRequest request, Integer userId);

    /**
     * 分页获取事件列表
     * 支持按关键字、分类ID和状态筛选
     * @param page 页码，从1开始
     * @param size 每页数量
     * @param keyword 搜索关键字（非必填）
     * @param categoryId 分类ID筛选（非必填）
     * @param status 事件状态筛选，可选值：ALL、UPCOMING、PAST等
     * @return 分页的事件列表
     */
    PageResponse<EventResponse> getEvents(int page, int size, String keyword, Integer categoryId, String status);

    /**
     * 根据事件ID获取事件详情
     * @param eventId 事件ID
     * @return 事件详细信息
     * @throws BusinessException 事件不存在时抛出异常
     */
    EventResponse getEventById(Integer eventId);

    /**
     * 更新事件信息
     * @param eventId 要更新的事件ID
     * @param request 事件更新请求参数
     * @throws BusinessException 事件不存在或分类不存在时抛出异常
     */
    void updateEvent(Integer eventId, EventUpdateRequest request);

    void updateEvent(Integer eventId, EventUpdateRequest request, Integer userId);

    /**
     * 删除事件
     * @param eventId 要删除的事件ID
     * @throws BusinessException 事件不存在时抛出异常
     */
    void deleteEvent(Integer eventId);

    void deleteEvent(Integer eventId, Integer userId);

    /**
     * 搜索事件
     * 支持按关键字和分类ID进行筛选
     * @param keyword 搜索关键字
     * @param categoryId 分类ID筛选（非必填）
     * @param startDate 事件开始日期筛选下限（非必填）
     * @param endDate 事件开始日期筛选上限（非必填）
     * @return 符合条件的事件列表
     */
    List<EventResponse> searchEvents(String keyword, Integer categoryId, String startDate, String endDate);

    /**
     * 获取事件总数
     * @return 系统中事件的总数量
     */
    int getTotalEvents();

    /**
     * 获取即将到来的事件数量
     * @return 状态为UPCOMING的事件数量
     */
    int getUpcomingEvents();

    PageResponse<EventResponse> getEventsByCommunity(Integer communityId, int page, int size);

    List<EventResponse> getUpcomingEventsByCommunity(Integer communityId);
}