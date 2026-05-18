package com.bubbles.server.service.impl;

import com.bubbles.pojo.dto.request.LoginRequest;
import com.bubbles.pojo.dto.request.RegisterRequest;
import com.bubbles.pojo.dto.response.LoginResponse;
import com.bubbles.pojo.entity.User;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.mapper.UserMapper;
import com.bubbles.server.service.AuthService;
import com.bubbles.common.utils.JwtUtil;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 认证服务实现类
 * 负责处理用户登录和注册的具体业务逻辑
 */
@Service
public class AuthServiceImpl implements AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthServiceImpl.class);

    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;

    public AuthServiceImpl(UserMapper userMapper, JwtUtil jwtUtil) {
        this.userMapper = userMapper;
        this.jwtUtil = jwtUtil;
    }

    /**
     * 用户登录
     * 验证用户名和密码，成功后生成JWT令牌返回
     * @param request 登录请求参数，包含用户名和密码
     * @return 登录成功返回用户ID、用户名、角色和JWT令牌
     * @throws BusinessException 用户名不存在或密码错误时抛出异常
     */
    @Override
    public LoginResponse login(LoginRequest request) {
        logger.info("用户登录请求: username={}", request.getUsername());

        User user = userMapper.findByUsername(request.getUsername());
        if (user == null) {
            logger.warn("登录失败: 用户不存在 - username={}", request.getUsername());
            throw new BusinessException(400, "用户名或密码错误");
        }

        if (!BCrypt.checkpw(request.getPassword(), user.getPassword())) {
            logger.warn("登录失败: 密码错误 - username={}", request.getUsername());
            throw new BusinessException(400, "用户名或密码错误");
        }

        String token = jwtUtil.generateToken(user.getUserId(), user.getUsername(), user.getRole());
        logger.info("用户登录成功: userId={}, username={}, role={}", user.getUserId(), user.getUsername(), user.getRole());
        return new LoginResponse(user.getUserId(), user.getUsername(), user.getRole(), token);
    }

    /**
     * 用户注册
     * 创建新用户账号，密码使用BCrypt加密存储
     * 特殊说明：注册时自动设置用户角色为USER，状态为ACTIVE
     * @param request 注册请求参数，包含用户名、密码、邮箱等
     * @throws BusinessException 用户名已存在或邮箱已被注册时抛出异常
     */
    @Override
    @Transactional
    public void register(RegisterRequest request) {
        logger.info("用户注册请求: username={}, email={}", request.getUsername(), request.getEmail());

        if (userMapper.findByUsername(request.getUsername()) != null) {
            logger.warn("注册失败: 用户名已存在 - username={}", request.getUsername());
            throw new BusinessException(400, "用户名已存在");
        }

        if (userMapper.findByEmail(request.getEmail()) != null) {
            logger.warn("注册失败: 邮箱已被注册 - email={}", request.getEmail());
            throw new BusinessException(400, "邮箱已被注册");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(BCrypt.hashpw(request.getPassword(), BCrypt.gensalt()));
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRealName(request.getRealName());
        user.setRole("USER");
        user.setStatus("ACTIVE");

        logger.debug("准备插入用户数据: {}", user);
        userMapper.insert(user);
        logger.info("用户注册成功: username={}, email={}", request.getUsername(), request.getEmail());
    }
}
