package life.bks.zone.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import life.bks.zone.dao.member.MemberDAO;
import life.bks.zone.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberDAO memberDAO;

	@Override
	public MemberVO selectOrm(MemberVO memberVO) {
		return memberDAO.selectOrm(memberVO);
	}

	@Override
	public String selectUcpCode(String uisCode) {
		String result = memberDAO.selectUcpCode(uisCode);
		return result != null ? result : "";
	}
}
