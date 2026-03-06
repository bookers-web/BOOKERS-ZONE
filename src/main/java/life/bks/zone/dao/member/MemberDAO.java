package life.bks.zone.dao.member;

import life.bks.zone.vo.MemberVO;

public interface MemberDAO {
    MemberVO selectOrm(MemberVO memberVO);
    String selectUcpCode(String uisCode);
}
