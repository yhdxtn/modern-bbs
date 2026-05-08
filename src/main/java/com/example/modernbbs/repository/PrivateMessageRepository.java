package com.example.modernbbs.repository;

import com.example.modernbbs.model.PrivateMessage;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface PrivateMessageRepository extends JpaRepository<PrivateMessage, Long> {
    long countByRecipientIdAndReadAtIsNull(Long recipientId);

    @Query("select m from PrivateMessage m join fetch m.sender join fetch m.recipient where m.sender.id = :userId or m.recipient.id = :userId order by m.createdAt desc")
    List<PrivateMessage> findRecentForUser(@Param("userId") Long userId, Pageable pageable);

    @Query("select m from PrivateMessage m join fetch m.sender join fetch m.recipient where " +
            "(m.sender.id = :userId and m.recipient.id = :otherId) or " +
            "(m.sender.id = :otherId and m.recipient.id = :userId) " +
            "order by m.createdAt asc")
    List<PrivateMessage> findConversation(@Param("userId") Long userId, @Param("otherId") Long otherId);

    @Query("select count(m) from PrivateMessage m where m.recipient.id = :userId and m.sender.id = :otherId and m.readAt is null")
    long countUnreadFrom(@Param("userId") Long userId, @Param("otherId") Long otherId);

    @Modifying
    @Query("update PrivateMessage m set m.readAt = :now where m.recipient.id = :userId and m.sender.id = :otherId and m.readAt is null")
    int markReadFrom(@Param("userId") Long userId, @Param("otherId") Long otherId, @Param("now") LocalDateTime now);
}
