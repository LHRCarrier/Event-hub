package com.bubbles.pojo.dto.response;

import java.util.List;

/**
 * 分页响应数据传输对象
 * 用于封装分页查询的结果
 */
public class PageResponse<T> {

    /**
     * 数据列表
     */
    private List<T> list;

    /**
     * 总记录数
     */
    private int total;

    /**
     * 当前页码
     */
    private int page;

    /**
     * 每页数量
     */
    private int size;

    public PageResponse() {}

    public PageResponse(List<T> list, int total, int page, int size) {
        this.list = list;
        this.total = total;
        this.page = page;
        this.size = size;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}