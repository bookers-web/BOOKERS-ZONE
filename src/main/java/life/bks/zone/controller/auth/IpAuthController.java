package life.bks.zone.controller.auth;

import life.bks.zone.dto.ApiResponse;
import life.bks.zone.dto.IpAuthCheckResponse;
import life.bks.zone.dto.SessionCreateRequest;
import life.bks.zone.dto.SessionCreateResponse;
import life.bks.zone.dto.SessionValidateResponse;
import life.bks.zone.service.auth.IpAuthService;
import life.bks.zone.util.IpUtils;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/ip-auth")
@RequiredArgsConstructor
public class IpAuthController {

    private static final String SESSION_COOKIE_NAME = "BKS_ZONE_SESSION";
    private static final int COOKIE_MAX_AGE = 60 * 20;

    private final IpAuthService ipAuthService;

    /**
     * IP 인증 확인
     * - 현재 IP가 허용된 기관 IP인지 체크
     * - 동시접속 현황 반환
     */
    @GetMapping("/check")
    public ResponseEntity<ApiResponse<IpAuthCheckResponse>> checkIpAuth(HttpServletRequest request) {
        String clientIp = IpUtils.getClientIp(request);
        IpAuthCheckResponse result = ipAuthService.checkIpAuth(clientIp);
        return ResponseEntity.ok(ApiResponse.ok(result));
    }

    /**
     * 세션 생성
     */
    @PostMapping("/session")
    public ResponseEntity<ApiResponse<SessionCreateResponse>> createSession(
            @RequestBody SessionCreateRequest sessionRequest,
            HttpServletRequest request,
            HttpServletResponse response) {

        String clientIp = IpUtils.getClientIp(request);
        String userAgent = request.getHeader("User-Agent");

        SessionCreateResponse result = ipAuthService.createSession(
                sessionRequest.getUisCode(), clientIp, userAgent);

        if (result.isSuccess()) {
            Cookie sessionCookie = new Cookie(SESSION_COOKIE_NAME, result.getSessionId());
            sessionCookie.setPath("/");
            sessionCookie.setHttpOnly(true);
            sessionCookie.setMaxAge(COOKIE_MAX_AGE);
            response.addCookie(sessionCookie);
        }

        return ResponseEntity.ok(
                result.isSuccess()
                        ? ApiResponse.ok(result)
                        : ApiResponse.fail(result.getMessage(), result.getErrorCode()));
    }

    /**
     * 세션 검증
     */
    @GetMapping("/session/validate")
    public ResponseEntity<ApiResponse<SessionValidateResponse>> validateSession(
            @RequestParam String sessionId,
            HttpServletRequest request) {

        String clientIp = IpUtils.getClientIp(request);
        SessionValidateResponse result = ipAuthService.validateSession(sessionId, clientIp);
        return ResponseEntity.ok(ApiResponse.ok(result));
    }

    /**
     * 세션 삭제 (로그아웃)
     */
    @DeleteMapping("/session/{sessionId}")
    public ResponseEntity<ApiResponse<Void>> destroySession(
            @PathVariable String sessionId,
            HttpServletResponse response) {

        ipAuthService.destroySession(sessionId);

        // 쿠키 삭제
        Cookie sessionCookie = new Cookie(SESSION_COOKIE_NAME, null);
        sessionCookie.setPath("/");
        sessionCookie.setHttpOnly(true);
        sessionCookie.setMaxAge(0);
        response.addCookie(sessionCookie);

        return ResponseEntity.ok(ApiResponse.ok(null, "세션이 삭제되었습니다."));
    }

    /**
     * 현재 동시접속 수 조회
     */
    @GetMapping("/session/count")
    public ResponseEntity<ApiResponse<Integer>> getSessionCount(@RequestParam String uisCode) {
        int count = ipAuthService.getCurrentSessionCount(uisCode);
        return ResponseEntity.ok(ApiResponse.ok(count));
    }
}
