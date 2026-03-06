package life.bks.zone.dao.home;

import life.bks.zone.vo.CmVO;
import life.bks.zone.vo.CommonVO;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontEventVO;
import life.bks.zone.vo.FrontRecommendGroupVO;
import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.SearchVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.lang.reflect.Field;
import java.util.List;

@Repository
public class FrontRecommendDAOImpl implements FrontRecommendDAO {
    private static final String namespace = "resources.mappers.front.recommend.FrontRecommendMapper";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public int groupListCount(SearchVO searchVO) {
        return sqlSession.selectOne(namespace + ".groupListCount", searchVO);
    }

    @Override
    public List<FrontRecommendGroupVO> groupList(FrontRecommendVO frontRecommendVO) {
        return sqlSession.selectList(namespace + ".groupList", frontRecommendVO);
    }

    @Override
    public int groupCommonListCount(SearchVO searchVO) {
        return sqlSession.selectOne(namespace + ".groupCommonListCount", searchVO);
    }

    @Override
    public List<FrontRecommendGroupVO> groupCommonList(FrontRecommendVO frontRecommendVO) {
        return sqlSession.selectList(namespace + ".groupCommonList", frontRecommendVO);
    }

    @Override
    public List<CmVO> bookList(FrontRecommendGroupVO frontRecommendGroupVO) {
        return sqlSession.selectList(namespace + ".bookList", frontRecommendGroupVO);
    }

    @Override
    public FrontCmVO selectBookDetail(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectBookDetail", frontCmVO);
    }

    @Override
    public FrontCmVO selectBookDetailInfo(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectBookDetailInfo", frontCmVO);
    }

    @Override
    public List<FrontCmVO> bookPopularList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".bookPopularList", frontCmVO);
    }

    @Override
    public int getSeqence(CommonVO commonVO) {
        sqlSession.update(namespace + ".getSeqence", commonVO);
        return commonVO.getSeq_currval();
    }

    @Override
    public int newBookListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".newBookListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> newBookList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".newBookList", frontCmVO);
    }

    @Override
    public int recommendBookListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".recommendBookListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> recommendBookList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".recommendBookList", frontCmVO);
    }

    @Override
    public String selectRecommendGroupName(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".selectRecommendGroupName", frontCmVO);
    }

    @Override
    public int searchRecommendCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".searchRecommendCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> searchRecommend(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".searchRecommend", frontCmVO);
    }

    @Override
    public List<FrontCmVO> popularList(FrontCmVO frontCmVO) {
        if (isReturnProcessEnabled(frontCmVO)) {
            return sqlSession.selectList(namespace + ".popularList", frontCmVO);
        }
        return sqlSession.selectList(namespace + ".popularList_v2", frontCmVO);
    }

    @Override
    public List<FrontCmVO> bestPopularList(FrontCmVO frontCmVO) {
        if (isReturnProcessEnabled(frontCmVO)) {
            return sqlSession.selectList(namespace + ".bestPopularList", frontCmVO);
        }
        return sqlSession.selectList(namespace + ".bestPopularList_v2", frontCmVO);
    }

    @Override
    public List<FrontCmVO> searchPopularList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".searchPopularList", frontCmVO);
    }

    @Override
    public int categoryListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".categoryListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> categoryList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".categoryList", frontCmVO);
    }

    @Override
    public int bookSearchListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".bookSearchListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> bookSearchList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".bookSearchList", frontCmVO);
    }

	@Override
	public List<FrontCmVO> bookSolrSearchList(FrontCmVO frontCmVO) {
		return sqlSession.selectList(namespace + ".bookSolrSearchList", frontCmVO);
	}

    @Override
    public List<FrontEventVO> bookEventList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".bookEventList", frontCmVO);
    }

    @Override
    public List<FrontRecommendGroupVO> bookDetailCuration(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".bookDetailCuration", frontCmVO);
    }

    @Override
    public List<FrontCmVO> selectCategoryList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".selectCategoryList", frontCmVO);
    }

    @Override
    public int noticeListCount(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".noticeListCount", frontCmVO);
    }

    @Override
    public List<FrontCmVO> noticeList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".noticeList", frontCmVO);
    }

    @Override
    public FrontCmVO tosInfo(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".tosInfo", frontCmVO);
    }

    @Override
    public FrontCmVO policyInfo(FrontCmVO frontCmVO) {
        return sqlSession.selectOne(namespace + ".policyInfo", frontCmVO);
    }


    @Override
    public List<FrontCmVO> selectCategoryListV2(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".selectCategoryList_v2", frontCmVO);
    }

    @Override
    public List<String> selectAvailableCategoryTypes(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".selectAvailableCategoryTypes", frontCmVO);
    }

    @Override
    public List<FrontCmVO> selectSearchCategoryList(FrontCmVO frontCmVO) {
        return sqlSession.selectList(namespace + ".selectSearchCategoryList", frontCmVO);
    }

    private boolean isReturnProcessEnabled(FrontCmVO frontCmVO) {
        try {
            Field field = FrontCmVO.class.getDeclaredField("uis_return_flag");
            field.setAccessible(true);
            Object value = field.get(frontCmVO);
            return "Y".equals(value);
        } catch (NoSuchFieldException | IllegalAccessException e) {
            return false;
        }
    }
}
