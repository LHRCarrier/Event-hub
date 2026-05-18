package com.bubbles.server.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.beans.factory.config.YamlPropertiesFactoryBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.Properties;

/**
 * 应用配置类
 * 配置数据源和组件扫描
 */
@Configuration
@ComponentScan(
    basePackages = {"com.bubbles.common", "com.bubbles.pojo", "com.bubbles.server"},
    excludeFilters = {
        @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, classes = WebConfig.class)
    }
)
@EnableTransactionManagement
public class AppConfig {

    private final Environment environment;

    public AppConfig(Environment environment) {
        this.environment = environment;
    }

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        YamlPropertiesFactoryBean yamlBean = new YamlPropertiesFactoryBean();
        yamlBean.setResources(new ClassPathResource("application.yml"));
        configurer.setProperties(yamlBean.getObject());
        return configurer;
    }

    /**
     * 配置数据源
     * @return 数据源对象
     */
    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        YamlPropertiesFactoryBean yamlBean = new YamlPropertiesFactoryBean();
        yamlBean.setResources(new ClassPathResource("application.yml"));
        Properties props = yamlBean.getObject();
        
        if (props != null) {
            dataSource.setDriverClassName(props.getProperty("spring.datasource.driver-class-name"));
            dataSource.setUrl(props.getProperty("spring.datasource.url"));
            dataSource.setUsername(props.getProperty("spring.datasource.username"));
            dataSource.setPassword(props.getProperty("spring.datasource.password"));
        }
        return dataSource;
    }

    /**
     * 配置Jackson ObjectMapper
     * 放置在根上下文中，以便拦截器等Bean可以访问
     * @return ObjectMapper对象
     */
    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }
}
