package com.bubbles.eventhub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.eventhub.entity.Category;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 分类数据访问层接口
 * 继承MyBatis-Plus的BaseMapper，提供基本的CRUD操作
 */
@Mapper
public interface CategoryMapper extends BaseMapper<Category> {

    /**
     * 根据分类名称查询分类
     * @param name 分类名称
     * @return 匹配的分类对象，若不存在则返回null
     */
    @Select("SELECT * FROM categories WHERE name = #{name}")
    Category findByName(@Param("name") String name);
}