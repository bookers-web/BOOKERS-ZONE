package life.bks.zone.service.auth;

import life.bks.zone.dto.GuestLoginResponse;

public interface GuestLoginService {
    
    GuestLoginResponse guestLogin(String requestCode, String requestId, String clientIp, String userAgent);

    /**
     * 관내 비회원 Zone guest 회원 조회 또는 생성
     * @param uisCode 기관코드
     * @param clientIp 클라이언트 IP
     * @return UM_CODE (UM00000XXXXXX 형식)
     */
    String findOrCreateZoneGuest(String uisCode, String clientIp);
}
