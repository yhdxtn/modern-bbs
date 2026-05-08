package com.example.modernbbs.config;

import com.example.modernbbs.model.CouncilLocation;
import com.example.modernbbs.model.SiteSetting;
import com.example.modernbbs.repository.CouncilLocationRepository;
import com.example.modernbbs.repository.SiteSettingRepository;
import com.example.modernbbs.service.DashboardService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@Order(20)
public class MapSeedInitializer implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(MapSeedInitializer.class);
    private static final String SEED_KEY = "lingao_1638_capital_map_seeded_v1";

    private final SiteSettingRepository siteSettingRepository;
    private final CouncilLocationRepository councilLocationRepository;

    public MapSeedInitializer(SiteSettingRepository siteSettingRepository,
                              CouncilLocationRepository councilLocationRepository) {
        this.siteSettingRepository = siteSettingRepository;
        this.councilLocationRepository = councilLocationRepository;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        seedTimeDefaultsIfMissing();
        if (siteSettingRepository.existsById(SEED_KEY)) {
            return;
        }

        // 新版本设定：元老全部在亚洲，临高是穿越者登陆点与事实首都区。
        // 第一次升级时隐藏旧版本中欧美等非亚洲驻点，之后管理员可以在后台重新编辑。
        for (CouncilLocation location : councilLocationRepository.findByScopeOrderBySortOrderAscNameAsc(DashboardService.SCOPE_WORLD)) {
            location.setValue(0);
            location.setVisible(false);
            councilLocationRepository.save(location);
        }

        upsert(DashboardService.SCOPE_WORLD, "China", 620, 10, true);
        upsert(DashboardService.SCOPE_WORLD, "Vietnam", 44, 20, true);
        upsert(DashboardService.SCOPE_WORLD, "Japan", 31, 30, true);
        upsert(DashboardService.SCOPE_WORLD, "South Korea", 28, 40, true);
        upsert(DashboardService.SCOPE_WORLD, "Taiwan", 58, 50, true);
        upsert(DashboardService.SCOPE_WORLD, "Singapore", 18, 60, true);
        upsert(DashboardService.SCOPE_WORLD, "Malaysia", 14, 70, true);
        upsert(DashboardService.SCOPE_WORLD, "Thailand", 16, 80, true);
        upsert(DashboardService.SCOPE_WORLD, "Philippines", 12, 90, true);
        upsert(DashboardService.SCOPE_WORLD, "Indonesia", 10, 100, true);

        upsert(DashboardService.SCOPE_CHINA, "海南", 470, 5, true);
        upsert(DashboardService.SCOPE_CHINA, "广东", 82, 10, true);
        upsert(DashboardService.SCOPE_CHINA, "台湾", 58, 15, true);
        upsert(DashboardService.SCOPE_CHINA, "香港", 16, 20, true);
        upsert(DashboardService.SCOPE_CHINA, "澳门", 8, 25, true);
        upsert(DashboardService.SCOPE_CHINA, "福建", 32, 30, true);
        upsert(DashboardService.SCOPE_CHINA, "广西", 12, 40, true);
        upsert(DashboardService.SCOPE_CHINA, "上海", 20, 50, true);

        upsert(DashboardService.SCOPE_STRATEGIC, "临高首都区 / 登陆点", 420, 5, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "百仞城政务区", 160, 8, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "博铺港", 96, 9, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "海南主基地", 470, 10, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "广东工业转运区", 82, 20, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "台湾观察与技术联络点", 58, 30, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "济州岛远洋联络点", 28, 40, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "越南联络点", 44, 50, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "日本观察点", 31, 60, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "琼州海峡航运点", 42, 70, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "西沙前哨", 24, 80, true);
        upsert(DashboardService.SCOPE_STRATEGIC, "南沙补给线", 18, 90, true);

        siteSettingRepository.save(new SiteSetting(SEED_KEY, "true", "已初始化 1638 年临高首都区与亚洲元老态势模块默认数据"));
        log.info("Lingao 1638 capital command map seed data initialized.");
    }

    private void seedTimeDefaultsIfMissing() {
        siteSettingRepository.findById(DashboardService.KEY_NST_LABEL)
                .orElseGet(() -> siteSettingRepository.save(new SiteSetting(
                        DashboardService.KEY_NST_LABEL,
                        "新世界标准时 NST",
                        "新世界时间显示名称")));
        siteSettingRepository.findById(DashboardService.KEY_NST_BASE_DATETIME)
                .orElseGet(() -> siteSettingRepository.save(new SiteSetting(
                        DashboardService.KEY_NST_BASE_DATETIME,
                        DashboardService.DEFAULT_NEW_WORLD_DATETIME,
                        "管理员设定的新世界当前时间，默认 1638 年左右")));
        SiteSetting syncSetting = siteSettingRepository.findById(DashboardService.KEY_NST_SYNC_EPOCH_MS)
                .orElseGet(() -> new SiteSetting(
                        DashboardService.KEY_NST_SYNC_EPOCH_MS,
                        String.valueOf(System.currentTimeMillis()),
                        "保存新世界时间时对应的现实世界毫秒时间戳"));
        try {
            if (Long.parseLong(syncSetting.getSettingValue()) <= 0) {
                syncSetting.setSettingValue(String.valueOf(System.currentTimeMillis()));
            }
        } catch (NumberFormatException ex) {
            syncSetting.setSettingValue(String.valueOf(System.currentTimeMillis()));
        }
        syncSetting.setDescription("保存新世界时间时对应的现实世界毫秒时间戳");
        siteSettingRepository.save(syncSetting);
    }

    private void upsert(String scope, String name, int value, int sortOrder, boolean visible) {
        CouncilLocation location = councilLocationRepository.findByScopeAndName(scope, name)
                .orElseGet(CouncilLocation::new);
        location.setScope(scope);
        location.setName(name);
        location.setValue(value);
        location.setSortOrder(sortOrder);
        location.setVisible(visible);
        councilLocationRepository.save(location);
    }
}
