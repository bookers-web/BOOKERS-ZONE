package life.bks.zone.service.auth;

import life.bks.zone.domain.B2bMember;
import life.bks.zone.mapper.bookers.B2bMemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class GuestLoginServiceImpl implements GuestLoginService {

    private final B2bMemberMapper b2bMemberMapper;

    @Override
    @Transactional
    public String findOrCreateZoneGuest(String uisCode, String clientIp) {
        // IP 끝자리 추출 (ex: 192.168.1.100 → 100)
        String ipSuffix = clientIp.contains(".")
                ? clientIp.substring(clientIp.lastIndexOf('.') + 1)
                : clientIp;

        // zone_{기관코드}_{IP끝자리} 형식의 userId 생성
        String zoneUserId = "zone_" + uisCode + "_" + ipSuffix;

        // 1. 기존 zone guest 조회 (빠른 경로 - 잠금 없이)
        B2bMember existing = b2bMemberMapper.selectByUisCodeAndUserid(uisCode, zoneUserId);
        if (existing != null) {
            log.info("기존 Zone guest 재사용 - umCode: {}, userId: {}", existing.getUmCode(), zoneUserId);
            return existing.getUmCode();
        }

        // 2. 시퀀스 조회 (FOR UPDATE — 동시 요청 직렬화)
        B2bMember seqMember = new B2bMember();
        seqMember.setSeqName("MEMBER_MASTER_SEQ");
        b2bMemberMapper.getSequence(seqMember);

        // 3. 잠금 획득 후 재조회 (REPEATABLE READ에서 current read 필요)
        //    다른 스레드가 이미 INSERT 했을 수 있으므로 FOR UPDATE로 최신 데이터 확인
        B2bMember existingAfterLock = b2bMemberMapper.selectByUisCodeAndUseridForUpdate(uisCode, zoneUserId);
        if (existingAfterLock != null) {
            log.info("동시 요청으로 이미 생성된 Zone guest 재사용 - umCode: {}, userId: {}", existingAfterLock.getUmCode(), zoneUserId);
            return existingAfterLock.getUmCode();
        }

        // 4. 신규 Zone guest 등록
        String seqStr = Integer.toString(seqMember.getSeqCurrval());
        String umCode = "UM" + String.format("%011d", seqMember.getSeqCurrval());

        B2bMember newMember = B2bMember.builder()
                .umCode(seqStr)           // SQL에서 CONCAT('UM', LPAD(#{umCode},11,'0'))
                .umUserid(zoneUserId)
                .umUisCode(uisCode)
                .umRegType("Z")            // Zone 관내이용자
                .umName("관내이용자_" + ipSuffix)
                .umRegUserid("zone_system")
                .umUseyn("Y")
                .umFreeAccount("Y")    // 테스트 단계 무료 계정
                .build();

        try {
            b2bMemberMapper.insertMember(newMember);
            log.info("신규 Zone guest 등록 - umCode: {}, userId: {}, uisCode: {}", umCode, zoneUserId, uisCode);
            return umCode;
        } catch (DuplicateKeyException e) {
            // 극히 드문 edge case 방어: FOR UPDATE 재조회 이후에도 동시 INSERT 발생 시
            log.warn("Zone guest 중복 INSERT 감지, 기존 회원 재조회 - userId: {}", zoneUserId);
            B2bMember fallback = b2bMemberMapper.selectByUisCodeAndUseridForUpdate(uisCode, zoneUserId);
            if (fallback != null) {
                return fallback.getUmCode();
            }
            throw e;
        }
    }
}
