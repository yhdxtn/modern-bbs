package com.example.modernbbs.service;

import com.example.modernbbs.model.PrivateMessage;
import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.PrivateMessageRepository;
import com.example.modernbbs.repository.UserRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class PrivateMessageService {
    private final PrivateMessageRepository privateMessageRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public PrivateMessageService(PrivateMessageRepository privateMessageRepository, UserRepository userRepository, NotificationService notificationService) {
        this.privateMessageRepository = privateMessageRepository;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    public long unreadCount(User currentUser) {
        if (currentUser == null || currentUser.getId() == null) return 0L;
        return privateMessageRepository.countByRecipientIdAndReadAtIsNull(currentUser.getId());
    }

    public List<ConversationSummary> conversations(User currentUser) {
        if (currentUser == null || currentUser.getId() == null) return List.of();
        List<PrivateMessage> recent = privateMessageRepository.findRecentForUser(currentUser.getId(), PageRequest.of(0, 600));
        Map<Long, ConversationSummary> summaries = new LinkedHashMap<>();
        for (PrivateMessage message : recent) {
            User other = message.getSender().getId().equals(currentUser.getId()) ? message.getRecipient() : message.getSender();
            if (other == null || other.getId() == null || summaries.containsKey(other.getId())) continue;
            long unread = privateMessageRepository.countUnreadFrom(currentUser.getId(), other.getId());
            summaries.put(other.getId(), new ConversationSummary(other, message, unread));
        }
        return new ArrayList<>(summaries.values());
    }

    @Transactional
    public PrivateMessage send(User sender, String recipientUsername, String content) {
        if (sender == null || sender.getId() == null) {
            throw new IllegalArgumentException("请先登入后再发送私信");
        }
        String cleanContent = clean(content);
        if (cleanContent.isBlank()) {
            throw new IllegalArgumentException("私信内容不能为空");
        }
        if (cleanContent.length() > 2000) {
            throw new IllegalArgumentException("私信内容不能超过 2000 个字符");
        }
        User freshSender = userRepository.findById(sender.getId())
                .orElseThrow(() -> new IllegalArgumentException("发送者账号不存在"));
        User recipient = userRepository.findByNormalizedUsername(clean(recipientUsername).toLowerCase())
                .filter(user -> "ACTIVE".equalsIgnoreCase(user.getStatus()))
                .orElseThrow(() -> new IllegalArgumentException("未找到收信元老"));
        if (recipient.getId().equals(freshSender.getId())) {
            throw new IllegalArgumentException("不能给自己发送私信");
        }
        PrivateMessage message = new PrivateMessage();
        message.setSender(freshSender);
        message.setRecipient(recipient);
        message.setContent(cleanContent);
        PrivateMessage saved = privateMessageRepository.save(message);
        notificationService.notifyPrivateMessage(saved);
        return saved;
    }

    @Transactional
    public List<PrivateMessage> conversationWith(User currentUser, String otherUsername) {
        if (currentUser == null || currentUser.getId() == null) {
            throw new IllegalArgumentException("请先登入后再查看私信");
        }
        User other = userRepository.findByNormalizedUsername(clean(otherUsername).toLowerCase())
                .filter(user -> "ACTIVE".equalsIgnoreCase(user.getStatus()))
                .orElseThrow(() -> new IllegalArgumentException("未找到该元老"));
        privateMessageRepository.markReadFrom(currentUser.getId(), other.getId(), LocalDateTime.now());
        return privateMessageRepository.findConversation(currentUser.getId(), other.getId());
    }

    public User findRecipient(String username) {
        return userRepository.findByNormalizedUsername(clean(username).toLowerCase())
                .filter(user -> "ACTIVE".equalsIgnoreCase(user.getStatus()))
                .orElseThrow(() -> new IllegalArgumentException("未找到该元老"));
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    public static class ConversationSummary {
        private final User other;
        private final PrivateMessage lastMessage;
        private final long unreadCount;

        public ConversationSummary(User other, PrivateMessage lastMessage, long unreadCount) {
            this.other = other;
            this.lastMessage = lastMessage;
            this.unreadCount = unreadCount;
        }

        public User getOther() { return other; }
        public PrivateMessage getLastMessage() { return lastMessage; }
        public long getUnreadCount() { return unreadCount; }
    }
}
