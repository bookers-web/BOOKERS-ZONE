package life.bks.zone.util;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * DRM Token 암호화 유틸리티
 *
 * Shadow DRM Server와 통신하기 위한 AES-256-GCM 토큰 암호화 클래스입니다.
 *
 * 사용법:
 * <pre>
 * // 1. 인스턴스 생성 (비밀키는 환경변수에서 로드)
 * ShadowDrmTokenUtil tokenUtil = new ShadowDrmTokenUtil(System.getenv("DRM_TOKEN_SECRET_KEY"));
 *
 * // 2. 토큰 페이로드 생성
 * String payload = ShadowDrmTokenUtil.createPayloadJson(
 *     "v1",                    // kid
 *     "UCM_abc123",            // ucm
 *     "USR_user123",           // uid
 *     "web-viewer",            // did (고정값 또는 fingerprint)
 *     "EPUB",                  // typ
 *     "도서 제목",              // title
 *     "저자명",                 // author
 *     "출판사",                 // publisher
 *     "https://cdn.../cover.jpg", // cover
 *     true,                    // perm.read
 *     false,                   // perm.download
 *     "ORG001",                // org
 *     "SUB001",                // sub
 *     "P",                     // ot (T:대여/P:구매)
 *     300                      // 유효시간 (초) - 5분 권장
 * );
 *
 * // 3. 암호화
 * String encryptedToken = tokenUtil.encrypt(payload);
 * </pre>
 *
 * @author MakeVibe Inc.
 * @version 2.0.0
 * @since 2025-12-15
 */
public class WVEncryptV2 {

    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_NONCE_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 128;

    private final SecretKeySpec secretKey;
    private final SecureRandom secureRandom;

    /**
     * ShadowDrmTokenUtil 생성자
     *
     * @param secretKeyBase64 Base64 인코딩된 32바이트 비밀키
     * @throws IllegalArgumentException 키 형식이 잘못된 경우
     */
    public WVEncryptV2(String secretKeyBase64) {
        if (secretKeyBase64 == null || secretKeyBase64.isEmpty()) {
            throw new IllegalArgumentException("Secret key cannot be null or empty");
        }

        byte[] keyBytes = Base64.getDecoder().decode(secretKeyBase64);
        if (keyBytes.length != 32) {
            throw new IllegalArgumentException(
                    "Invalid secret key length: expected 32 bytes, got " + keyBytes.length);
        }

        this.secretKey = new SecretKeySpec(keyBytes, ALGORITHM);
        this.secureRandom = new SecureRandom();
    }

    /**
     * 토큰 페이로드 암호화
     *
     * @param payload JSON 형식의 토큰 페이로드
     * @return Base64 인코딩된 암호화 토큰 (nonce + ciphertext + tag)
     * @throws RuntimeException 암호화 실패 시
     */
    public String encrypt(String payload) {
        try {
            byte[] nonce = new byte[GCM_NONCE_LENGTH];
            secureRandom.nextBytes(nonce);

            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, nonce);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, gcmSpec);

            byte[] plaintext = payload.getBytes(StandardCharsets.UTF_8);
            byte[] ciphertext = cipher.doFinal(plaintext);

            byte[] combined = new byte[nonce.length + ciphertext.length];
            System.arraycopy(nonce, 0, combined, 0, nonce.length);
            System.arraycopy(ciphertext, 0, combined, nonce.length, ciphertext.length);

