package life.bks.zone.service.webviewer;

import jakarta.annotation.PostConstruct;
import life.bks.zone.util.WVEncryptV2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class DrmTokenService {

    @Value("${drm.token.secret-key}")
    private String tokenSecretKey;

    @Value("${drm.viewer.base-url}")
    private String viewerBaseUrl;

    @Value("${drm.file.base-path}")
    private String filePath;

    @Value("${drm.token.default-validity-seconds}")
    private int defaultValiditySeconds;

    private WVEncryptV2 tokenUtil;

    @PostConstruct
    public void init() {
        if (tokenSecretKey == null || tokenSecretKey.isEmpty()) {
            throw new IllegalStateException("drm.token.secret-key is not configured");
        }
        this.tokenUtil = new WVEncryptV2(tokenSecretKey);
    }

    public String generateViewerUrl(BookInfo bookInfo, String userId) throws UnsupportedEncodingException {
        return generateViewerUrl(bookInfo, userId, "web-viewer", defaultValiditySeconds);
    }

    public String generateViewerUrl(
            BookInfo bookInfo,
            String userId,
            String deviceId,
            int validitySeconds) throws UnsupportedEncodingException {

        String payload = WVEncryptV2.createPayloadJson(
                "v1",
                bookInfo.getBcode(),
                userId,
                deviceId,
                mapFileType(bookInfo.getFt()),
                bookInfo.getTitle(),
                bookInfo.getWriter(),
                bookInfo.getPublisher(),
                resolveCoverPath(bookInfo.getCover()),
                true,
                "P".equals(bookInfo.getOt()),
                bookInfo.getLcd(),
                bookInfo.getSbcode(),
                bookInfo.getOt(),
                validitySeconds
        );

        String encryptedToken = tokenUtil.encrypt(payload);
        String encodedToken = URLEncoder.encode(encryptedToken, String.valueOf(StandardCharsets.UTF_8));
        String viewerPath = getViewerPath(bookInfo.getFt());

        return String.format("%s/%s?token=%s", viewerBaseUrl, viewerPath, encodedToken);
    }

    public String generateToken(
            BookInfo bookInfo,
            String userId,
            String deviceId,
            int validitySeconds) {

        String payload = WVEncryptV2.createPayloadJson(
                "v1",
                bookInfo.getBcode(),
                userId,
                deviceId,
                mapFileType(bookInfo.getFt()),
                bookInfo.getTitle(),
                bookInfo.getWriter(),
                bookInfo.getPublisher(),
                resolveCoverPath(bookInfo.getCover()),
                true,
                "P".equals(bookInfo.getOt()),
                bookInfo.getLcd(),
                bookInfo.getSbcode(),
                bookInfo.getOt(),
                validitySeconds
        );

        return tokenUtil.encrypt(payload);
    }

    private String mapFileType(String ft) {
        if (ft == null) {
            return "EPUB";
        }
        String upper = ft.toUpperCase();
        switch (upper) {
            case "WEB_PDF":
                return "PDF";
            case "WEB_EPUB":
                return "EPUB";
            case "WEB_AUDIO":
                return "AUDIO";
            case "WEB_COMIC":
                return "COMIC";
            default:
                return "EPUB";
        }
    }

    private String getViewerPath(String ft) {
        if (ft == null) {
            return "epub-viewer";
        }
        String upper = ft.toUpperCase();
        switch (upper) {
            case "PDF":
                return "pdf-viewer";
            case "EPUB":
                return "epub-viewer";
            case "AUDIO":
                return "audio-player";
            default:
                return "epub-viewer";
        }
    }

    private String resolveCoverPath(String cover) {
        if (cover == null || cover.isEmpty()) {
            return cover;
        }
        if (cover.startsWith(filePath)) {
            return cover;
        }
        return filePath + cover;
    }

    public String verifyToken(String encryptedToken) {
        return tokenUtil.decrypt(encryptedToken);
    }

    public static class BookInfo {
        private String bcode;
        private String title;
        private String writer;
        private String publisher;
        private String cover;
        private String ft;
        private String lcd;
        private String sbcode;
        private String ot;

        public String getBcode() {
            return bcode;
        }

        public void setBcode(String bcode) {
            this.bcode = bcode;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getWriter() {
            return writer;
        }

        public void setWriter(String writer) {
            this.writer = writer;
        }

        public String getPublisher() {
            return publisher;
        }

        public void setPublisher(String publisher) {
            this.publisher = publisher;
        }

        public String getCover() {
            return cover;
        }

        public void setCover(String cover) {
            this.cover = cover;
        }

        public String getFt() {
            return ft;
        }

        public void setFt(String ft) {
            this.ft = ft;
        }

        public String getLcd() {
            return lcd;
        }

        public void setLcd(String lcd) {
            this.lcd = lcd;
        }

        public String getSbcode() {
            return sbcode;
        }

        public void setSbcode(String sbcode) {
            this.sbcode = sbcode;
        }

        public String getOt() {
            return ot;
        }

        public void setOt(String ot) {
            this.ot = ot;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private final BookInfo info = new BookInfo();

            public Builder bcode(String bcode) {
                info.bcode = bcode;
                return this;
            }

            public Builder title(String title) {
                info.title = title;
                return this;
            }

            public Builder writer(String writer) {
                info.writer = writer;
                return this;
            }

            public Builder publisher(String publisher) {
                info.publisher = publisher;
                return this;
            }

            public Builder cover(String cover) {
                info.cover = cover;
                return this;
            }

            public Builder ft(String ft) {
                info.ft = ft;
                return this;
            }

            public Builder lcd(String lcd) {
                info.lcd = lcd;
                return this;
            }

            public Builder sbcode(String sbcode) {
                info.sbcode = sbcode;
                return this;
            }

            public Builder ot(String ot) {
                info.ot = ot;
                return this;
            }

            public BookInfo build() {
                return info;
            }
        }
    }
}
