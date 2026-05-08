package com.example.modernbbs.repository;

import com.example.modernbbs.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByNormalizedUsername(String normalizedUsername);
    boolean existsByUsername(String username);
    boolean existsByNormalizedUsername(String normalizedUsername);
    long countByRole(String role);

    @Query("select u.stationName, sum(u.stationElderCount) from User u " +
            "where u.stationScope = :scope and u.stationName is not null and u.status = 'ACTIVE' " +
            "group by u.stationName")
    List<Object[]> sumStationEldersByScope(@Param("scope") String scope);

    @Query(value = """
            SELECT * FROM bbs_users u
            WHERE u.status = 'ACTIVE'
              AND (:keyword IS NULL OR :keyword = ''
                   OR u.username LIKE CONCAT('%', :keyword, '%')
                   OR u.nickname LIKE CONCAT('%', :keyword, '%')
                   OR u.call_sign LIKE CONCAT('%', :keyword, '%')
                   OR u.telegram_code LIKE CONCAT('%', :keyword, '%')
                   OR u.council_department LIKE CONCAT('%', :keyword, '%')
                   OR u.specialty LIKE CONCAT('%', :keyword, '%')
                   OR u.station_name LIKE CONCAT('%', :keyword, '%'))
            ORDER BY u.updated_at DESC
            """,
            countQuery = """
            SELECT COUNT(*) FROM bbs_users u
            WHERE u.status = 'ACTIVE'
              AND (:keyword IS NULL OR :keyword = ''
                   OR u.username LIKE CONCAT('%', :keyword, '%')
                   OR u.nickname LIKE CONCAT('%', :keyword, '%')
                   OR u.call_sign LIKE CONCAT('%', :keyword, '%')
                   OR u.telegram_code LIKE CONCAT('%', :keyword, '%')
                   OR u.council_department LIKE CONCAT('%', :keyword, '%')
                   OR u.specialty LIKE CONCAT('%', :keyword, '%')
                   OR u.station_name LIKE CONCAT('%', :keyword, '%'))
            """,
            nativeQuery = true)
    Page<User> searchPublic(@Param("keyword") String keyword, Pageable pageable);

}
