package life.bks.zone.service.auth;

import life.bks.zone.domain.ZoneConfig;
import life.bks.zone.domain.IpAuthIpRange;
import life.bks.zone.domain.IpAuthLog;
import life.bks.zone.domain.IpAuthSession;
import life.bks.zone.dto.IpAuthCheckResponse;
import life.bks.zone.dto.SessionCreateResponse;
import life.bks.zone.dto.SessionValidateResponse;
import life.bks.zone.mapper.ZoneConfigMapper;
import life.bks.zone.mapper.IpAuthIpRangeMapper;
import life.bks.zone.mapper.IpAuthLogMapper;
import life.bks.zone.mapper.IpAuthSessionMapper;
import life.bks.zone.util.IpUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class IpAuthServiceImpl implements IpAuthService {

    @Value("${zone.session.timeout-minutes}")
    private int sessionTimeoutMinutes;

    private final ZoneConfigMapper zoneConfigMapper;
    private final IpAuthIpRangeMapper rangeMapper;
    private final IpAuthSessionMapper sessionMapper;
    private final IpAuthLogMapper logMapper;
    private final GuestLoginService guestLoginService;

    @Override
    @Transactional(readOnly = true)
    public IpAuthCheckResponse checkIpAuth(String clientIp) {
        ZoneConfig config = findConfigByIp(clientIp);

        if (config == null) {
            return IpAuthCheckResponse.builder()
                    .ipAuthRequired(false)
                    .clientIp(clientIp)
                    .build();
        }

        int currentCount = sessionMapper.countActiveByUisCode(config.getUisCode());

        return IpAuthCheckResponse.builder()
                .ipAuthRequired(true)
                .uisCode(config.getUisCode())
                .uisName(config.getUisName())
                .maxConcurrent(config.getMaxConcurrent())
                .currentCount(currentCount)
                .clientIp(clientIp)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public ZoneConfig findConfigByIp(String clientIp) {
        List<IpAuthIpRange> ranges = rangeMapper.selectEnabledRanges();

        for (IpAuthIpRange range : ranges) {
            if (range.getIpPattern() != null && IpUtils.isInRange(clientIp, range.getIpPattern().trim())) {
                return zoneConfigMapper.selectByUisCode(range.getUisCode());
            }
        }

        return null;
    }

    @Override
    @Transactional
    public SessionCreateResponse createSession(String uisCode, String clientIp, String userAgent) {
        ZoneConfig config = zoneConfigMapper.selectByUisCodeForUpdate(uisCode);

        if (config == null) {
            return SessionCreateResponse.builder()
                    .success(false)
                    .message("기관 정보를 찾을 수 없습니다.")
                    .errorCode("CONFIG_NOT_FOUND")
                    .build();
        }

        // 만료 세션 정리
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(sessionTimeoutMinutes);
        List<IpAuthSession> expiredSessions = sessionMapper.selectExpiredSessions(threshold);
        if (!expiredSessions.isEmpty()) {
            sessionMapper.deleteExpiredSessions(threshold);
            log.info("만료 세션 {} 건 정리 완료 (uisCode: {})", expiredSessions.size(), uisCode);
        }

        int currentCount = sessionMapper.countActiveByUisCode(uisCode);

        if (currentCount >= config.getMaxConcurrent()) {
            return SessionCreateResponse.builder()
                    .success(false)
                    .message("최대 동시접속 수(" + config.getMaxConcurrent() + ")를 초과했습니다. 현재: " + currentCount)
                    .errorCode("MAX_CONCURRENT_EXCEEDED")
                    .build();
        }

        String sessionId = UUID.randomUUID().toString();

        // Zone guest 회원 생성 (세션당 개별 계정 — 정산용)
        String umCode = null;
        try {
            umCode = guestLoginService.createZoneGuest(uisCode, clientIp);
        } catch (Exception e) {
            log.error("Zone guest 회원 생성 실패 - uisCode: {}, IP: {}", uisCode, clientIp, e);
            // 회원 생성 실패해도 세션은 생성 (웹뷰어만 사용 불가)
        }

        IpAuthSession session = IpAuthSession.builder()
                .sessionId(sessionId)
                .uisCode(uisCode)
                .clientIp(clientIp)
                .userAgent(userAgent)
                .umCode(umCode)
                .build();

        sessionMapper.insert(session);

        log.info("세션 생성 - sessionId: {}, uisCode: {}, clientIp: {}, umCode: {}, 현재: {}/{}",
                sessionId, uisCode, clientIp, umCode, currentCount + 1, config.getMaxConcurrent());

        return SessionCreateResponse.builder()
                .success(true)
                .sessionId(sessionId)
                .umCode(umCode)
                .message("세션이 생성되었습니다.")
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public SessionValidateResponse validateSession(String sessionId, String clientIp) {
        IpAuthSession session = sessionMapper.selectById(sessionId);

        if (session == null) {
            return SessionValidateResponse.builder()
                    .valid(false)
                    .sessionId(sessionId)
                    .message("세션을 찾을 수 없습니다.")
                    .build();
        }

        // 세션 만료 체크
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(sessionTimeoutMinutes);
        if (session.getLastActiveAt() != null && session.getLastActiveAt().isBefore(threshold)) {
            return SessionValidateResponse.builder()
                    .valid(false)
                    .sessionId(sessionId)
                    .uisCode(session.getUisCode())
                    .message("세션이 만료되었습니다.")
                    .build();
        }

        // IP 바인딩 체크
        if (!session.getClientIp().equals(clientIp)) {
            return SessionValidateResponse.builder()
                    .valid(false)
                    .sessionId(sessionId)
                    .uisCode(session.getUisCode())
                    .message("세션 IP가 일치하지 않습니다.")
                    .build();
        }

        return SessionValidateResponse.builder()
                .valid(true)
                .sessionId(sessionId)
                .uisCode(session.getUisCode())
                .message("유효한 세션입니다.")
                .build();
    }

    @Override
    @Transactional
    public boolean refreshSession(String sessionId) {
        IpAuthSession session = sessionMapper.selectById(sessionId);
        if (session == null) {
            return false;
        }

        sessionMapper.updateLastActiveAt(sessionId, LocalDateTime.now());
        return true;
    }

    @Override
    @Transactional
    public void destroySession(String sessionId) {
        sessionMapper.delete(sessionId);
        log.info("세션 삭제 - sessionId: {}", sessionId);
    }

    @Override
    @Transactional
    public int destroyAllSessions(String uisCode) {
        int deleted = sessionMapper.deleteByUisCode(uisCode);
        log.info("전체 세션 삭제 - uisCode: {}, 삭제: {}건", uisCode, deleted);
        return deleted;
    }

    @Override
    @Transactional(readOnly = true)
    public int getCurrentSessionCount(String uisCode) {
        return sessionMapper.countActiveByUisCode(uisCode);
    }

    @Override
    @Transactional
    public void cleanupExpiredSessions() {
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(sessionTimeoutMinutes);
        List<IpAuthSession> expiredSessions = sessionMapper.selectExpiredSessions(threshold);

        if (!expiredSessions.isEmpty()) {
            int deleted = sessionMapper.deleteExpiredSessions(threshold);
            log.info("만료 세션 정리 - {} 건 삭제", deleted);
        }
    }

    @Override
    @Transactional
    public void logAction(String sessionId, String uisCode, String clientIp, String action, String bookId) {
        IpAuthLog authLog = IpAuthLog.builder()
                .sessionId(sessionId)
                .uisCode(uisCode)
                .clientIp(clientIp)
                .action(action)
                .bookId(bookId)
                .build();

        logMapper.insert(authLog);
    }
}
