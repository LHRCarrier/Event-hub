package com.bubbles.server.service.impl;

import com.bubbles.pojo.dto.request.EventCreateRequest;
import com.bubbles.pojo.dto.request.EventUpdateRequest;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.pojo.entity.Category;
import com.bubbles.pojo.entity.Event;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.mapper.CategoryMapper;
import com.bubbles.server.mapper.EventMapper;
import com.bubbles.server.mapper.RegistrationMapper;
import com.bubbles.server.service.EventService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 事件服务实现类
 * 负责处理事件的增删改查和搜索业务逻辑
 */
@Service
public class EventServiceImpl implements EventService {

    private final EventMapper eventMapper;
    private final CategoryMapper categoryMapper;
    private final RegistrationMapper registrationMapper;

    public EventServiceImpl(EventMapper eventMapper, CategoryMapper categoryMapper, RegistrationMapper registrationMapper) {
        this.eventMapper = eventMapper;
        this.categoryMapper = categoryMapper;
        this.registrationMapper = registrationMapper;
    }

    /**
     * 创建新事件
     * 特殊说明：创建时自动设置事件状态为UPCOMING
     * @param request 事件创建请求参数
     * @return 创建成功返回事件详情
     * @throws BusinessException 分类不存在时抛出异常
     */
    @Override
    @Transactional
    public EventResponse createEvent(EventCreateRequest request) {
        if (request.getCategoryId() != null) {
            Category category = categoryMapper.selectById(request.getCategoryId());
            if (category == null) {
                throw new BusinessException(400, "分类不存在");
            }
        }

        Event event = new Event();
        event.setName(request.getName());
        event.setDate(parseDateTime(request.getDate()));
        event.setLocation(request.getLocation());
        event.setDescription(request.getDescription());
        event.setCategoryId(request.getCategoryId());
        event.setStatus("UPCOMING");

        eventMapper.insert(event);
        return getEventById(event.getEventId());
    }

    @Override
    @Transactional
    public EventResponse createEvent(EventCreateRequest request, Integer userId) {
        return createEvent(request);
    }

    /**
     * 分页获取事件列表
     * 特殊说明：每次调用会自动更新过期事件的状态（UPCOMING -> PAST）
     * @param page 页码，从1开始
     * @param size 每页数量
     * @param keyword 搜索关键字（非必填）
     * @param categoryId 分类ID筛选（非必填）
     * @param status 事件状态筛选
     * @return 分页的事件列表
     */
    @Override
    public PageResponse<EventResponse> getEvents(int page, int size, String keyword, Integer categoryId, String status) {
        updateEventStatus();

        if (status == null) {
            status = "ALL";
        }
        if (keyword == null) {
            keyword = "";
        }

        List<Event> events;
        if ("ALL".equals(status)) {
            events = eventMapper.findAllWithCategory();
        } else if (categoryId != null) {
            events = eventMapper.findByCategoryId(categoryId);
        } else {
            events = eventMapper.findByStatus(status);
        }

        if (!keyword.isEmpty()) {
            String finalKeyword = keyword;
            events = events.stream()
                .filter(e -> e.getName().toLowerCase().contains(finalKeyword.toLowerCase()))
                .collect(Collectors.toList());
        }

        int total = events.size();
        int offset = (page - 1) * size;

        List<EventResponse> responses = events.stream()
            .skip(offset)
            .limit(size)
            .map(this::convertToResponse)
            .collect(Collectors.toList());

        return new PageResponse<>(responses, total, page, size);
    }

    /**
     * 根据事件ID获取事件详情
     * 特殊说明：调用时会自动更新过期事件的状态
     * @param eventId 事件ID
     * @return 事件详细信息
     * @throws BusinessException 事件不存在时抛出异常
     */
    @Override
    public EventResponse getEventById(Integer eventId) {
        updateEventStatus();

        Event event = eventMapper.selectById(eventId);
        if (event == null) {
            throw new BusinessException(404, "事件不存在");
        }
        return convertToResponse(event);
    }

    /**
     * 更新事件信息
     * 特殊说明：更新时如果日期发生变化，会在下次查询时自动更新状态
     * @param eventId 要更新的事件ID
     * @param request 事件更新请求参数，所有字段可选
     * @throws BusinessException 事件不存在或分类不存在时抛出异常
     */
    @Override
    @Transactional
    public void updateEvent(Integer eventId, EventUpdateRequest request) {
        Event event = eventMapper.selectById(eventId);
        if (event == null) {
            throw new BusinessException(404, "事件不存在");
        }

        if (request.getCategoryId() != null) {
            Category category = categoryMapper.selectById(request.getCategoryId());
            if (category == null) {
                throw new BusinessException(400, "分类不存在");
            }
            event.setCategoryId(request.getCategoryId());
        }

        if (request.getName() != null) {
            event.setName(request.getName());
        }
        if (request.getDate() != null) {
            event.setDate(parseDateTime(request.getDate()));
        }
        if (request.getLocation() != null) {
            event.setLocation(request.getLocation());
        }
        if (request.getDescription() != null) {
            event.setDescription(request.getDescription());
        }

        eventMapper.updateById(event);
    }

