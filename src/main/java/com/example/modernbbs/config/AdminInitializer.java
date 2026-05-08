package com.example.modernbbs.config;

import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Locale;

@Component
public class AdminInitializer implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(AdminInitializer.class);

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.admin.default-username:admin}")
    private String defaultUsername;

    @Value("${app.admin.default-password:admin123456}")
    private String defaultPassword;

    @Value("${app.admin.default-nickname:系统管理员}")
    private String defaultNickname;

    public AdminInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        userRepository.findByNormalizedUsername(defaultUsername.trim().toLowerCase(Locale.ROOT)).ifPresentOrElse(user -> {
            if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
                user.setRole("ADMIN");
                userRepository.save(user);
                log.info("Existing user '{}' has been promoted to ADMIN.", defaultUsername);
            }
        }, () -> {
            User admin = new User();
            admin.setUsername(defaultUsername);
            admin.setNickname(defaultNickname);
            admin.setPasswordHash(passwordEncoder.encode(defaultPassword));
            admin.setRole("ADMIN");
            userRepository.save(admin);
            log.info("Default admin created. username='{}', password='{}'", defaultUsername, defaultPassword);
        });
    }
}
