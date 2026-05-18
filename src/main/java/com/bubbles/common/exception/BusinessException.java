package com.bubbles.common.exception;

/**
 * 业务异常类
 * 用于处理业务逻辑中的各种异常情况
 */
public class BusinessException extends RuntimeException {

    /**
     * 错误状态码
     */
    private final int code;

    /**
     * 错误消息
     */
    private final String message;

    /**
     * 构造业务异常
     * @param code 错误状态码
     * @param message 错误消息
     */
    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }

    /**
     * 获取错误状态码
     * @return 错误状态码
     */
    public int getCode() {
        return code;
    }

    @Override
    public String getMessage() {
        return message;
    }
}