package com.bubbles.common.exception;

/**
 * 访问被拒绝异常
 */
public class AccessDeniedException extends RuntimeException {

    public AccessDeniedException(String message) {
        super(message);
    }
}