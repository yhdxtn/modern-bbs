package com.example.modernbbs.service;

import com.example.modernbbs.model.CouncilLocation;
import com.example.modernbbs.model.SiteSetting;
import com.example.modernbbs.repository.CouncilLocationRepository;
import com.example.modernbbs.repository.SiteSettingRepository;
import com.example.modernbbs.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class DashboardService {
    public static final String SCOPE_WORLD = "WORLD";
    public static final String SCOPE_CHINA = "CHINA";
    public static final String SCOPE_STRATEGIC = "STRATEGIC";

    /** 兼容旧版本字段：不再作为首页时间的核心逻辑。 */
    public static final String KEY_NST_OFFSET_HOURS = "new_world_utc_offset_hours";
    public static final String KEY_NST_LABEL = "new_world_timezone_label";
    public static final String KEY_NST_BASE_DATETIME = "new_world_base_datetime";
    public static final String KEY_NST_SYNC_EPOCH_MS = "new_world_sync_epoch_ms";
    public static final String DEFAULT_NEW_WORLD_DATETIME = "1638-05-06T08:00:00";

    private final SiteSettingRepository siteSettingRepository;
    private final CouncilLocationRepository councilLocationRepository;
    private final UserRepository userRepository;

    public DashboardService(SiteSettingRepository siteSettingRepository,
                            CouncilLocationRepository councilLocationRepository,
                            UserRepository userRepository) {
        this.siteSettingRepository = siteSettingRepository;
        this.councilLocationRepository = councilLocationRepository;
        this.userRepository = userRepository;
    }

    public int getNewWorldOffsetHours() {
        String value = getSetting(KEY_NST_OFFSET_HOURS, "8");
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return 8;
        }
    }

    public String getNewWorldLabel() {
        return getSetting(KEY_NST_LABEL, "新世界标准时 NST");
    }

    public String getNewWorldBaseDateTime() {
        String value = getSetting(KEY_NST_BASE_DATETIME, DEFAULT_NEW_WORLD_DATETIME);
        return parseDateTime(value).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    public String getNewWorldDateTimeInputValue() {
        String iso = getNewWorldBaseDateTime();
        return iso.length() >= 16 ? iso.substring(0, 16) : DEFAULT_NEW_WORLD_DATETIME.substring(0, 16);
    }

    public long getNewWorldSyncEpochMillis() {
        String value = getSetting(KEY_NST_SYNC_EPOCH_MS, "0");
        try {
            long parsed = Long.parseLong(value.trim());
            return parsed > 0 ? parsed : System.currentTimeMillis();
        } catch (NumberFormatException ex) {
            return System.currentTimeMillis();
        }
    }

    public String getSetting(String key, String defaultValue) {
        return siteSettingRepository.findById(key)
                .map(SiteSetting::getSettingValue)
                .orElse(defaultValue);
    }

    public List<CouncilLocation> visibleLocations(String scope) {
        return councilLocationRepository.findByScopeAndVisibleTrueOrderBySortOrderAscNameAsc(normalizeScope(scope));
    }

    public List<CouncilLocation> allLocations(String scope) {
        return councilLocationRepository.findByScopeOrderBySortOrderAscNameAsc(normalizeScope(scope));
    }

    public List<Map<String, Object>> visibleMapData(String scope) {
        return combinedDistribution(scope).entrySet().stream()
                .map(entry -> Map.<String, Object>of(
                        "name", entry.getKey(),
                        "value", entry.getValue()))
                .toList();
    }

    public long totalVisible(String scope) {
        return combinedDistribution(scope).values().stream()
                .mapToLong(value -> value == null ? 0 : value)
                .sum();
    }

    private Map<String, Integer> combinedDistribution(String scope) {
        String normalizedScope = normalizeScope(scope);
        Map<String, Integer> merged = new LinkedHashMap<>();

        for (CouncilLocation location : visibleLocations(normalizedScope)) {
            merged.put(location.getName(), location.getValue() == null ? 0 : location.getValue());
        }

        for (Object[] row : userRepository.sumStationEldersByScope(normalizedScope)) {
            if (row == null || row.length < 2 || row[0] == null || row[1] == null) {
                continue;
            }
            String name = row[0].toString().trim();
            if (name.isBlank()) {
                continue;
            }
            int count = ((Number) row[1]).intValue();
            merged.merge(name, count, Integer::sum);
        }

        return merged;
    }

    public CouncilLocation mustFindLocation(Long id) {
        return councilLocationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("驻点记录不存在"));
    }

    @Transactional
    public void updateNewWorldTime(String newWorldDateTime, String label) {
        LocalDateTime parsedTime = parseDateTime(newWorldDateTime);
        if (parsedTime.getYear() < 1000 || parsedTime.getYear() > 2500) {
            throw new IllegalArgumentException("年份建议填写 1000 到 2500 之间，例如 1638-05-06 08:00");
        }
        String cleanLabel = clean(label);
        if (cleanLabel.isBlank()) {
            cleanLabel = "新世界标准时 NST";
        }
        upsertSetting(KEY_NST_BASE_DATETIME,
                parsedTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME),
                "管理员设定的新世界当前时间，例如 1638-05-06T08:00:00");
        upsertSetting(KEY_NST_SYNC_EPOCH_MS,
                String.valueOf(System.currentTimeMillis()),
                "保存新世界时间时对应的现实世界毫秒时间戳，用于首页继续走秒");
        upsertSetting(KEY_NST_LABEL, cleanLabel, "新世界时间显示名称");
    }

    /** 兼容旧控制器或旧模板的调用。 */
    @Transactional
    public void updateNewWorldTime(int offsetHours, String label) {
        if (offsetHours < -12 || offsetHours > 14) {
            throw new IllegalArgumentException("UTC 偏移建议填写 -12 到 14 之间的整数");
        }
        upsertSetting(KEY_NST_OFFSET_HOURS, String.valueOf(offsetHours), "旧版字段：新世界时间相对 UTC 的小时偏移");
        String cleanLabel = clean(label);
        if (!cleanLabel.isBlank()) {
            upsertSetting(KEY_NST_LABEL, cleanLabel, "新世界时间显示名称");
        }
    }

    @Transactional
    public CouncilLocation createLocation(String scope, String name, Integer value, Integer sortOrder, boolean visible) {
        CouncilLocation location = new CouncilLocation();
        fillLocation(location, scope, name, value, sortOrder, visible);
        return councilLocationRepository.save(location);
    }

    @Transactional
    public CouncilLocation updateLocation(Long id, String scope, String name, Integer value, Integer sortOrder, boolean visible) {
        CouncilLocation location = mustFindLocation(id);
        fillLocation(location, scope, name, value, sortOrder, visible);
        return councilLocationRepository.save(location);
    }

    @Transactional
    public void deleteLocation(Long id) {
        CouncilLocation location = mustFindLocation(id);
        councilLocationRepository.delete(location);
    }

    private void upsertSetting(String key, String value, String description) {
        SiteSetting setting = siteSettingRepository.findById(key)
                .orElseGet(() -> new SiteSetting(key, value, description));
        setting.setSettingValue(value);
        setting.setDescription(description);
        siteSettingRepository.save(setting);
    }

    private LocalDateTime parseDateTime(String value) {
        String cleanValue = clean(value);
        if (cleanValue.isBlank()) {
            cleanValue = DEFAULT_NEW_WORLD_DATETIME;
        }
        cleanValue = cleanValue.replace(' ', 'T');
        if (cleanValue.length() == 16) {
            cleanValue = cleanValue + ":00";
        }
        try {
            return LocalDateTime.parse(cleanValue, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("新世界时间格式不正确，请使用类似 1638-05-06 08:00 的格式");
        }
    }

    private void fillLocation(CouncilLocation location, String scope, String name, Integer value, Integer sortOrder, boolean visible) {
        String normalizedScope = normalizeScope(scope);
        String cleanName = clean(name);
        if (!SCOPE_WORLD.equals(normalizedScope) && !SCOPE_CHINA.equals(normalizedScope) && !SCOPE_STRATEGIC.equals(normalizedScope)) {
            throw new IllegalArgumentException("驻点类型只能是 WORLD、CHINA 或 STRATEGIC");
        }
        if (cleanName.isBlank()) {
            throw new IllegalArgumentException("驻点名称不能为空");
        }
        int safeValue = value == null ? 0 : value;
        if (safeValue < 0) {
            throw new IllegalArgumentException("元老数量不能小于 0");
        }
        location.setScope(normalizedScope);
        location.setName(cleanName);
        location.setValue(safeValue);
        location.setSortOrder(sortOrder == null ? 0 : sortOrder);
        location.setVisible(visible);
    }

    private String normalizeScope(String scope) {
        return clean(scope).toUpperCase(Locale.ROOT);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}
