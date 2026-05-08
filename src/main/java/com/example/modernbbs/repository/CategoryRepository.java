package com.example.modernbbs.repository;

import com.example.modernbbs.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findBySlug(String slug);

    @Query("select c from Category c left join fetch c.managerUser where c.id = :id")
    Optional<Category> findWithManagerById(@Param("id") Long id);
    boolean existsBySlug(String slug);
    boolean existsBySlugAndIdNot(String slug, Long id);

    @Query("select c from Category c left join fetch c.managerUser order by c.sortOrder asc")
    List<Category> findAllByOrderBySortOrderAsc();

    @Query("select c from Category c left join fetch c.managerUser where c.managerUser.id = :managerUserId order by c.sortOrder asc")
    List<Category> findByManagerUserIdOrderBySortOrderAsc(@Param("managerUserId") Long managerUserId);
}