    @Override
    @Transactional
    public void updateEvent(Integer eventId, EventUpdateRequest request, Integer userId) {
        updateEvent(eventId, request);
    }

    /**
     * 删除事件
     * @param eventId 要删除的事件ID
     * @throws BusinessException 事件不存在时抛出异常
     */
    @Override
    @Transactional
    public void deleteEvent(Integer eventId) {
        if (eventMapper.selectById(eventId) == null) {
            throw new BusinessException(404, "事件不存在");
        }
        eventMapper.deleteById(eventId);
    }

    @Override
    @Transactional
    public void deleteEvent(Integer eventId, Integer userId) {
        deleteEvent(eventId);
    }

    /**
     * 搜索事件
     * @param keyword 搜索关键字
     * @param categoryId 分类ID筛选（非必填）
     * @param startDate 事件开始日期筛选下限（非必填）
     * @param endDate 事件开始日期筛选上限（非必填）
     * @return 符合条件的事件列表
     */
    @Override
    public List<EventResponse> searchEvents(String keyword, Integer categoryId, String startDate, String endDate) {
        List<Event> events;

        if (categoryId != null) {
            events = eventMapper.findByCategoryId(categoryId);
        } else {
            events = eventMapper.findAllWithCategory();
        }

        if (keyword != null && !keyword.isEmpty()) {
            events = events.stream()
                .filter(e -> e.getName().toLowerCase().contains(keyword.toLowerCase()))
                .collect(Collectors.toList());
        }

        return events.stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList());
    }

    /**
     * 获取事件总数
     * @return 系统中事件的总数量
     */
    @Override
    public int getTotalEvents() {
        return eventMapper.selectCount(null).intValue();
    }

    /**
     * 获取即将到来的事件数量
     * @return 状态为UPCOMING的事件数量
     */
    @Override
    public int getUpcomingEvents() {
        return eventMapper.findByStatus("UPCOMING").size();
    }

    @Override
    public PageResponse<EventResponse> getEventsByCommunity(Integer communityId, int page, int size) {
        updateEventStatus();
        
        List<Event> events = eventMapper.findByCommunityId(communityId);
        int total = events.size();
        int offset = (page - 1) * size;

        List<EventResponse> responses = events.stream()
            .skip(offset)
            .limit(size)
            .map(this::convertToResponse)
            .collect(Collectors.toList());

        return new PageResponse<>(responses, total, page, size);
    }

    @Override
    public List<EventResponse> getUpcomingEventsByCommunity(Integer communityId) {
        updateEventStatus();
        
        return eventMapper.findByCommunityIdAndStatus(communityId, "UPCOMING").stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList());
    }

    /**
     * 更新过期事件状态
     * 特殊说明：自动将已过期的UPCOMING事件状态更新为PAST
     */
    private void updateEventStatus() {
        List<Event> events = eventMapper.selectList(null);
        Date now = new Date();
        for (Event event : events) {
            if ("UPCOMING".equals(event.getStatus()) && event.getDate() != null && event.getDate().before(now)) {
                event.setStatus("PAST");
                eventMapper.updateById(event);
            }
        }
    }

    /**
     * 将Event实体转换为EventResponse
     * @param event 事件实体
     * @return 事件响应对象，包含分类名称和参与人数
     */
    private EventResponse convertToResponse(Event event) {
        EventResponse response = new EventResponse();
        response.setEventId(event.getEventId());
        response.setName(event.getName());
        response.setDate(event.getDate());
        response.setLocation(event.getLocation());
        response.setDescription(event.getDescription());
        response.setCategoryId(event.getCategoryId());

        if (event.getCategoryId() != null) {
            Category category = categoryMapper.selectById(event.getCategoryId());
            if (category != null) {
                response.setCategoryName(category.getName());
            }
        }

        response.setStatus(event.getStatus());
        response.setParticipantCount(registrationMapper.countByEventId(event.getEventId()));
        response.setCreateTime(event.getCreateTime());

        return response;
    }

    /**
     * 解析日期时间字符串
     * @param dateTimeStr 日期时间字符串，格式：yyyy-MM-dd HH:mm
     * @return Date对象
     * @throws BusinessException 日期格式不正确时抛出异常
     */
    private Date parseDateTime(String dateTimeStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            return sdf.parse(dateTimeStr);
        } catch (ParseException e) {
            throw new BusinessException(400, "日期格式不正确，应为 yyyy-MM-dd HH:mm");
        }
    }
}