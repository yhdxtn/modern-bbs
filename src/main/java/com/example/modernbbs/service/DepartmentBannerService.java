package com.example.modernbbs.service;

import com.example.modernbbs.model.Category;
import com.example.modernbbs.model.DepartmentBanner;
import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.CategoryRepository;
import com.example.modernbbs.repository.DepartmentBannerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class DepartmentBannerService {
    private final DepartmentBannerRepository bannerRepository;
    private final CategoryRepository categoryRepository;
    private final UploadService uploadService;

    public DepartmentBannerService(DepartmentBannerRepository bannerRepository,
                                   CategoryRepository categoryRepository,
                                   UploadService uploadService) {
        this.bannerRepository = bannerRepository;
        this.categoryRepository = categoryRepository;
        this.uploadService = uploadService;
    }

    public List<DepartmentBanner> publicBanners(Long categoryId) {
        if (categoryId == null) return List.of();
        return bannerRepository.publicByCategory(categoryId);
    }

    public List<DepartmentBanner> manageableBanners(User user) {
        if (user == null) return List.of();
        if (user.isAdmin()) {
            return bannerRepository.allForManagement();
        }
        return bannerRepository.byManagerForManagement(user.getId());
    }

    public List<Category> manageableCategories(User user) {
        if (user == null) return List.of();
        if (user.isAdmin()) return categoryRepository.findAllByOrderBySortOrderAsc();
        return categoryRepository.findByManagerUserIdOrderBySortOrderAsc(user.getId());
    }

    public boolean canManageAny(User user) {
        if (user == null) return false;
        return user.isAdmin() || !categoryRepository.findByManagerUserIdOrderBySortOrderAsc(user.getId()).isEmpty();
    }

    public boolean canManageCategory(User user, Category category) {
        if (user == null || category == null) return false;
        if (user.isAdmin()) return true;
        return category.getManagerUser() != null && category.getManagerUser().getId().equals(user.getId());
    }

    public DepartmentBanner mustFind(Long id) {
        return bannerRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("宣传图不存在"));
    }

    @Transactional
    public DepartmentBanner create(User actor,
                                   Long categoryId,
                                   String title,
                                   String subtitle,
                                   String imageUrl,
                                   MultipartFile imageFile,
                                   String linkText,
                                   String linkUrl,
                                   Integer sortOrder,
                                   boolean visible) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("分区不存在"));
        ensureCanManage(actor, category);
        DepartmentBanner banner = new DepartmentBanner();
        banner.setCategory(category);
        apply(banner, title, subtitle, imageUrl, imageFile, linkText, linkUrl, sortOrder, visible, true);
        return bannerRepository.save(banner);
    }

    @Transactional
    public DepartmentBanner update(User actor,
                                   Long id,
                                   Long categoryId,
                                   String title,
                                   String subtitle,
                                   String imageUrl,
                                   MultipartFile imageFile,
                                   String linkText,
                                   String linkUrl,
                                   Integer sortOrder,
                                   boolean visible) {
        DepartmentBanner banner = mustFind(id);
        ensureCanManage(actor, banner.getCategory());
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("分区不存在"));
        ensureCanManage(actor, category);
        banner.setCategory(category);
        apply(banner, title, subtitle, imageUrl, imageFile, linkText, linkUrl, sortOrder, visible, false);
        return bannerRepository.save(banner);
    }

    @Transactional
    public void delete(User actor, Long id) {
        DepartmentBanner banner = mustFind(id);
        ensureCanManage(actor, banner.getCategory());
        bannerRepository.delete(banner);
    }

    private void apply(DepartmentBanner banner,
                       String title,
                       String subtitle,
                       String imageUrl,
                       MultipartFile imageFile,
                       String linkText,
                       String linkUrl,
                       Integer sortOrder,
                       boolean visible,
                       boolean creating) {
        String cleanTitle = clean(title);
        if (cleanTitle.length() < 2 || cleanTitle.length() > 80) {
            throw new IllegalArgumentException("宣传图标题长度应为 2-80 个字符");
        }
        String uploaded = uploadService.saveImage(imageFile, "banners");
        String finalImageUrl = !uploaded.isBlank() ? uploaded : clean(imageUrl);
        if ((finalImageUrl == null || finalImageUrl.isBlank()) && creating) {
            throw new IllegalArgumentException("请上传宣传图，或填写图片 URL");
        }
        banner.setTitle(cleanTitle);
        banner.setSubtitle(truncate(clean(subtitle), 220));
        if (finalImageUrl != null && !finalImageUrl.isBlank()) banner.setImageUrl(finalImageUrl);
        banner.setLinkText(truncate(clean(linkText), 40));
        banner.setLinkUrl(truncate(clean(linkUrl), 500));
        banner.setSortOrder(sortOrder == null ? 0 : sortOrder);
        banner.setVisible(visible);
    }

    private void ensureCanManage(User actor, Category category) {
        if (!canManageCategory(actor, category)) {
            throw new IllegalArgumentException("只有该分区负责人或管理员可以设置宣传图");
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String truncate(String value, int max) {
        if (value == null) return "";
        return value.length() <= max ? value : value.substring(0, max);
    }
}
