package com.example.modernbbs.repository;

import com.example.modernbbs.model.DepartmentBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DepartmentBannerRepository extends JpaRepository<DepartmentBanner, Long> {
    @Query("select b from DepartmentBanner b join fetch b.category c where c.id = :categoryId and b.visible = true order by b.sortOrder asc, b.id asc")
    List<DepartmentBanner> publicByCategory(@Param("categoryId") Long categoryId);

    @Query("select b from DepartmentBanner b join fetch b.category c order by c.sortOrder asc, b.sortOrder asc, b.id asc")
    List<DepartmentBanner> allForManagement();

    @Query("select b from DepartmentBanner b join fetch b.category c where c.managerUser.id = :managerUserId order by c.sortOrder asc, b.sortOrder asc, b.id asc")
    List<DepartmentBanner> byManagerForManagement(@Param("managerUserId") Long managerUserId);
}
