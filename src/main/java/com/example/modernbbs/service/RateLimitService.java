package com.example.modernbbs.service;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RateLimitService {
    private static final long WINDOW_MILLIS = 60_000L;

    private final int maxRequestsPerMinute;
    private final int maxPostsPerMinute;
    private final long maxBytesPerMinute;
    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    public RateLimitService(@Value("${app.security.max-requests-per-minute:180}") int maxRequestsPerMinute,
                            @Value("${app.security.max-posts-per-minute:20}") int maxPostsPerMinute,
                            @Value("${app.security.max-bytes-per-minute:10485760}") long maxBytesPerMinute) {
        this.maxRequestsPerMinute = maxRequestsPerMinute;
        this.maxPostsPerMinute = maxPostsPerMinute;
        this.maxBytesPerMinute = maxBytesPerMinute;
    }

    public boolean shouldChallenge(HttpServletRequest request) {
        cleanup();
        String key = clientIp(request);
        long now = System.currentTimeMillis();
        Bucket bucket = buckets.computeIfAbsent(key, ignored -> new Bucket(now));
        synchronized (bucket) {
            if (now - bucket.windowStart >= WINDOW_MILLIS) {
                bucket.windowStart = now;
                bucket.requests = 0;
                bucket.posts = 0;
                bucket.bytes = 0;
            }
            bucket.requests++;
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                bucket.posts++;
            }
            int length = request.getContentLength();
            if (length > 0) {
                bucket.bytes += length;
            }
            return bucket.requests > maxRequestsPerMinute
                    || bucket.posts > maxPostsPerMinute
                    || bucket.bytes > maxBytesPerMinute;
        }
    }

    public void markCaptchaPassed(HttpServletRequest request) {
        Bucket bucket = buckets.get(clientIp(request));
        if (bucket != null) {
            synchronized (bucket) {
                bucket.requests = Math.max(0, bucket.requests / 3);
                bucket.posts = 0;
                bucket.bytes = Math.max(0, bucket.bytes / 3);
            }
        }
    }

    public String clientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }
        return request.getRemoteAddr() == null ? "unknown" : request.getRemoteAddr();
    }

    private void cleanup() {
        long cutoff = Instant.now().toEpochMilli() - WINDOW_MILLIS * 5;
        buckets.entrySet().removeIf(entry -> entry.getValue().windowStart < cutoff);
    }

    private static class Bucket {
        long windowStart;
        int requests;
        int posts;
        long bytes;

        Bucket(long windowStart) {
            this.windowStart = windowStart;
        }
    }
}
