package com.example.modernbbs.service;

import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User register(String username, String nickname, String password) {
        username = clean(username);
        nickname = clean(nickname);

        if (username.length() < 3 || username.length() > 32) {
            throw new IllegalArgumentException("用户名长度应为 3-32 位");
        }
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("用户名只能包含字母、数字和下划线");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("密码至少 6 位");
        }
        String normalizedUsername = username.toLowerCase(Locale.ROOT);
        if (userRepository.existsByNormalizedUsername(normalizedUsername)) {
            throw new IllegalArgumentException("用户名已经存在");
        }

        User user = new User();
        user.setUsername(username);
        user.setNickname(nickname.isBlank() ? username : nickname);
        user.setPasswordHash(passwordEncoder.encode(password));
        String numericCallSign = generateNumericCallSign(username);
        user.setCallSign(numericCallSign);
        user.setTelegramCode("T" + numericCallSign);
        user.setRole("USER");
        // 每位新登记入岛的元老默认归入“临高首都区 / 登陆点”，并拥有发帖与回复权限。
        user.setCouncilDepartment("待分配");
        user.setSpecialty("待补充");
        user.setStationScope("STRATEGIC");
        user.setStationName("临高首都区 / 登陆点");
        user.setStationElderCount(1);
        return userRepository.save(user);
    }

    public Optional<User> login(String username, String password) {
        String cleanUsername = clean(username).toLowerCase(Locale.ROOT);
        return userRepository.findByNormalizedUsername(cleanUsername)
                .filter(user -> "ACTIVE".equalsIgnoreCase(user.getStatus()))
                .filter(user -> passwordEncoder.matches(password == null ? "" : password, user.getPasswordHash()))
                .map(user -> {
                    user.setLastLoginAt(LocalDateTime.now());
                    userRepository.save(user);
                    return user;
                });
    }

    public Optional<User> findById(Long id) {
        if (id == null) return Optional.empty();
        return userRepository.findById(id);
    }

    public Optional<User> findPublicByUsername(String username) {
        String cleanUsername = clean(username).toLowerCase(Locale.ROOT);
        if (cleanUsername.isBlank()) {
            return Optional.empty();
        }
        return userRepository.findByNormalizedUsername(cleanUsername)
                .filter(user -> "ACTIVE".equalsIgnoreCase(user.getStatus()));
    }

    public Page<User> page(Pageable pageable) {
        return userRepository.findAll(pageable);
    }


    public Page<User> searchPublic(String keyword, Pageable pageable) {
        String cleanKeyword = clean(keyword);
        if (cleanKeyword.isBlank()) {
            return Page.empty(pageable);
        }
        return userRepository.searchPublic(cleanKeyword, pageable);
    }

    public long count() {
        return userRepository.count();
    }

    public long countAdmins() {
        return userRepository.countByRole("ADMIN");
    }

    public long countExecutives() {
        return userRepository.countByRole("EXECUTIVE");
    }


    @Transactional
    public User updateProfile(Long id, String nickname, String avatarUrl, String bio,
                              String councilDepartment, String specialty,
                              String callSign, String telegramCode,
                              String stationScope, String stationName, Integer stationElderCount) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("账号不存在"));

        String cleanNickname = clean(nickname);
        if (cleanNickname.isBlank()) {
            cleanNickname = user.getUsername();
        }
        if (cleanNickname.length() > 40) {
            throw new IllegalArgumentException("昵称不能超过 40 个字符");
        }

        String cleanAvatarUrl = clean(avatarUrl);
        if (!cleanAvatarUrl.isBlank() && cleanAvatarUrl.length() > 500) {
            throw new IllegalArgumentException("头像地址不能超过 500 个字符");
        }

        String cleanBio = clean(bio);
        if (cleanBio.length() > 500) {
            throw new IllegalArgumentException("个人简介不能超过 500 个字符");
        }

        String cleanDepartment = clean(councilDepartment);
        if (cleanDepartment.isBlank()) cleanDepartment = "待分配";
        if (cleanDepartment.length() > 80) {
            throw new IllegalArgumentException("所属部门不能超过 80 个字符");
        }

        String cleanSpecialty = clean(specialty);
        if (cleanSpecialty.length() > 120) {
            throw new IllegalArgumentException("职能专长不能超过 120 个字符");
        }

        String cleanCallSign = clean(callSign);
        if (cleanCallSign.isBlank()) cleanCallSign = generateNumericCallSign(user.getUsername());
        if (!cleanCallSign.matches("^\\d{3,12}$")) {
            throw new IllegalArgumentException("呼号必须是 3-12 位纯数字");
        }
        if (cleanCallSign.length() > 40) {
            throw new IllegalArgumentException("呼号不能超过 40 个字符");
        }

        String cleanTelegramCode = clean(telegramCode);
        if (cleanTelegramCode.isBlank()) cleanTelegramCode = "T" + cleanCallSign;
        if (cleanTelegramCode.length() > 40) {
            throw new IllegalArgumentException("电报号不能超过 40 个字符");
        }

        String scope = clean(stationScope).toUpperCase(Locale.ROOT);
        if (scope.isBlank()) scope = "STRATEGIC";
        if (!scope.equals("WORLD") && !scope.equals("CHINA") && !scope.equals("STRATEGIC")) {
            throw new IllegalArgumentException("驻点范围只能选择 WORLD、CHINA 或 STRATEGIC");
        }

        String cleanStationName = clean(stationName);
        if (cleanStationName.length() > 120) {
            throw new IllegalArgumentException("驻点名称不能超过 120 个字符");
        }

        int count = stationElderCount == null ? 1 : stationElderCount;
        if (count < 0 || count > 999999) {
            throw new IllegalArgumentException("同行元老数量应在 0 到 999999 之间");
        }

        user.setNickname(cleanNickname);
        user.setAvatarUrl(cleanAvatarUrl.isBlank() ? user.getAvatarUrl() : cleanAvatarUrl);
        user.setBio(cleanBio.isBlank() ? null : cleanBio);
        user.setCouncilDepartment(cleanDepartment);
        user.setSpecialty(cleanSpecialty.isBlank() ? null : cleanSpecialty);
        user.setCallSign(cleanCallSign);
        user.setTelegramCode(cleanTelegramCode);
        if (cleanStationName.isBlank()) {
            cleanStationName = "临高首都区 / 登陆点";
            scope = "STRATEGIC";
        }
        user.setStationScope(scope);
        user.setStationName(cleanStationName);
        user.setStationElderCount(count);
        return userRepository.save(user);
    }

    @Transactional
    public User adminUpdateUser(Long id, String nickname, String avatarUrl, String bio,
                                String councilDepartment, String specialty,
                                String callSign, String telegramCode,
                                String stationScope, String stationName, Integer stationElderCount,
                                String role, String status, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("账号不存在"));

        String cleanNickname = clean(nickname);
        if (cleanNickname.isBlank()) cleanNickname = user.getUsername();
        if (cleanNickname.length() > 40) throw new IllegalArgumentException("昵称不能超过 40 个字符");

        String cleanAvatarUrl = clean(avatarUrl);
        if (cleanAvatarUrl.length() > 500) throw new IllegalArgumentException("头像地址不能超过 500 个字符");

        String cleanBio = clean(bio);
        if (cleanBio.length() > 500) throw new IllegalArgumentException("档案简介不能超过 500 个字符");

        String cleanDepartment = clean(councilDepartment);
        if (cleanDepartment.isBlank()) cleanDepartment = "待分配";
        if (cleanDepartment.length() > 80) throw new IllegalArgumentException("所属部门不能超过 80 个字符");

        String cleanSpecialty = clean(specialty);
        if (cleanSpecialty.length() > 120) throw new IllegalArgumentException("职能专长不能超过 120 个字符");

        String cleanCallSign = clean(callSign);
        if (cleanCallSign.isBlank()) cleanCallSign = generateNumericCallSign(user.getUsername());
        if (!cleanCallSign.matches("^\\d{3,12}$")) throw new IllegalArgumentException("呼号必须是 3-12 位纯数字");

        String cleanTelegramCode = clean(telegramCode);
        if (cleanTelegramCode.isBlank()) cleanTelegramCode = "T" + cleanCallSign;
        if (cleanTelegramCode.length() > 40) throw new IllegalArgumentException("电报号不能超过 40 个字符");

        String scope = clean(stationScope).toUpperCase(Locale.ROOT);
        if (scope.isBlank()) scope = "STRATEGIC";
        if (!scope.equals("WORLD") && !scope.equals("CHINA") && !scope.equals("STRATEGIC")) {
            throw new IllegalArgumentException("驻点范围只能选择 WORLD、CHINA 或 STRATEGIC");
        }

        String cleanStationName = clean(stationName);
        if (cleanStationName.isBlank()) {
            cleanStationName = "临高首都区 / 登陆点";
            scope = "STRATEGIC";
        }
        if (cleanStationName.length() > 120) throw new IllegalArgumentException("驻点名称不能超过 120 个字符");

        int count = stationElderCount == null ? 1 : stationElderCount;
        if (count < 0 || count > 999999) throw new IllegalArgumentException("同行元老数量应在 0 到 999999 之间");

        String normalizedRole = clean(role).toUpperCase(Locale.ROOT);
        if (normalizedRole.isBlank()) normalizedRole = user.getRole();
        if (!normalizedRole.equals("ADMIN") && !normalizedRole.equals("EXECUTIVE") && !normalizedRole.equals("USER")) {
            throw new IllegalArgumentException("角色只能是 USER、EXECUTIVE 或 ADMIN");
        }
        if ("ADMIN".equalsIgnoreCase(user.getRole()) && !"ADMIN".equals(normalizedRole) && countAdmins() <= 1) {
            throw new IllegalArgumentException("至少需要保留一个管理员");
        }

        String normalizedStatus = clean(status).toUpperCase(Locale.ROOT);
        if (normalizedStatus.isBlank()) normalizedStatus = "ACTIVE";
        if (!normalizedStatus.equals("ACTIVE") && !normalizedStatus.equals("DISABLED") && !normalizedStatus.equals("BANNED")) {
            throw new IllegalArgumentException("状态只能是 ACTIVE、DISABLED 或 BANNED");
        }

        String cleanPassword = newPassword == null ? "" : newPassword.trim();
        if (!cleanPassword.isBlank()) {
            if (cleanPassword.length() < 6 || cleanPassword.length() > 72) {
                throw new IllegalArgumentException("新密码长度应为 6-72 位");
            }
            user.setPasswordHash(passwordEncoder.encode(cleanPassword));
        }

        user.setNickname(cleanNickname);
        user.setAvatarUrl(cleanAvatarUrl.isBlank() ? null : cleanAvatarUrl);
        user.setBio(cleanBio.isBlank() ? null : cleanBio);
        user.setCouncilDepartment(cleanDepartment);
        user.setSpecialty(cleanSpecialty.isBlank() ? null : cleanSpecialty);
        user.setCallSign(cleanCallSign);
        user.setTelegramCode(cleanTelegramCode);
        user.setStationScope(scope);
        user.setStationName(cleanStationName);
        user.setStationElderCount(count);
        user.setRole(normalizedRole);
        user.setStatus(normalizedStatus);
        return userRepository.save(user);
    }

    @Transactional
    public User changeRole(Long id, String role) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("账号不存在"));
        String normalized = clean(role).toUpperCase(Locale.ROOT);
        if (!normalized.equals("ADMIN") && !normalized.equals("EXECUTIVE") && !normalized.equals("USER")) {
            throw new IllegalArgumentException("角色只能是 USER、EXECUTIVE 或 ADMIN");
        }
        if ("ADMIN".equalsIgnoreCase(user.getRole()) && !"ADMIN".equals(normalized) && countAdmins() <= 1) {
            throw new IllegalArgumentException("至少需要保留一个管理员");
        }
        user.setRole(normalized);
        return userRepository.save(user);
    }

    private String generateNumericCallSign(String seed) {
        String value = seed == null || seed.isBlank() ? "yuanlao" : seed.trim().toLowerCase(Locale.ROOT);
        int hash = Math.abs(value.hashCode());
        return String.format(Locale.ROOT, "%06d", hash % 1000000);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}
