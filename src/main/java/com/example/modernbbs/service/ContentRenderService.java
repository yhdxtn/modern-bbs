package com.example.modernbbs.service;

import org.springframework.stereotype.Service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class ContentRenderService {
    private static final Pattern IMAGE_LINE = Pattern.compile("^!\\[([^\\]\\r\\n]{0,120})]\\((/uploads/[^)\\s]+)\\)$");
    private static final Pattern IMAGE_INLINE = Pattern.compile("!\\[([^\\]\\r\\n]{0,120})]\\((/uploads/[^)\\s]+)\\)");
    private static final Pattern LINK_INLINE = Pattern.compile("\\[([^\\]\\r\\n]{1,120})]\\((https?://[^)\\s]+)\\)");
    private static final Pattern INLINE_CODE = Pattern.compile("`([^`]{1,200})`");
    private static final Pattern BOLD = Pattern.compile("\\*\\*([^*]{1,300})\\*\\*");
    private static final Pattern ITALIC = Pattern.compile("(?<!\\*)\\*([^*]{1,200})\\*(?!\\*)");
    private static final Pattern STRIKE = Pattern.compile("~~([^~]{1,300})~~");

    public String render(String source) {
        if (source == null || source.isBlank()) {
            return "";
        }
        String[] lines = source.replace("\r\n", "\n").split("\n", -1);
        StringBuilder html = new StringBuilder();
        boolean inCode = false;
        StringBuilder code = new StringBuilder();
        String listType = null;

        for (String raw : lines) {
            String line = raw == null ? "" : raw;
            String trimmed = line.trim();

            if (trimmed.startsWith("```")) {
                if (!inCode) {
                    listType = closeList(html, listType);
                    inCode = true;
                    code.setLength(0);
                } else {
                    html.append("<pre><code>").append(escapeHtml(code.toString())).append("</code></pre>");
                    inCode = false;
                }
                continue;
            }
            if (inCode) {
                code.append(line).append('\n');
                continue;
            }

            if (trimmed.isEmpty()) {
                listType = closeList(html, listType);
                html.append("<br>");
                continue;
            }

            Matcher imageLine = IMAGE_LINE.matcher(trimmed);
            if (imageLine.matches()) {
                listType = closeList(html, listType);
                html.append(imageHtml(escapeHtml(imageLine.group(1)), imageLine.group(2)));
                continue;
            }

            if (trimmed.startsWith("### ")) {
                listType = closeList(html, listType);
                html.append("<h3>").append(applyInline(trimmed.substring(4))).append("</h3>");
                continue;
            }
            if (trimmed.startsWith("## ")) {
                listType = closeList(html, listType);
                html.append("<h2>").append(applyInline(trimmed.substring(3))).append("</h2>");
                continue;
            }
            if (trimmed.startsWith("# ")) {
                listType = closeList(html, listType);
                html.append("<h1>").append(applyInline(trimmed.substring(2))).append("</h1>");
                continue;
            }
            if (trimmed.startsWith("> ")) {
                listType = closeList(html, listType);
                html.append("<blockquote>").append(applyInline(trimmed.substring(2))).append("</blockquote>");
                continue;
            }
            if (trimmed.startsWith("- [ ] ")) {
                listType = openList(html, listType, "ul", "task-list");
                html.append("<li class=\"task-item\"><span class=\"fake-check\"></span>").append(applyInline(trimmed.substring(6))).append("</li>");
                continue;
            }
            if (trimmed.startsWith("- ") || trimmed.startsWith("* ")) {
                listType = openList(html, listType, "ul", null);
                html.append("<li>").append(applyInline(trimmed.substring(2))).append("</li>");
                continue;
            }
            if (trimmed.matches("^\\d+\\.\\s+.*")) {
                listType = openList(html, listType, "ol", null);
                html.append("<li>").append(applyInline(trimmed.replaceFirst("^\\d+\\.\\s+", ""))).append("</li>");
                continue;
            }
            if (trimmed.startsWith("---")) {
                listType = closeList(html, listType);
                html.append("<hr>");
                continue;
            }

            listType = closeList(html, listType);
            html.append("<p>").append(applyInline(line)).append("</p>");
        }
        closeList(html, listType);
        if (inCode) {
            html.append("<pre><code>").append(escapeHtml(code.toString())).append("</code></pre>");
        }
        return html.toString();
    }

    private String openList(StringBuilder html, String current, String next, String cssClass) {
        if (next.equals(current)) {
            return current;
        }
        closeList(html, current);
        if (cssClass == null) {
            html.append('<').append(next).append('>');
        } else {
            html.append('<').append(next).append(" class=\"").append(cssClass).append("\">");
        }
        return next;
    }

    private String closeList(StringBuilder html, String current) {
        if (current != null) {
            html.append("</").append(current).append('>');
        }
        return null;
    }

    private String applyInline(String value) {
        String html = escapeHtml(value);
        html = replaceImages(html);
        html = replaceLinks(html);
        html = replaceSimple(INLINE_CODE, html, "<code>$1</code>");
        html = replaceSimple(BOLD, html, "<strong>$1</strong>");
        html = replaceSimple(STRIKE, html, "<del>$1</del>");
        html = replaceSimple(ITALIC, html, "<em>$1</em>");
        return html;
    }

    private String replaceImages(String html) {
        Matcher matcher = IMAGE_INLINE.matcher(html);
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            String img = imageHtml(matcher.group(1), matcher.group(2));
            matcher.appendReplacement(sb, Matcher.quoteReplacement(img));
        }
        matcher.appendTail(sb);
        return sb.toString();
    }

    private String replaceLinks(String html) {
        Matcher matcher = LINK_INLINE.matcher(html);
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            String text = matcher.group(1);
            String url = matcher.group(2);
            String link = "<a href=\"" + url + "\" target=\"_blank\" rel=\"noopener noreferrer\">" + text + "</a>";
            matcher.appendReplacement(sb, Matcher.quoteReplacement(link));
        }
        matcher.appendTail(sb);
        return sb.toString();
    }

    private String replaceSimple(Pattern pattern, String html, String replacement) {
        return pattern.matcher(html).replaceAll(replacement);
    }

    private String imageHtml(String alt, String url) {
        return "<figure class=\"post-image\"><img src=\"" + url + "\" alt=\"" + alt + "\"><figcaption>" + alt + "</figcaption></figure>";
    }

    private String escapeHtml(String value) {
        return value == null ? "" : value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
