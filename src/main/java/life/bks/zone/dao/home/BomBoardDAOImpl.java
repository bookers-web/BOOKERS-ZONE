package life.bks.zone.dao.home;

import life.bks.zone.vo.BomBoardVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BomBoardDAOImpl implements BomBoardDAO {
    private static final String namespace = "resources.mappers.bom.BomBoardMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<BomBoardVO> getNoticesByUisCode(String uis_code) {
        return sqlSession.selectList(namespace + ".getNoticesByUisCode", uis_code);
    }
}
