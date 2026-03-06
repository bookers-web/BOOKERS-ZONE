package life.bks.zone.dao.mypage;

import life.bks.zone.vo.FrontCmVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FrontMypageDAOImpl implements FrontMypageDAO {
    private static final String namespace = "life.bks.zone.mapper.FrontMypageMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<FrontCmVO> mainFaqList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".mainFaqList", frontCmVO);
    }

    @Override
    public int faqListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".faqListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> faqList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".faqList", frontCmVO);
    }

    @Override
    public FrontCmVO myExcellentSelect(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".myExcellentSelect", frontCmVO);
    }

    @Override
    public FrontCmVO myInfoSelect(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".myInfoSelect", frontCmVO);
    }

    @Override
    public FrontCmVO myInfoNoSelect(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".myInfoNoSelect", frontCmVO);
    }

    @Override
    public int myInfoModifyProc(FrontCmVO frontCmVO) {
        return sqlSession.update(namespace + ".myInfoModifyProc", frontCmVO);
    }

    @Override
    public int myDeviceListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".myDeviceListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> myDeviceList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".myDeviceList", frontCmVO);
    }

    @Override
    public int myDeviceModify(FrontCmVO frontCmVO) {
        return sqlSession.update(namespace + ".myDeviceModify", frontCmVO);
    }

    @Override
    public int deleteDevice(FrontCmVO frontCmVO) {
        return sqlSession.delete(namespace + ".deleteDevice", frontCmVO);
    }

    @Override
    public int myExcellentListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".myExcellentListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> myExcellentList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".myExcellentList", frontCmVO);
    }

    @Override
    public int myExcellentPrintState(FrontCmVO frontCmVO) {
        return sqlSession.update(namespace + ".myExcellentPrintState", frontCmVO);
    }
}
