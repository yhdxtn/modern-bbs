package com.example.modernbbs.repository;

import com.example.modernbbs.model.CommentReaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CommentReactionRepository extends JpaRepository<CommentReaction, Long> {
    Optional<CommentReaction> findByUserIdAndTargetTypeAndTargetIdAndReactionType(Long userId, String targetType, Long targetId, String reactionType);
    long countByTargetTypeAndTargetIdAndReactionType(String targetType, Long targetId, String reactionType);

    @Query("select r.targetId from CommentReaction r where r.user.id = :userId and r.targetType = 'COMMENT' and r.reactionType = 'LIKE' and r.targetId in :ids")
    List<Long> findLikedCommentIds(@Param("userId") Long userId, @Param("ids") List<Long> ids);
}
