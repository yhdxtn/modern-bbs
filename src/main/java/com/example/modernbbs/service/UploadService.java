package com.example.modernbbs.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Iterator;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@Service
public class UploadService {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    private final Path uploadRoot;
    private final long maxImageBytes;

    public UploadService(@Value("${app.upload.root:uploads}") String uploadRoot,
                         @Value("${app.upload.max-image-bytes:5242880}") long maxImageBytes) {
        this.uploadRoot = Path.of(uploadRoot).toAbsolutePath().normalize();
        this.maxImageBytes = maxImageBytes;
    }


    /**
     * 保存头像时不保留原图：服务器端读取图片，中心裁剪为正方形，压缩为 256x256 的 JPG。
     * 这样用户上传手机原图、微信大图时，也不会把大图直接当头像展示，评论区也不会被撑坏。
     */
    public String saveAvatarImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return "";
        }
        validateImageFile(file);
        Path targetDir = safeTargetDir("avatars");
        try (InputStream inputStream = file.getInputStream()) {
            BufferedImage source = ImageIO.read(inputStream);
            if (source == null || source.getWidth() <= 0 || source.getHeight() <= 0) {
                throw new IllegalArgumentException("无法识别头像图片，请上传 jpg、png、gif 等常见图片");
            }
            BufferedImage avatar = cropCenterSquare(source, 256);
            Files.createDirectories(targetDir);
            String filename = UUID.randomUUID() + ".jpg";
            Path target = targetDir.resolve(filename).normalize();
            writeJpeg(avatar, target, 0.86f);
            return "/uploads/avatars/" + filename;
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (IOException ex) {
            throw new IllegalArgumentException("头像处理失败，请换一张图片再试");
        }
    }

    /**
     * 帖子图片也做一次温和压缩：长边限制到 1800px，避免正文图片撑爆页面和占用过多带宽。
     * GIF 会保留原文件，避免动图被压成静态图。
     */
    public String savePostImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return "";
        }
        String originalName = file.getOriginalFilename() == null ? "image" : file.getOriginalFilename();
        String extension = extension(originalName);
        if ("gif".equals(extension)) {
            return saveImage(file, "posts");
        }
        validateImageFile(file);
        Path targetDir = safeTargetDir("posts");
        try (InputStream inputStream = file.getInputStream()) {
            BufferedImage source = ImageIO.read(inputStream);
            if (source == null || source.getWidth() <= 0 || source.getHeight() <= 0) {
                return saveImage(file, "posts");
            }
            BufferedImage resized = resizeToMax(source, 1800);
            Files.createDirectories(targetDir);
            String filename = UUID.randomUUID() + ".jpg";
            Path target = targetDir.resolve(filename).normalize();
            writeJpeg(resized, target, 0.88f);
            return "/uploads/posts/" + filename;
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (IOException ex) {
            throw new IllegalArgumentException("图片处理失败，请换一张图片再试");
        }
    }

    public String saveImage(MultipartFile file, String folder) {
        if (file == null || file.isEmpty()) {
            return "";
        }
        validateImageFile(file);
        String originalName = file.getOriginalFilename() == null ? "image" : file.getOriginalFilename();
        String extension = extension(originalName);
        Path targetDir = safeTargetDir(folder);
        try {
            Files.createDirectories(targetDir);
            String filename = UUID.randomUUID() + "." + extension;
            Path target = targetDir.resolve(filename).normalize();
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            return "/uploads/" + targetDir.getFileName() + "/" + filename;
        } catch (IOException ex) {
            throw new IllegalArgumentException("图片保存失败，请稍后重试");
        }
    }


    private void validateImageFile(MultipartFile file) {
        if (file.getSize() > maxImageBytes) {
            throw new IllegalArgumentException("图片不能超过 " + Math.max(1, maxImageBytes / 1024 / 1024) + "MB");
        }
        String originalName = file.getOriginalFilename() == null ? "image" : file.getOriginalFilename();
        String extension = extension(originalName);
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException("只允许上传 jpg、jpeg、png、gif、webp 图片");
        }
        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        if (!contentType.isBlank() && !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("上传文件必须是图片");
        }
    }

    private Path safeTargetDir(String folder) {
        String cleanFolder = folder == null || folder.isBlank() ? "images" : folder.replaceAll("[^a-zA-Z0-9_-]", "");
        Path targetDir = uploadRoot.resolve(cleanFolder).normalize();
        if (!targetDir.startsWith(uploadRoot)) {
            throw new IllegalArgumentException("非法上传目录");
        }
        return targetDir;
    }

    private BufferedImage cropCenterSquare(BufferedImage source, int size) {
        int side = Math.min(source.getWidth(), source.getHeight());
        int x = Math.max(0, (source.getWidth() - side) / 2);
        int y = Math.max(0, (source.getHeight() - side) / 2);
        BufferedImage target = new BufferedImage(size, size, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = target.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.drawImage(source, 0, 0, size, size, x, y, x + side, y + side, null);
        g.dispose();
        return target;
    }

    private BufferedImage resizeToMax(BufferedImage source, int maxSide) {
        int width = source.getWidth();
        int height = source.getHeight();
        int longest = Math.max(width, height);
        if (longest <= maxSide) {
            BufferedImage target = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = target.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.drawImage(source, 0, 0, null);
            g.dispose();
            return target;
        }
        double scale = (double) maxSide / (double) longest;
        int targetWidth = Math.max(1, (int) Math.round(width * scale));
        int targetHeight = Math.max(1, (int) Math.round(height * scale));
        BufferedImage target = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = target.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.drawImage(source, 0, 0, targetWidth, targetHeight, null);
        g.dispose();
        return target;
    }

    private void writeJpeg(BufferedImage image, Path target, float quality) throws IOException {
        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
        if (!writers.hasNext()) {
            ImageIO.write(image, "jpg", target.toFile());
            return;
        }
        ImageWriter writer = writers.next();
        ImageWriteParam param = writer.getDefaultWriteParam();
        if (param.canWriteCompressed()) {
            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(Math.max(0.1f, Math.min(1f, quality)));
        }
        try (ImageOutputStream output = ImageIO.createImageOutputStream(target.toFile())) {
            writer.setOutput(output);
            writer.write(null, new IIOImage(image, null, null), param);
        } finally {
            writer.dispose();
        }
    }

    private String extension(String name) {
        int idx = name.lastIndexOf('.');
        if (idx < 0 || idx == name.length() - 1) {
            return "";
        }
        return name.substring(idx + 1).toLowerCase(Locale.ROOT);
    }
}
