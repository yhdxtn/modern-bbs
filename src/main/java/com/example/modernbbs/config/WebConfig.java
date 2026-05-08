package com.example.modernbbs.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    private final AuthInterceptor authInterceptor;
    private final AdminInterceptor adminInterceptor;
    private final RateLimitInterceptor rateLimitInterceptor;
    private final String uploadRoot;

    public WebConfig(AuthInterceptor authInterceptor,
                     AdminInterceptor adminInterceptor,
                     RateLimitInterceptor rateLimitInterceptor,
                     @Value("${app.upload.root:uploads}") String uploadRoot) {
        this.authInterceptor = authInterceptor;
        this.adminInterceptor = adminInterceptor;
        this.rateLimitInterceptor = rateLimitInterceptor;
        this.uploadRoot = uploadRoot;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(rateLimitInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/captcha", "/captcha/**",
                        "/css/**", "/js/**", "/images/**", "/uploads/**",
                        "/favicon.ico", "/error"
                );

        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/posts/new", "/posts", "/posts/images", "/posts/*/delete", "/posts/*/comments", "/posts/*/comments/*/like", "/posts/*/comments/*/delete", "/profile", "/uploads/images", "/department/banners", "/department/banners/**", "/messages", "/messages/**", "/notifications", "/notifications/**");

        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/admin/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = Path.of(uploadRoot).toAbsolutePath().normalize().toUri().toString();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(location);
    }
}
