package com.example.demo.config;

import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// @Configuration   // ingress 사용 -> 백엔드 내부 CORS 처리 삭제
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            // .allowedOrigins("http://localhost:5173")
            // .allowedOrigins("http://localhost:8011")
            .allowedOrigins("http://localhost:30000")   // 프론트 요청이 30000번으로 온다.
            .allowedMethods("GET", "POST", "PUT", "DELETE");
    }
}