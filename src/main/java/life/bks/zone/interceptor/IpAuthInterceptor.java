package life.bks.zone.interceptor;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import life.bks.zone.domain.ZoneConfig;
import life.bks.zone.dto.SessionValidateResponse;
import life.bks.zone.service.auth.IpAuthService;
import life.bks.zone.util.IpUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Slf4j
@Component
@RequiredArgsConstructor
public class IpAuthInterceptor implements HandlerInterceptor {
    
    private static final String SESSION_COOKIE_NAME = "BKS_ZONE_SESSION";
    private static final int COOKIE_MAX_AGE = 60 * 20;
    
    private final IpAuthService ipAuthService;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String clientIp = IpUtils.getClientIp(request);
        String path = request.getServletPath();
        
        ZoneConfig config = ipAuthService.findConfigByIp(clientIp);
        
        if (config == null) {
            log.info("IP 인증 실패 - 허용되지 않은 IP: {}, www.bookers.life로 리다이렉트", clientIp);
            response.sendRedirect("https://www.bookers.life/");
            return false;
        }
        
        String sessionId = getSessionIdFromCookie(request);
        if (sessionId != null) {
            SessionValidateResponse validation = ipAuthService.validateSession(sessionId, clientIp);
            if (validation.isValid()) {
                ipAuthService.refreshSession(sessionId);
                renewSessionCookie(response, sessionId);
                request.setAttribute("uisCode", config.getUisCode());
                request.setAttribute("uisName", config.getUisName());
                return true;
            }
        }
        
        if (isLoginPageRequest(path) || isGuestEnterRequest(path)) {
            return true;
        }
        
        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }
    
    private String getSessionIdFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        
        for (Cookie cookie : cookies) {
            if (SESSION_COOKIE_NAME.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        
        return null;
    }
    
    private boolean isLoginPageRequest(String path) {
        return "/".equals(path) || "/login".equals(path);
    }
    
    private boolean isGuestEnterRequest(String path) {
        return "/zone/enter".equals(path);
    }

    private void renewSessionCookie(HttpServletResponse response, String sessionId) {
        Cookie cookie = new Cookie(SESSION_COOKIE_NAME, sessionId);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        response.addCookie(cookie);
    }
}
