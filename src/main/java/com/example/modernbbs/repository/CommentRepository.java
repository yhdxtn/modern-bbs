package com.example.modernbbs.repository;

import com.example.modernbbs.model.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByPostIdOrderByCreatedAtAsc(Long postId);
    List<Comment> findByPostIdAndParentIsNullOrderByCreatedAtAsc(Long postId);
    List<Comment> findByPostIdAndParentIsNullOrderByCreatedAtDesc(Long postId);
    List<Comment> findByPostIdAndParentIsNullOrderByLikeCountDescCreatedAtAsc(Long postId);
    Page<Comment> findAllByOrderByCreatedAtDesc(Pageable pageable);
    List<Comment> findTop5ByOrderByCreatedAtDesc();
    void deleteByPostId(Long postId);
    long countByPostId(Long postId);
    List<Comment> findByParentIdOrderByCreatedAtAsc(Long parentId);

    @Query(value = """
            SELECT r.* FROM bbs_replies r
            JOIN bbs_threads t ON t.id = r.thread_id
            JOIN bbs_users u ON u.id = r.author_id
            WHERE r.status = 'PUBLISHED'
              AND t.status = 'PUBLISHED'
              AND (:keyword IS NULL OR :keyword = ''
                   OR r.content LIKE CONCAT('%', :keyword, '%')
                   OR t.title LIKE CONCAT('%', :keyword, '%')
                   OR u.username LIKE CONCAT('%', :keyword, '%')
                   OR u.nickname LIKE CONCAT('%', :keyword, '%')
                   OR u.call_sign LIKE CONCAT('%', :keyword, '%')
                   OR u.telegram_code LIKE CONCAT('%', :keyword, '%'))
            ORDER BY r.updated_at DESC
            """,
            countQuery = """
            SELECT COUNT(*) FROM bbs_replies r
            JOIN bbs_threads t ON t.id = r.thread_id
            JOIN bbs_users u ON u.id = r.author_id
            WHERE r.status = 'PUBLISHED'
              AND t.status = 'PUBLISHED'
              AND (:keyword IS NULL OR :keyword = ''
                   OR r.content LIKE CONCAT('%', :keyword, '%')
                   OR t.title LIKE CONCAT('%', :keyword, '%')
                   OR u.username LIKE CONCAT('%', :keyword, '%')
                   OR u.nickname LIKE CONCAT('%', :keyword, '%')
                   OR u.call_sign LIKE CONCAT('%', :keyword, '%')
                   OR u.telegram_code LIKE CONCAT('%', :keyword, '%'))
            """,
            nativeQuery = true)
    Page<Comment> searchPublic(@Param("keyword") String keyword, Pageable pageable);

}
