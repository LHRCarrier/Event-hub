package com.bubbles.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.pojo.entity.CommunityCategory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityCategoryMapper extends BaseMapper<CommunityCategory> {

    List<CommunityCategory> findByCommunityId(@Param("communityId") Integer communityId);

    CommunityCategory findByNameAndCommunityId(@Param("name") String name, @Param("communityId") Integer communityId);
}