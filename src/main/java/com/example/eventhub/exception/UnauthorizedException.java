package com.example.eventhub.exception;

/**
 * 未授权异常类
 * 用于处理认证失败或权限不足的情况
 */
public class UnauthorizedException extends RuntimeException {

    /**
     * 构造未授权异常
     * @param message 错误消息
     */
    public UnauthorizedException(String message) {
        super(message);
    }
}