package life.bks.zone.service.auth;

import life.bks.zone.domain.B2bMember;
import life.bks.zone.mapper.bookers.B2bMemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class GuestLoginServiceImpl implements GuestLoginService {

    private final B2bMemberMapper b2bMemberMapper;

    @Override
    public String createZoneGuest(String uisCode, String clientIp) {
        // 1. 시퀀스 조회 (FOR UPDATE — 동시 요청 직렬화)
        B2bMember seqMember = new B2bMember();
        seqMember.setSeqName("MEMBER_MASTER_SEQ");
        b2bMemberMapper.getSequence(seqMember);

        // 2. 세션당 고유 guest 계정 생성 (시퀀스로 충돌 방지)
        String seqStr = Integer.toString(seqMember.getSeqCurrval());
        String umCode = "UM" + String.format("%011d", seqMember.getSeqCurrval());
        String zoneUserId = "zone_" + uisCode + "_" + seqStr;

        B2bMember newMember = B2bMember.builder()
                .umCode(seqStr)
                .umUserid(zoneUserId)
                .umUisCode(uisCode)
                .umRegType("Z")
                .umName("관내이용자_" + clientIp)
                .umRegUserid("zone_system")
                .umUseyn("Y")
                .umFreeAccount("Y")
                .build();

        b2bMemberMapper.insertMember(newMember);
        log.info("신규 Zone guest 등록 - umCode: {}, userId: {}, uisCode: {}, IP: {}",
                umCode, zoneUserId, uisCode, clientIp);
        return umCode;
    }
}
