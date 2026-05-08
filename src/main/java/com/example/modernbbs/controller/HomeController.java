package com.example.modernbbs.controller;

import com.example.modernbbs.model.Category;
import com.example.modernbbs.service.CategoryService;
import com.example.modernbbs.service.DashboardService;
import com.example.modernbbs.service.PostService;
import com.example.modernbbs.service.DepartmentBannerService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {
    private final PostService postService;
    private final DashboardService dashboardService;
    private final CategoryService categoryService;
    private final DepartmentBannerService departmentBannerService;

    public HomeController(PostService postService, DashboardService dashboardService, CategoryService categoryService, DepartmentBannerService departmentBannerService) {
        this.postService = postService;
        this.dashboardService = dashboardService;
        this.categoryService = categoryService;
        this.departmentBannerService = departmentBannerService;
    }

    @GetMapping("/")
    public String index(@RequestParam(required = false) String q,
                        @RequestParam(required = false) Long categoryId,
                        @RequestParam(defaultValue = "0") int page,
                        Model model) {
        int safePage = Math.max(page, 0);
        Pageable pageable = PageRequest.of(safePage, 10);
        model.addAttribute("posts", postService.search(q, categoryId, pageable));
        model.addAttribute("q", q == null ? "" : q);
        model.addAttribute("categoryId", categoryId);
        if (categoryId != null) {
            Category selectedCategory = categoryService.mustFind(categoryId);
            model.addAttribute("selectedCategory", selectedCategory);
            model.addAttribute("departmentMessages", departmentMessages(selectedCategory));
            model.addAttribute("departmentBanners", departmentBannerService.publicBanners(selectedCategory.getId()));
        }
        if (categoryId == null) {
            model.addAttribute("departmentBanners", java.util.List.of());
        }
        addNewWorldTimeModel(model);
        return "index";
    }

    /**
     * 元老分布数量不再堆在首页，单独放到这个模块里查看。
     */
    @GetMapping("/command-map")
    public String commandMap(Model model) {
        addNewWorldTimeModel(model);
        model.addAttribute("worldLocations", dashboardService.visibleMapData(DashboardService.SCOPE_WORLD));
        model.addAttribute("chinaLocations", dashboardService.visibleMapData(DashboardService.SCOPE_CHINA));
        model.addAttribute("strategicLocations", dashboardService.visibleMapData(DashboardService.SCOPE_STRATEGIC));
        model.addAttribute("worldElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_WORLD));
        model.addAttribute("chinaElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_CHINA));
        model.addAttribute("strategicElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_STRATEGIC));
        return "command-map";
    }

    private java.util.List<String> departmentMessages(Category category) {
        String slug = category == null ? "" : category.getSlug();
        return switch (slug) {
            case "senate" -> java.util.List.of("执委会公报、公共纪律、正式任命与紧急决议统一归档。", "本区发帖权限限制为执委会代表与管理员；普通元老可阅读并在授权范围内回复。", "涉及军务、粮食、外交等跨部门议题，应附执行范围和责任人。 ");
            case "lingao-capital" -> java.util.List.of("临高为登陆地、事实首都区与最高议事中心，首要事项是居住、治安、港口、仓储和政务秩序。", "百仞城、博铺港与登陆点内驻元老优先处理居住、治安、仓储和施工秩序。", "首都区建设议题需明确用工、材料、交通与防疫影响。 ");
            case "industry" -> java.util.List.of("工业建设优先保障蒸汽动力、机械维修、铁器冶炼、盐硝化工和基础电力。", "提交方案时建议说明原料来源、工匠训练、设备损耗与替代工艺。", "涉及临高首都区的项目需同步考虑港口转运和安保。 ");
            case "agriculture" -> java.util.List.of("农业与物资优先处理粮食、甘蔗、畜牧、仓储、防霉和后勤配送。", "每项物资调配建议列明库存、消耗速度、运输路线和风险。", "跨区征调需同时报备临高首都区与航海贸易分区。 ");
            case "medicine" -> java.util.List.of("医疗卫生优先处理检疫、饮水、外伤、传染病预警和常备药生产。", "医疗讨论请尽量写明症状、隔离范围、药品消耗和观察周期。", "涉及大规模人群流动的事项需要同步通知军务安保与政务制度。 ");
            case "security" -> java.util.List.of("军务安保负责营地防御、港口警戒、武器训练、治安巡逻和情报预警。", "发布预案时应说明威胁来源、响应层级、装备需求和撤离路线。", "外驻元老仅可通过电报回报紧急情报。 ");
            case "navigation" -> java.util.List.of("航海贸易负责港口、船只、航线、补给、外部接触和海上风险记录。", "航线议题应包含季风、淡水、维修、货物、人员交接与外务风险。", "济州岛、越南、日本、台湾等外驻点按驻外档案登记。 ");
            case "education" -> java.util.List.of("教育档案负责识字、教材、技术培训、工匠带教和基础纪律宣导。", "培训计划建议标明课时、教师、受训对象、考核方式和可复制材料。", "涉及工业、农业、医疗的教材应同步对应分区备份。 ");
            case "governance" -> java.util.List.of("政务制度负责行政组织、法律秩序、财政税务、户籍档案和公共治理。", "制度讨论应写清适用范围、执行机关、处罚/奖励方式和过渡安排。", "跨部门制度请先在议事厅讨论，再由执委会代表整理成正式公告。 ");
            default -> java.util.List.of(
                    category.getName() + "负责本部门日常记录、问题讨论与执行反馈。",
                    "请在本区发帖时写明背景、资源需求、执行步骤和需要其他元老协助的事项。",
                    "重要事项可整理后提交议事厅或执委会公报。"
            );
        };
    }

    @GetMapping("/error-admin")
    public String adminForbidden(Model model) {
        model.addAttribute("message", "没有元老院后台权限，请使用管理员账号登入。");
        return "error";
    }

    private void addNewWorldTimeModel(Model model) {
        model.addAttribute("newWorldLabel", dashboardService.getNewWorldLabel());
        model.addAttribute("newWorldBaseDateTime", dashboardService.getNewWorldBaseDateTime());
        model.addAttribute("newWorldSyncEpochMillis", dashboardService.getNewWorldSyncEpochMillis());
    }
}
