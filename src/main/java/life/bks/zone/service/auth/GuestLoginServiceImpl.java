package life.bks.zone.service.auth;

import life.bks.zone.domain.B2bMember;
import life.bks.zone.domain.IpAuthSession;
import life.bks.zone.dto.GuestLoginResponse;
import life.bks.zone.mapper.bookers.B2bMemberMapper;
import life.bks.zone.mapper.IpAuthSessionMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class GuestLoginServiceImpl implements GuestLoginService {
    
    private final B2bMemberMapper b2bMemberMapper;
    private final IpAuthSessionMapper sessionMapper;
    
    @Override
    @Transactional
    public GuestLoginResponse guestLogin(String requestCode, String requestId, String clientIp, String userAgent) {
        
        if (requestCode == null || requestCode.isEmpty()) {
            return GuestLoginResponse.builder()
                    .success(false)
                    .message("기관 코드가 필요합니다.")
                    .errorCode("MISSING_REQUEST_CODE")
                    .build();
        }
        
        if (requestId == null || requestId.isEmpty()) {
            return GuestLoginResponse.builder()
                    .success(false)
                    .message("사용자 ID가 필요합니다.")
                    .errorCode("MISSING_REQUEST_ID")
                    .build();
        }
        
        String uisCode = "UIS" + requestCode;
        
        B2bMember existingMember = b2bMemberMapper.selectByUserid(requestId);
        String umCode;
        
        if (existingMember != null) {
            umCode = existingMember.getUmCode();
            log.info("기존 게스트 회원 로그인 - umCode: {}, requestId: {}", umCode, requestId);
        } else {
            B2bMember seqMember = new B2bMember();
            seqMember.setSeqName("MEMBER_MASTER_SEQ");
            b2bMemberMapper.getSequence(seqMember);
            String seqStr = Integer.toString(seqMember.getSeqCurrval());
            umCode = "UM" + String.format("%011d", seqMember.getSeqCurrval());

            B2bMember newMember = B2bMember.builder()
                    .umCode(seqStr)
                    .umUserid(requestId)
                    .umUisCode(uisCode)
                    .umRegType("G")
                    .umName(requestId)
                    .umRegUserid(requestId)
                    .umUseyn("Y")
                    .build();
            
            int result = b2bMemberMapper.insertMember(newMember);
            if (result <= 0) {
                return GuestLoginResponse.builder()
                        .success(false)
                        .message("회원 등록에 실패했습니다.")
                        .errorCode("MEMBER_INSERT_FAILED")
                        .build();
            }
            
            log.info("신규 게스트 회원 등록 - umCode: {}, requestId: {}, uisCode: {}", umCode, requestId, uisCode);
        }
        
        String sessionId = UUID.randomUUID().toString();
        
        IpAuthSession session = IpAuthSession.builder()
                .sessionId(sessionId)
                .uisCode(uisCode)
                .clientIp(clientIp)
                .userAgent(userAgent)
                .umCode(umCode)
                .build();
        
        sessionMapper.insert(session);
        
        log.info("게스트 세션 생성 - sessionId: {}, umCode: {}, uisCode: {}", sessionId, umCode, uisCode);
        
        return GuestLoginResponse.builder()
                .success(true)
                .message("게스트 로그인 성공")
                .umCode(umCode)
                .sessionId(sessionId)
                .build();
    }

    @Override
    @Transactional
    public String findOrCreateZoneGuest(String uisCode, String clientIp) {
        // IP 끝자리 추출 (ex: 192.168.1.100 → 100)
        String ipSuffix = clientIp.contains(".")
                ? clientIp.substring(clientIp.lastIndexOf('.') + 1)
                : clientIp;

        // zone_{기관코드}_{IP끝자리} 형식의 userId 생성
        String zoneUserId = "zone_" + uisCode + "_" + ipSuffix;

        // 1. 기존 zone guest 조회
        B2bMember existing = b2bMemberMapper.selectByUisCodeAndUserid(uisCode, zoneUserId);
        if (existing != null) {
            log.info("기존 Zone guest 재사용 - umCode: {}, userId: {}", existing.getUmCode(), zoneUserId);
            return existing.getUmCode();
        }

        // 2. 시퀀스 조회 (FOR UPDATE)
        B2bMember seqMember = new B2bMember();
        seqMember.setSeqName("MEMBER_MASTER_SEQ");
        b2bMemberMapper.getSequence(seqMember);
        String seqStr = Integer.toString(seqMember.getSeqCurrval());
        String umCode = "UM" + String.format("%011d", seqMember.getSeqCurrval());

        // 3. 신규 Zone guest 등록
        B2bMember newMember = B2bMember.builder()
                .umCode(seqStr)           // SQL에서 CONCAT('UM', LPAD(#{umCode},11,'0'))
                .umUserid(zoneUserId)
                .umUisCode(uisCode)
                .umRegType("Z")            // Zone 관내이용자
                .umName("관내이용자_" + ipSuffix)
                .umRegUserid("zone_system")
                .umUseyn("Y")
                .build();

        b2bMemberMapper.insertMember(newMember);
        log.info("신규 Zone guest 등록 - umCode: {}, userId: {}, uisCode: {}", umCode, zoneUserId, uisCode);

        return umCode;
    }
}
