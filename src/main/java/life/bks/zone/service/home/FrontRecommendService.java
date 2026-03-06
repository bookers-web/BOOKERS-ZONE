package life.bks.zone.service.home;

import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontEventVO;
import life.bks.zone.vo.SearchVO;

import java.util.List;

public interface FrontRecommendService {
	
	FrontRecommendVO list(SearchVO searchVO);
	
	FrontRecommendVO commonlist(SearchVO searchVO);

	FrontCmVO bookDetail(FrontCmVO frontCmVO);

	FrontCmVO bookDetailInfo(FrontCmVO frontCmVO);

	int getSeqence(String seqName);

	FrontCmVO newBookList(FrontCmVO frontCmVO);

	FrontCmVO popularList(FrontCmVO frontCmVO);

	FrontCmVO bestPopularList(FrontCmVO frontCmVO);

	List<FrontCmVO> searchPopularList(FrontCmVO frontCmVO);

	FrontCmVO categoryList(FrontCmVO frontCmVO);

	FrontCmVO bookSearchList(FrontCmVO frontCmVO);

	List<FrontEventVO> bookDetailEvent(FrontCmVO frontCmVO);

	FrontRecommendVO bookDetailCuration(FrontCmVO frontCmVO);
	// 카테고리 목록 조회 (eBook/오디오북 탭 하위 카테고리 표시용)
	List<FrontCmVO> selectCategoryList(FrontCmVO frontCmVO);
	// 공지사항
	FrontCmVO noticeList(FrontCmVO frontCmVO);
	// 이용약관
	FrontCmVO tosInfo(FrontCmVO frontCmVO);
	// 개인정보 처리방침
	FrontCmVO policyInfo(FrontCmVO frontCmVO);

	// 추천 서재 도서 목록
	FrontCmVO recommendList(FrontCmVO frontCmVO);
	String selectRecommendGroupName(FrontCmVO frontCmVO);
	// 카테고리 목록 조회 v2 (depth 0 + depth 1 포함)
	List<FrontCmVO> selectCategoryListV2(FrontCmVO frontCmVO);
	// 사용 가능한 카테고리 타입 조회 (E, A)
	List<String> selectAvailableCategoryTypes(FrontCmVO frontCmVO);
    // 검색 페이지용 카테고리 목록 (content_count 포함)
    List<FrontCmVO> selectSearchCategoryList(FrontCmVO frontCmVO);

}
