package life.bks.zone.scheduler;

import life.bks.zone.service.auth.IpAuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SessionCleanupScheduler {

    private final IpAuthService ipAuthService;

    /**
     * 1분마다 만료된 세션을 정리
     */
    @Scheduled(fixedRate = 60000)
    public void cleanupExpiredSessions() {
        try {
            ipAuthService.cleanupExpiredSessions();
        } catch (Exception e) {
            log.error("만료 세션 정리 중 오류 발생", e);
        }
    }
}
