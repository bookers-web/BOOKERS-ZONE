package life.bks.zone.service.home;

import life.bks.zone.dao.home.FrontRecommendDAO;
import life.bks.zone.vo.CommonVO;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontEventVO;
import life.bks.zone.vo.FrontRecommendGroupVO;
import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.SearchVO;
import life.bks.zone.util.solr.SolrRestTemplateUtil;
import life.bks.zone.util.solr.SolrSearchResult;
import life.bks.zone.util.solr.SolrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class FrontRecommendServiceImpl implements FrontRecommendService {

	@Autowired
	private FrontRecommendDAO frontRecommendDAO;

	@Override
	public FrontRecommendVO list(SearchVO searchVO) {
		FrontRecommendVO resultList = new FrontRecommendVO();

		int ppageSize = searchVO.getPageSize();
		int cpagenum = searchVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}

		resultList.setTotalCount(frontRecommendDAO.groupListCount(searchVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(resultList.getPagenum() * 24);

		resultList.setSearchName(searchVO.getSearchName());
		resultList.setSearchName2(searchVO.getSearchName2());
		resultList.setSearchGrade(searchVO.getSearchGrade());
		resultList.setSearchUseYn(searchVO.getSearchUseYn());
		resultList.setSearchUisCode(searchVO.getSearchUisCode());
		resultList.setSearchStartDate(searchVO.getSearchStartDate());
		resultList.setSearchEndDate(searchVO.getSearchEndDate());
		resultList.setSortField1(searchVO.getSortField1());
		resultList.setSearchKey(searchVO.getSearchKey());
		resultList.setSearchUcpCode(searchVO.getSearchUcpCode());
		resultList.setSearch_uis_copy_book_flag(searchVO.getSearch_uis_copy_book_flag());
		resultList.setSearch_uis_return_flag(searchVO.getSearch_uis_return_flag());

		List<FrontRecommendGroupVO> groupList = frontRecommendDAO.groupList(resultList);

		if (resultList.getTotalCount() > 0) {
			for (int i = 0; i < groupList.size(); i++) {
				FrontRecommendGroupVO temp = groupList.get(i);
				temp.setSearch_uis_copy_book_flag(searchVO.getSearch_uis_copy_book_flag());
				temp.setSearch_uis_return_flag(searchVO.getSearch_uis_return_flag());
				temp.setSearchUisCode(searchVO.getSearchUisCode());
				groupList.get(i).setBookList(frontRecommendDAO.bookList(temp));
			}
			resultList.setGroupList(groupList);
		}

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontRecommendVO commonlist(SearchVO searchVO) {
		FrontRecommendVO resultList = new FrontRecommendVO();

		int ppageSize = searchVO.getPageSize();
		int cpagenum = searchVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}

		resultList.setTotalCount(frontRecommendDAO.groupCommonListCount(searchVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(resultList.getPagenum() * 24);

		resultList.setSearchName(searchVO.getSearchName());
		resultList.setSearchName2(searchVO.getSearchName2());
		resultList.setSearchGrade(searchVO.getSearchGrade());
		resultList.setSearchUseYn(searchVO.getSearchUseYn());
		resultList.setSearchUisCode(searchVO.getSearchUisCode());
		resultList.setSearchStartDate(searchVO.getSearchStartDate());
		resultList.setSearchEndDate(searchVO.getSearchEndDate());
		resultList.setSortField1(searchVO.getSortField1());
		resultList.setSearchKey(searchVO.getSearchKey());
		resultList.setSearchUcpCode(searchVO.getSearchUcpCode());
		resultList.setSearch_uis_copy_book_flag(searchVO.getSearch_uis_copy_book_flag());
		resultList.setSearch_uis_return_flag(searchVO.getSearch_uis_return_flag());

		List<FrontRecommendGroupVO> groupList = frontRecommendDAO.groupCommonList(resultList);

		if (resultList.getTotalCount() > 0) {
			for (int i = 0; i < groupList.size(); i++) {
				FrontRecommendGroupVO temp = groupList.get(i);
				temp.setSearch_uis_copy_book_flag(searchVO.getSearch_uis_copy_book_flag());
				temp.setSearch_uis_return_flag(searchVO.getSearch_uis_return_flag());
				temp.setSearchUisCode(searchVO.getSearchUisCode());
				groupList.get(i).setBookList(frontRecommendDAO.bookList(temp));
			}
			resultList.setGroupList(groupList);
		}

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO bookDetail(FrontCmVO frontCmVO) {
		FrontCmVO resultVO = frontRecommendDAO.selectBookDetail(frontCmVO);

		if (resultVO != null) {
			frontCmVO.setUcm_uct_code(resultVO.getUcm_uct_code());
			frontCmVO.setUcm_code(resultVO.getUcm_code());
			List<FrontCmVO> popularList = frontRecommendDAO.bookPopularList(frontCmVO);
			if (popularList != null && !popularList.isEmpty()) {
				resultVO.setPopular(popularList);
			}
		}

		return resultVO;
	}

	@Override
	public FrontCmVO bookDetailInfo(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectBookDetailInfo(frontCmVO);
	}

	@Override
	public int getSeqence(String seqName) {
		CommonVO commonVO = new CommonVO();
		commonVO.setSeq_name(seqName);
		return frontRecommendDAO.getSeqence(commonVO);
	}

	@Override
	public FrontCmVO newBookList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}

		resultList.setTotalCount(frontRecommendDAO.newBookListCount(frontCmVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(resultList.getPagenum() * 24);

		resultList.setSearchName(frontCmVO.getSearchName());
		resultList.setSearchName2(frontCmVO.getSearchName2());
		resultList.setSearchGrade(frontCmVO.getSearchGrade());
		resultList.setSearchUseYn(frontCmVO.getSearchUseYn());
		resultList.setSearchUisCode(frontCmVO.getSearchUisCode());
		resultList.setSearchStartDate(frontCmVO.getSearchStartDate());
		resultList.setSearchEndDate(frontCmVO.getSearchEndDate());
		resultList.setSortField1(frontCmVO.getSortField1());
		resultList.setSearchKey(frontCmVO.getSearchKey());

		resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUct_code(frontCmVO.getUct_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_parent(frontCmVO.getUct_parent());
		resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		resultList.setUis_return_flag(frontCmVO.getUis_return_flag());
		resultList.setResultList(frontRecommendDAO.newBookList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO recommendList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}

		resultList.setTotalCount(frontRecommendDAO.searchRecommendCount(frontCmVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(resultList.getPagenum() * 24);

		resultList.setSearchName(frontCmVO.getSearchName());
		resultList.setSearchName2(frontCmVO.getSearchName2());
		resultList.setSearchGrade(frontCmVO.getSearchGrade());
		resultList.setSearchUseYn(frontCmVO.getSearchUseYn());
		resultList.setSearchUisCode(frontCmVO.getSearchUisCode());
		resultList.setSearchStartDate(frontCmVO.getSearchStartDate());
		resultList.setSearchEndDate(frontCmVO.getSearchEndDate());
		resultList.setSortField1(frontCmVO.getSortField1());
		resultList.setSearchKey(frontCmVO.getSearchKey());

		resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUil_code(frontCmVO.getUil_code());
		resultList.setUct_code(frontCmVO.getUct_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_parent(frontCmVO.getUct_parent());
		resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		resultList.setUis_return_flag(frontCmVO.getUis_return_flag());
		resultList.setResultList(frontRecommendDAO.searchRecommend(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public String selectRecommendGroupName(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectRecommendGroupName(frontCmVO);
	}

	@Override
	public FrontCmVO popularList(FrontCmVO frontCmVO) {
		frontCmVO.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		frontCmVO.setUis_return_flag(frontCmVO.getUis_return_flag());
		frontCmVO.setResultList(frontRecommendDAO.popularList(frontCmVO));

		return frontCmVO;
	}

	@Override
	public FrontCmVO bestPopularList(FrontCmVO frontCmVO) {
		frontCmVO.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		frontCmVO.setUis_return_flag(frontCmVO.getUis_return_flag());
		frontCmVO.setResultList(frontRecommendDAO.bestPopularList(frontCmVO));

		return frontCmVO;
	}

	@Override
	public List<FrontCmVO> searchPopularList(FrontCmVO frontCmVO) {
		return frontRecommendDAO.searchPopularList(frontCmVO);
	}

	@Override
	public FrontCmVO categoryList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if ("mobile".equals(frontCmVO.getDeviceType())) {
			ppageSize = 12;
			int totalCount = frontRecommendDAO.categoryListCount(frontCmVO);
			resultList.setMobileYn("Y");
			resultList.setTotalCount(totalCount);

			resultList.setPagenum(cpagenum - 1);
			resultList.setPageSize(ppageSize);
			resultList.setCurrentblock(cpagenum);
			resultList.setLastblock(resultList.getTotalCount());

			resultList.prevnext(cpagenum);
			resultList.setStartPage(resultList.getCurrentblock());
			resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

			resultList.setPagenum(resultList.getPagenum() * 12);

			resultList.setSearchName(frontCmVO.getSearchName());
			resultList.setSearchName2(frontCmVO.getSearchName2());
			resultList.setSearchGrade(frontCmVO.getSearchGrade());
			resultList.setSearchUseYn(frontCmVO.getSearchUseYn());
			resultList.setSearchUisCode(frontCmVO.getSearchUisCode());
			resultList.setSearchStartDate(frontCmVO.getSearchStartDate());
			resultList.setSearchEndDate(frontCmVO.getSearchEndDate());
			resultList.setSearchKey(frontCmVO.getSearchKey());
			resultList.setSortField1(frontCmVO.getSortField1());
			resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
			resultList.setUct_code(frontCmVO.getUct_code());
			resultList.setUct_type(frontCmVO.getUct_type());
			resultList.setUct_parent(frontCmVO.getUct_parent());
			resultList.setUis_code(frontCmVO.getUis_code());
			resultList.setUm_code(frontCmVO.getUm_code());
			resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
			resultList.setUis_return_flag(frontCmVO.getUis_return_flag());

			resultList.setSortField1(frontCmVO.getSortField1());
			resultList.setResultList(frontRecommendDAO.categoryList(resultList));

			resultList.setPagenum(cpagenum);

		} else {
			ppageSize = 24;

			resultList.setTotalCount(frontRecommendDAO.categoryListCount(frontCmVO));

			resultList.setPagenum(cpagenum - 1);
			resultList.setPageSize(ppageSize);
			resultList.setCurrentblock(cpagenum);
			resultList.setLastblock(resultList.getTotalCount());

			resultList.prevnext(cpagenum);
			resultList.setStartPage(resultList.getCurrentblock());
			resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

			resultList.setPagenum(resultList.getPagenum() * 24);

			resultList.setSearchName(frontCmVO.getSearchName());
			resultList.setSearchName2(frontCmVO.getSearchName2());
			resultList.setSearchGrade(frontCmVO.getSearchGrade());
			resultList.setSearchUseYn(frontCmVO.getSearchUseYn());
			resultList.setSearchUisCode(frontCmVO.getSearchUisCode());
			resultList.setSearchStartDate(frontCmVO.getSearchStartDate());
			resultList.setSearchEndDate(frontCmVO.getSearchEndDate());
			resultList.setSortField1(frontCmVO.getSortField1());
			resultList.setSearchKey(frontCmVO.getSearchKey());

			resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
			resultList.setUct_code(frontCmVO.getUct_code());
			resultList.setUct_type(frontCmVO.getUct_type());
			resultList.setUct_parent(frontCmVO.getUct_parent());
			resultList.setUis_code(frontCmVO.getUis_code());
			resultList.setUm_code(frontCmVO.getUm_code());
			resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
			resultList.setUis_return_flag(frontCmVO.getUis_return_flag());

			resultList.setResultList(frontRecommendDAO.categoryList(resultList));

			resultList.setPagenum(cpagenum);
		}
		return resultList;
	}

	@Override
	public FrontCmVO bookSearchList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setSortFieldLibrary(frontCmVO.getSortFieldLibrary()); // db order by

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}

		// 페이지 offset 계산 (WWW 동일 - Solr URL에 전달)
		resultList.setPagenum(cpagenum - 1);
		resultList.setPagenum(resultList.getPagenum() * 24);

		// 검색어 전처리 (WWW 동일)
		String searchName = frontCmVO.getSearchName();
		if (searchName != null && (searchName.startsWith(" ") || searchName.endsWith(" "))) {
			searchName = searchName.trim().toUpperCase();
		}
		if (searchName != null && searchName.length() > 31) {
			searchName = searchName.substring(0, 31);
		}
		frontCmVO.setSearchName(searchName);

		try {
			String buildSolrUrl = SolrUtil.buildSolrURL_v2(
					frontCmVO.getSearchName(), frontCmVO.getUis_code(),
					frontCmVO.getUis_copy_book_flag(), frontCmVO.getUis_ucp_code(),
					frontCmVO.getUis_return_flag(), frontCmVO.getUct_code(),
					frontCmVO.getUct_type(), frontCmVO.getSortField(),
					ppageSize, resultList.getPagenum(), true, false,
					frontCmVO.getSortFieldLibrary());

			HttpHeaders headers = SolrUtil.solrAuthHeaders();
			RestTemplate restTemplate = SolrRestTemplateUtil.defaultTemplate();
			HttpEntity<String> entity = new HttpEntity<>(headers);
			ResponseEntity<String> response = restTemplate.exchange(
					buildSolrUrl, HttpMethod.GET, entity, String.class);

			if (response.getStatusCode() == HttpStatus.OK) {
				SolrSearchResult solrResult = SolrUtil.parseSolrResponse(response.getBody());
				long numFound = solrResult.getNumFound();
				if (numFound == 0) {
					resultList.setTotalCount(0);
					resultList.setResultList(Collections.emptyList());
				} else {
					resultList.setTotalCount((int) numFound);
					resultList.setSolrData(solrResult.getIdList());
					resultList.setResultList(frontRecommendDAO.bookSolrSearchList(resultList));
				}
			} else {
				// DB fallback
				resultList.setPageSize(ppageSize);
				extractFields(frontCmVO, resultList);
				resultList.setTotalCount(frontRecommendDAO.bookSearchListCount(frontCmVO));
				resultList.setResultList(frontRecommendDAO.bookSearchList(resultList));
			}
		} catch (Exception e) {
			// DB fallback
			resultList.setPageSize(ppageSize);
			extractFields(frontCmVO, resultList);
			resultList.setTotalCount(frontRecommendDAO.bookSearchListCount(frontCmVO));
			resultList.setResultList(frontRecommendDAO.bookSearchList(resultList));
		}

		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());
		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public List<FrontEventVO> bookDetailEvent(FrontCmVO frontCmVO) {
		return frontRecommendDAO.bookEventList(frontCmVO);
	}

	@Override
	public FrontRecommendVO bookDetailCuration(FrontCmVO frontCmVO) {
		FrontRecommendVO resultList = new FrontRecommendVO();
		List<FrontRecommendGroupVO> groupList = frontRecommendDAO.bookDetailCuration(frontCmVO);
		
		// 각 큐레이션 그룹별 도서 목록 조회
		for (int i = 0; i < groupList.size(); i++) {
			FrontRecommendGroupVO temp = groupList.get(i);
			temp.setSearch_uis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
			temp.setSearchUisCode(frontCmVO.getUis_code());
			groupList.get(i).setBookList(frontRecommendDAO.bookList(temp));
		}
		
		resultList.setGroupList(groupList);
		return resultList;
	}

	@Override
	public List<FrontCmVO> selectCategoryList(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectCategoryList(frontCmVO);
	}

	@Override
	public FrontCmVO noticeList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		resultList.setTotalCount(frontRecommendDAO.noticeListCount(frontCmVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		resultList.setPagenum(resultList.getPagenum() * ppageSize);
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setResultList(frontRecommendDAO.noticeList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO tosInfo(FrontCmVO frontCmVO) {
		return frontRecommendDAO.tosInfo(frontCmVO);
	}

	@Override
	public FrontCmVO policyInfo(FrontCmVO frontCmVO) {
		return frontRecommendDAO.policyInfo(frontCmVO);
	}

	@Override
	public List<FrontCmVO> selectCategoryListV2(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectCategoryListV2(frontCmVO);
	}

	@Override
	public List<String> selectAvailableCategoryTypes(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectAvailableCategoryTypes(frontCmVO);
	}

	@Override
	public List<FrontCmVO> selectSearchCategoryList(FrontCmVO frontCmVO) {
		return frontRecommendDAO.selectSearchCategoryList(frontCmVO);
	}

	@Override
	public FrontCmVO solrCategorySearch(FrontCmVO frontCmVO) {
		FrontCmVO result = new FrontCmVO();
		try {
			// Solr URL 생성 (faceting 활성화, 페이징 비활성화)
			String solrUrl = SolrUtil.buildSolrURL_v2(
					frontCmVO.getSearchName(), frontCmVO.getUis_code(),
					frontCmVO.getUis_copy_book_flag(), frontCmVO.getUis_ucp_code(),
					frontCmVO.getUis_return_flag(), null, null,
					frontCmVO.getSortField(),
					0, 0, false, true, null);

			Map<String, Integer> facetMap = SolrUtil.getSolrCategoryFacetMap(solrUrl);

			if (!facetMap.isEmpty()) {
				List<String> codeList = new ArrayList<>(facetMap.keySet());
				List<FrontCmVO> categoryList = frontRecommendDAO.solrCategorySearchList(codeList);

				// Solr facet 건수를 content_count에 매핑 (WWW 동일)
				for (FrontCmVO cat : categoryList) {
					String code8 = cat.getUct_code() != null && cat.getUct_code().length() >= 8
							? cat.getUct_code().substring(0, 8) : cat.getUct_code();
					cat.setContent_count(facetMap.getOrDefault(code8, 0));
				}
				result.setResultList(categoryList);

				// 카테고리 타입 판정 (TYPEALL/TYPEA/TYPEE/NONE)
				FrontCmVO typeVO = frontRecommendDAO.solrCategorySearchType(codeList);
				result.setType_result(typeVO != null ? typeVO.getType_result() : "NONE");
			} else {
				result.setResultList(Collections.emptyList());
				result.setType_result("NONE");
			}
		} catch (Exception e) {
			// DB fallback (Solr 실패 시 기존 DB 조회 방식으로 폴백)
			List<FrontCmVO> categoryList = frontRecommendDAO.selectSearchCategoryList(frontCmVO);
			result.setResultList(categoryList != null ? categoryList : Collections.emptyList());

			List<String> availableTypes = frontRecommendDAO.selectAvailableCategoryTypes(frontCmVO);
			boolean hasEbook = availableTypes != null && availableTypes.contains("E");
			boolean hasAudio = availableTypes != null && availableTypes.contains("A");
			if (hasEbook && hasAudio) result.setType_result("TYPEALL");
			else if (hasEbook) result.setType_result("TYPEE");
			else if (hasAudio) result.setType_result("TYPEA");
			else result.setType_result("TYPEALL");
		}
		return result;
	}

	private static void extractFields(FrontCmVO frontCmVO, FrontCmVO resultList) {
		resultList.setSearchName(frontCmVO.getSearchName());
		resultList.setSearchName2(frontCmVO.getSearchName2());
		resultList.setSearchGrade(frontCmVO.getSearchGrade());
		resultList.setSearchUseYn(frontCmVO.getSearchUseYn());
		resultList.setSearchUisCode(frontCmVO.getSearchUisCode());
		resultList.setSearchStartDate(frontCmVO.getSearchStartDate());
		resultList.setSearchEndDate(frontCmVO.getSearchEndDate());
		resultList.setSortField1(frontCmVO.getSortField1());
		resultList.setSearchKey(frontCmVO.getSearchKey());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUct_code(frontCmVO.getUct_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
		resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		resultList.setUis_return_flag(frontCmVO.getUis_return_flag());
		resultList.setStatus(frontCmVO.getStatus());
		resultList.setSortField(frontCmVO.getSortField());
	}

}
