package com.example.modernbbs.model;

import jakarta.persistence.*;

@Entity
@Table(name = "bbs_thread_contents")
public class PostContent {
    @Id
    @Column(name = "thread_id")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId
    @JoinColumn(name = "thread_id")
    private Post post;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Post getPost() { return post; }
    public void setPost(Post post) { this.post = post; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
