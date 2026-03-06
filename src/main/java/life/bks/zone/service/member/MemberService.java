package life.bks.zone.service.member;

import life.bks.zone.vo.MemberVO;

public interface MemberService {
	
	/**
	 * description 회원 조회 (ORM)
	 * @param memberVO
	 * @return MemberVO
	 * @throws Exception
	 */
	public MemberVO selectOrm(MemberVO memberVO);

	/**
	 * 기관코드로 UIS_UCP_CODE 조회 (Zone 비회원 전용)
	 * @param uisCode 기관코드
	 * @return UIS_UCP_CODE (없으면 빈문자열)
	 */
	public String selectUcpCode(String uisCode);
}
