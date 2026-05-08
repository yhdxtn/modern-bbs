package com.example.modernbbs.service;

import com.example.modernbbs.model.Category;
import com.example.modernbbs.repository.CategoryRepository;
import com.example.modernbbs.repository.PostRepository;
import com.example.modernbbs.repository.UserRepository;
import com.example.modernbbs.model.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Locale;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    public CategoryService(CategoryRepository categoryRepository, PostRepository postRepository, UserRepository userRepository) {
        this.categoryRepository = categoryRepository;
        this.postRepository = postRepository;
        this.userRepository = userRepository;
    }

    public List<Category> all() {
        return categoryRepository.findAllByOrderBySortOrderAsc();
    }

    public long count() {
        return categoryRepository.count();
    }

    public Category mustFind(Long id) {
        return categoryRepository.findWithManagerById(id)
                .orElseThrow(() -> new IllegalArgumentException("分区不存在"));
    }

    @Transactional
    public Category create(String name, String slug, String description, Integer sortOrder) {
        return create(name, slug, description, sortOrder, false);
    }

    @Transactional
    public Category create(String name, String slug, String description, Integer sortOrder, boolean executiveOnly) {
        return create(name, slug, description, sortOrder, executiveOnly, null);
    }

    @Transactional
    public Category create(String name, String slug, String description, Integer sortOrder, boolean executiveOnly, String managerUsername) {
        Category category = new Category();
        apply(category, name, slug, description, sortOrder, executiveOnly, managerUsername);
        if (categoryRepository.existsBySlug(category.getSlug())) {
            throw new IllegalArgumentException("分区标识 slug 已存在");
        }
        return categoryRepository.save(category);
    }

    @Transactional
    public Category update(Long id, String name, String slug, String description, Integer sortOrder) {
        return update(id, name, slug, description, sortOrder, false);
    }

    @Transactional
    public Category update(Long id, String name, String slug, String description, Integer sortOrder, boolean executiveOnly) {
        return update(id, name, slug, description, sortOrder, executiveOnly, null);
    }

    @Transactional
    public Category update(Long id, String name, String slug, String description, Integer sortOrder, boolean executiveOnly, String managerUsername) {
        Category category = mustFind(id);
        String cleanSlug = normalizeSlug(slug);
        if (categoryRepository.existsBySlugAndIdNot(cleanSlug, id)) {
            throw new IllegalArgumentException("分区标识 slug 已存在");
        }
        apply(category, name, cleanSlug, description, sortOrder, executiveOnly, managerUsername);
        return categoryRepository.save(category);
    }

    @Transactional
    public void delete(Long id) {
        Category category = mustFind(id);
        if (postRepository.existsByCategoryId(id)) {
            throw new IllegalArgumentException("该分区下还有议案，不能直接删除");
        }
        categoryRepository.delete(category);
    }

    private void apply(Category category, String name, String slug, String description, Integer sortOrder, boolean executiveOnly, String managerUsername) {
        String cleanName = clean(name);
        String cleanSlug = normalizeSlug(slug);
        if (cleanName.length() < 2 || cleanName.length() > 40) {
            throw new IllegalArgumentException("分区名称长度应为 2-40 个字符");
        }
        if (!cleanSlug.matches("^[a-z0-9_-]{2,40}$")) {
            throw new IllegalArgumentException("slug 只能包含小写字母、数字、下划线和短横线，长度 2-40");
        }
        category.setName(cleanName);
        category.setSlug(cleanSlug);
        category.setDescription(clean(description));
        category.setSortOrder(sortOrder == null ? 0 : sortOrder);
        category.setExecutiveOnly(executiveOnly);
        category.setManagerUser(findManager(managerUsername));
    }

    private User findManager(String managerUsername) {
        String clean = clean(managerUsername);
        if (clean.isBlank()) return null;
        return userRepository.findByNormalizedUsername(clean.toLowerCase(Locale.ROOT))
                .or(() -> userRepository.findByUsername(clean))
                .orElseThrow(() -> new IllegalArgumentException("负责人账号不存在：" + clean));
    }

    private String normalizeSlug(String slug) {
        return clean(slug).toLowerCase(Locale.ROOT);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}
