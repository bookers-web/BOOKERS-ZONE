package life.bks.zone.dao.lounge;

import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.CommonVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FrontLoungeDAOImpl implements FrontLoungeDAO {
    private static final String namespace = "resources.mappers.front.lounge.FrontLoungeMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public int getSeqence(CommonVO commonVO) {
        sqlSession.update(namespace + ".getSeqence", commonVO);
        return commonVO.getSeq_currval();
    }

    @Override
    public int allBookReportListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".allBookReportListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> allBookReportList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".allBookReportList", frontCmVO);
    }

    @Override
    public int allBookReportDetailCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".allBookReportDetailCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> allBookReportDetail(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".allBookReportDetail", frontCmVO);
    }

    @Override
    public FrontCmVO allBookReportDetailView(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".allBookReportDetailView", frontCmVO);
    }

    @Override
    public int insertBookReportComment(FrontCmVO frontCmVO) {
        return sqlSession.insert(namespace + ".insertBookReportComment", frontCmVO);
    }

    @Override
    public int deleteBookReportComment(FrontCmVO frontCmVO) {
        return sqlSession.delete(namespace + ".deleteBookReportComment", frontCmVO);
    }

    @Override
    public FrontCmVO selectBookReportComment(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectBookReportComment", frontCmVO);
    }

    @Override
    public void bookReportState(FrontCmVO frontCmVO) {
        sqlSession.update(namespace + ".bookReportState", frontCmVO);
    }

    @Override
    public int allDiscussionListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".allDiscussionListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> allDiscussionList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".allDiscussionList", frontCmVO);
    }

    @Override
    public int allDiscussionDetailCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".allDiscussionDetailCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> allDiscussionDetail(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".allDiscussionDetail", frontCmVO);
    }

    @Override
    public int insertDiscussion(FrontCmVO frontCmVO) {
        return sqlSession.insert(namespace + ".insertDiscussion", frontCmVO);
    }

    @Override
    public int updateDiscussion(FrontCmVO frontCmVO) {
        return sqlSession.update(namespace + ".updateDiscussion", frontCmVO);
    }

    @Override
    public int deleteDiscussion(FrontCmVO frontCmVO) {
        return sqlSession.delete(namespace + ".deleteDiscussion", frontCmVO);
    }

    @Override
    public int insertDiscussionComment(FrontCmVO frontCmVO) {
        return sqlSession.insert(namespace + ".insertDiscussionComment", frontCmVO);
    }

    @Override
    public int deleteDiscussionComment(FrontCmVO frontCmVO) {
        return sqlSession.delete(namespace + ".deleteDiscussionComment", frontCmVO);
    }

    @Override
    public FrontCmVO selectDiscussionComment(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectDiscussionComment", frontCmVO);
    }

    @Override
    public int insertReportCopyright(FrontCmVO frontCmVO) {
        return sqlSession.insert(namespace + ".insertReportCopyright", frontCmVO);
    }

    @Override
    public FrontCmVO selectProhibition(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectProhibition", frontCmVO);
    }
}
