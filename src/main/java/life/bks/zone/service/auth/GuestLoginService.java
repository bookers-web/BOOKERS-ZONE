package life.bks.zone.service.auth;

public interface GuestLoginService {

    /**
     * 관내 비회원 Zone guest 회원 조회 또는 생성
     * @param uisCode 기관코드
     * @param clientIp 클라이언트 IP
     * @return UM_CODE (UM00000XXXXXX 형식)
     */
    String findOrCreateZoneGuest(String uisCode, String clientIp);
}