            return Base64.getEncoder().encodeToString(combined);

        } catch (Exception e) {
            throw new RuntimeException("Token encryption failed", e);
        }
    }

    /**
     * 암호화된 토큰 복호화 (테스트용)
     *
     * @param encryptedToken Base64 인코딩된 암호화 토큰
     * @return 복호화된 JSON 페이로드
     * @throws RuntimeException 복호화 실패 시
     */
    public String decrypt(String encryptedToken) {
        try {
            byte[] combined = Base64.getDecoder().decode(encryptedToken);

            byte[] nonce = new byte[GCM_NONCE_LENGTH];
            byte[] ciphertext = new byte[combined.length - GCM_NONCE_LENGTH];
            System.arraycopy(combined, 0, nonce, 0, GCM_NONCE_LENGTH);
            System.arraycopy(combined, GCM_NONCE_LENGTH, ciphertext, 0, ciphertext.length);

            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, nonce);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, gcmSpec);

            byte[] plaintext = cipher.doFinal(ciphertext);

            return new String(plaintext, StandardCharsets.UTF_8);

        } catch (Exception e) {
            throw new RuntimeException("Token decryption failed", e);
        }
    }

    /**
     * 토큰 페이로드 JSON 생성 (신규 스펙 v2.0)
     *
     * @param kid 키 버전 ID (예: "v1")
     * @param ucm 콘텐츠 ID (예: "UCM_abc123")
     * @param uid 사용자 ID (예: "USR_user123")
     * @param did 디바이스 ID (선택, "web-viewer" 고정값 가능)
     * @param typ 콘텐츠 타입 (EPUB, PDF, AUDIO, COMIC)
     * @param title 도서 제목
     * @param author 저자
     * @param publisher 출판사
     * @param cover 표지 이미지 URL
     * @param permRead 열람 권한
     * @param permDownload 다운로드 권한
     * @param org 기관 코드 (선택)
     * @param sub 서브 코드 (선택)
     * @param ot 주문 타입 (T:대여/P:구매, 선택)
     * @param validSeconds 토큰 유효 시간 (초, 권장: 300)
     * @return JSON 문자열
     */
    public static String createPayloadJson(
            String kid,
            String ucm,
            String uid,
            String did,
            String typ,
            String title,
            String author,
            String publisher,
            String cover,
            boolean permRead,
            boolean permDownload,
            String org,
            String sub,
            String ot,
            int validSeconds) {

        long now = System.currentTimeMillis() / 1000;
        long exp = now + validSeconds;

        StringBuilder json = new StringBuilder();
        json.append("{");

        json.append("\"kid\":\"").append(escapeJson(kid)).append("\"");
        json.append(",\"ucm\":\"").append(escapeJson(ucm)).append("\"");
        json.append(",\"uid\":\"").append(escapeJson(uid)).append("\"");
        json.append(",\"did\":\"").append(escapeJson(did != null ? did : "web-viewer")).append("\"");
        json.append(",\"exp\":").append(exp);
        json.append(",\"iat\":").append(now);
        json.append(",\"typ\":\"").append(escapeJson(typ)).append("\"");

        json.append(",\"meta\":{");
        json.append("\"title\":\"").append(escapeJson(title)).append("\"");
        json.append(",\"author\":\"").append(escapeJson(author)).append("\"");
        json.append(",\"publisher\":\"").append(escapeJson(publisher)).append("\"");
        json.append(",\"cover\":\"").append(escapeJson(cover)).append("\"");
        json.append("}");

        json.append(",\"perm\":{");
        json.append("\"read\":").append(permRead);
        json.append(",\"download\":").append(permDownload);
        json.append("}");

        if (org != null && !org.isEmpty()) {
            json.append(",\"org\":\"").append(escapeJson(org)).append("\"");
        }
        if (sub != null && !sub.isEmpty()) {
            json.append(",\"sub\":\"").append(escapeJson(sub)).append("\"");
        }
        if (ot != null && !ot.isEmpty()) {
            json.append(",\"ot\":\"").append(escapeJson(ot)).append("\"");
        }

        json.append("}");
        return json.toString();
    }

    /**
     * 간단한 토큰 페이로드 생성 (필수 필드만)
     */
    public static String createSimplePayload(
            String ucm,
            String uid,
            String typ,
            String title,
            int validSeconds) {
        return createPayloadJson(
                "v1", ucm, uid, "web-viewer", typ,
                title, "", "", "",
                true, false,
                null, null, null,
                validSeconds
        );
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
