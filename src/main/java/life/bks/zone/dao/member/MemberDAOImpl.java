package life.bks.zone.dao.member;

import life.bks.zone.vo.MemberVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO {
    private static final String namespace = "resources.mappers.member.MemberMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public MemberVO selectOrm(MemberVO memberVO) {
        return sqlSession.selectOne(namespace + ".selectOrm", memberVO);
    }

    @Override
    public String selectUcpCode(String uisCode) {
        return sqlSession.selectOne(namespace + ".selectUcpCode", uisCode);
    }
}
