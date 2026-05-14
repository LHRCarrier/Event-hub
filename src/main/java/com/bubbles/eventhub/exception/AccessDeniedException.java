package com.bubbles.eventhub.exception;

/**
 * 访问被拒绝异常
 */
public class AccessDeniedException extends RuntimeException {

    public AccessDeniedException(String message) {
        super(message);
    }
}