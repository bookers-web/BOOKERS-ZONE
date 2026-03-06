package life.bks.zone.dao.home;

import life.bks.zone.vo.CmVO;
import life.bks.zone.vo.CommonVO;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontEventVO;
import life.bks.zone.vo.FrontRecommendGroupVO;
import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.SearchVO;

import java.util.List;

public interface FrontRecommendDAO {

	int groupListCount(SearchVO searchVO);

	List<FrontRecommendGroupVO> groupList(FrontRecommendVO frontRecommendVO);

	int groupCommonListCount(SearchVO searchVO);

	List<FrontRecommendGroupVO> groupCommonList(FrontRecommendVO frontRecommendVO);

	List<CmVO> bookList(FrontRecommendGroupVO frontRecommendGroupVO);

	FrontCmVO selectBookDetail(FrontCmVO frontCmVO);

	FrontCmVO selectBookDetailInfo(FrontCmVO frontCmVO);

	List<FrontCmVO> bookPopularList(FrontCmVO frontCmVO);

	int getSeqence(CommonVO commonVO);

	int newBookListCount(FrontCmVO frontCmVO);

	List<FrontCmVO> newBookList(FrontCmVO frontCmVO);

	List<FrontCmVO> popularList(FrontCmVO frontCmVO);

	List<FrontCmVO> bestPopularList(FrontCmVO frontCmVO);

	List<FrontCmVO> searchPopularList(FrontCmVO frontCmVO);

	int categoryListCount(FrontCmVO frontCmVO);

	List<FrontCmVO> categoryList(FrontCmVO frontCmVO);

	int bookSearchListCount(FrontCmVO frontCmVO);

	List<FrontCmVO> bookSearchList(FrontCmVO frontCmVO);
	List<FrontCmVO> bookSolrSearchList(FrontCmVO frontCmVO);


	List<FrontEventVO> bookEventList(FrontCmVO frontCmVO);

	List<FrontRecommendGroupVO> bookDetailCuration(FrontCmVO frontCmVO);
	// 카테고리 목록 조회 (eBook/오디오북 탭 하위 카테고리 표시용)
	List<FrontCmVO> selectCategoryList(FrontCmVO frontCmVO);
	// 공지사항
	int noticeListCount(FrontCmVO frontCmVO);
	List<FrontCmVO> noticeList(FrontCmVO frontCmVO);
	// 이용약관
	FrontCmVO tosInfo(FrontCmVO frontCmVO);
	// 개인정보 처리방침
	FrontCmVO policyInfo(FrontCmVO frontCmVO);

	// 추천 서재 도서 목록
	int recommendBookListCount(FrontCmVO frontCmVO);
	List<FrontCmVO> recommendBookList(FrontCmVO frontCmVO);
	String selectRecommendGroupName(FrontCmVO frontCmVO);

    // WWW 동일 쿼리 - searchRecommend (ORDER BY 없음)
    int searchRecommendCount(FrontCmVO frontCmVO);
    List<FrontCmVO> searchRecommend(FrontCmVO frontCmVO);
	// 카테고리 목록 조회 v2 (depth 0 + depth 1 포함)
	List<FrontCmVO> selectCategoryListV2(FrontCmVO frontCmVO);
	// 사용 가능한 카테고리 타입 조회 (E, A)
	List<String> selectAvailableCategoryTypes(FrontCmVO frontCmVO);
    // 검색 페이지용 카테고리 목록 (content_count 포함)
    List<FrontCmVO> selectSearchCategoryList(FrontCmVO frontCmVO);

}
