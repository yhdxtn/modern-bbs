package com.example.modernbbs.repository;

import com.example.modernbbs.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    @Query(value = """
            SELECT t.* FROM bbs_threads t
            LEFT JOIN bbs_thread_contents tc ON tc.thread_id = t.id
            WHERE t.status = 'PUBLISHED'
              AND (:categoryId IS NULL OR t.category_id = :categoryId)
              AND (:keyword IS NULL OR t.title LIKE CONCAT('%', :keyword, '%')
                   OR tc.content LIKE CONCAT('%', :keyword, '%'))
            ORDER BY t.pinned DESC, t.updated_at DESC
            """,
            countQuery = """
            SELECT COUNT(*) FROM bbs_threads t
            LEFT JOIN bbs_thread_contents tc ON tc.thread_id = t.id
            WHERE t.status = 'PUBLISHED'
              AND (:categoryId IS NULL OR t.category_id = :categoryId)
              AND (:keyword IS NULL OR t.title LIKE CONCAT('%', :keyword, '%')
                   OR tc.content LIKE CONCAT('%', :keyword, '%'))
            """,
            nativeQuery = true)
    Page<Post> search(@Param("keyword") String keyword,
                      @Param("categoryId") Long categoryId,
                      Pageable pageable);

    boolean existsByCategoryId(Long categoryId);

    List<Post> findTop5ByOrderByUpdatedAtDesc();
}
