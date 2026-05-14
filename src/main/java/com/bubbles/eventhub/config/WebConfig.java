package com.bubbles.eventhub.config;

import com.bubbles.eventhub.interceptor.CommunityPermissionInterceptor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import java.nio.charset.StandardCharsets;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;
import java.util.List;

/**
 * Web配置类
 * 配置JSON序列化、CORS跨域和HTTP消息转换器
 */
@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"com.bubbles.eventhub.controller", "com.bubbles.eventhub.service", "com.bubbles.eventhub.mapper", "com.bubbles.eventhub.util"})
public class WebConfig implements WebMvcConfigurer {

    private final CommunityPermissionInterceptor communityPermissionInterceptor;

    public WebConfig(CommunityPermissionInterceptor communityPermissionInterceptor) {
        this.communityPermissionInterceptor = communityPermissionInterceptor;
    }

    /**
     * 配置ObjectMapper
     * 禁用将日期时间以时间戳形式输出
     * @return ObjectMapper对象
     */
    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }

    /**
     * 配置Jackson HTTP消息转换器
     * @param objectMapper ObjectMapper对象
     * @return MappingJackson2HttpMessageConverter对象
     */
    @Bean
    public MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter(ObjectMapper objectMapper) {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setObjectMapper(objectMapper);
        converter.setSupportedMediaTypes(Arrays.asList(
            MediaType.APPLICATION_JSON
        ));
        return converter;
    }

    /**
     * 配置HTTP消息转换器列表
     * @param converters 转换器列表
     */
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        converters.add(stringConverter);
        converters.add(mappingJackson2HttpMessageConverter(objectMapper()));
    }

    /**
     * 配置默认Servlet处理器，用于处理静态资源
     * @param configurer 配置器
     */
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    /**
     * 配置CORS跨域资源共享
     * 允许所有来源、所有方法和所有请求头
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("*")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .maxAge(3600);
    }

    /**
     * 配置静态资源处理器
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
            .addResourceLocations("/static/");

        registry.addResourceHandler("/swagger-ui/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/swagger-ui/5.17.14/")
            .setCachePeriod(3600);

        registry.addResourceHandler("/webjars/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/")
            .setCachePeriod(3600);
    }

    /**
     * 配置视图控制器，设置Swagger UI入口
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addRedirectViewController("/swagger-ui.html", "/swagger-ui/index.html");
        registry.addRedirectViewController("/doc.html", "/swagger-ui/index.html");
    }

    /**
     * 配置拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(communityPermissionInterceptor)
                .addPathPatterns("/api/c/**");
    }
}