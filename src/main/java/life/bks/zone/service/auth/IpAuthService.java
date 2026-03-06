package life.bks.zone.service.auth;

import life.bks.zone.domain.IpAuthConfig;
import life.bks.zone.domain.IpAuthSession;
import life.bks.zone.dto.IpAuthCheckResponse;
import life.bks.zone.dto.SessionCreateResponse;
import life.bks.zone.dto.SessionValidateResponse;

public interface IpAuthService {
    
    IpAuthCheckResponse checkIpAuth(String clientIp);
    
    IpAuthConfig findConfigByIp(String clientIp);
    
    SessionCreateResponse createSession(String uisCode, String clientIp, String userAgent);
    
    SessionValidateResponse validateSession(String sessionId, String clientIp);
    
    boolean refreshSession(String sessionId);
    
    void destroySession(String sessionId);
    
    int destroyAllSessions(String uisCode);
    
    int getCurrentSessionCount(String uisCode);
    
    void cleanupExpiredSessions();
    
    void logAction(String sessionId, String uisCode, String clientIp, String action, String bookId);
}
