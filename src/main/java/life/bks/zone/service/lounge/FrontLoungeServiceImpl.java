package life.bks.zone.service.lounge;

import life.bks.zone.dao.lounge.FrontLoungeDAO;
import life.bks.zone.vo.CommonVO;
import life.bks.zone.vo.FrontCmVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FrontLoungeServiceImpl implements FrontLoungeService {

	@Autowired
	private FrontLoungeDAO frontLoungeDAO;

	@Override
	public FrontCmVO allBookReportList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}
		frontCmVO.makeSearchKey();
		resultList.setTotalCount(frontLoungeDAO.allBookReportListCount(frontCmVO));

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
		resultList.setSearchUcpCode(frontCmVO.getSearchUcpCode());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_code(frontCmVO.getUct_code());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());

		resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		resultList.setUis_return_flag(frontCmVO.getUis_return_flag());
		resultList.setUbr_is_open_checking(frontCmVO.getUbr_is_open_checking());

		resultList.makeSearchKey();

		resultList.setResultList(frontLoungeDAO.allBookReportList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO allBookReportDetail(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 12;
		}

		resultList.setTotalCount(frontLoungeDAO.allBookReportDetailCount(frontCmVO));

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
		resultList.setSortField1(frontCmVO.getSortField1());
		resultList.setSearchKey(frontCmVO.getSearchKey());
		resultList.setSearchUcpCode(frontCmVO.getSearchUcpCode());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_code(frontCmVO.getUct_code());

		resultList.setUbr_code(frontCmVO.getUbr_code());
		resultList.setUcm_code(frontCmVO.getUcm_code());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUbr_flag(frontCmVO.getUbr_flag());

		resultList.setResultList(frontLoungeDAO.allBookReportDetail(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO allBookReportDetailView(FrontCmVO frontCmVO) {
		return frontLoungeDAO.allBookReportDetailView(frontCmVO);
	}

	@Override
	public int bookReportCommentStateService(FrontCmVO frontCmVO) {
		int resultCount = 0;

		if (StringUtils.isNotEmpty(frontCmVO.getUbrc_code())) {
			// 삭제
			resultCount = frontLoungeDAO.deleteBookReportComment(frontCmVO);
			frontCmVO.setUbrc_type("N");
		} else {
			// 등록
			CommonVO commonVO = new CommonVO();
			commonVO.setSeq_name("BOOK_REPORT_COMMENT_SEQ");

			frontCmVO.setUbrc_code(Integer.toString(frontLoungeDAO.getSeqence(commonVO)));

			resultCount = frontLoungeDAO.insertBookReportComment(frontCmVO);
			frontCmVO.setUbrc_type("Y");
		}
		return resultCount;
	}

	@Override
	public FrontCmVO selectBookReportComment(FrontCmVO frontCmVO) {
		return frontLoungeDAO.selectBookReportComment(frontCmVO);
	}

	@Override
	public FrontCmVO allDiscussionList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 24;
		}
		frontCmVO.makeSearchKey();
		resultList.setTotalCount(frontLoungeDAO.allDiscussionListCount(frontCmVO));

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
		resultList.setSearchUcpCode(frontCmVO.getSearchUcpCode());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_code(frontCmVO.getUct_code());
		resultList.setUis_ucp_code(frontCmVO.getUis_ucp_code());
		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUis_copy_book_flag(frontCmVO.getUis_copy_book_flag());
		resultList.setUis_return_flag(frontCmVO.getUis_return_flag());
		frontCmVO.makeSearchKey();
		resultList.setResultList(frontLoungeDAO.allDiscussionList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO allDiscussionDetail(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		if (ppageSize == 10) {
			ppageSize = 12;
		}

		resultList.setTotalCount(frontLoungeDAO.allDiscussionDetailCount(frontCmVO));

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
		resultList.setSortField1(frontCmVO.getSortField1());
		resultList.setSearchKey(frontCmVO.getSearchKey());
		resultList.setSearchUcpCode(frontCmVO.getSearchUcpCode());
		resultList.setUm_code(frontCmVO.getUm_code());
		resultList.setUct_type(frontCmVO.getUct_type());
		resultList.setUct_code(frontCmVO.getUct_code());

		resultList.setUis_code(frontCmVO.getUis_code());
		resultList.setUcd_code(frontCmVO.getUcd_code());
		resultList.setUcm_code(frontCmVO.getUcm_code());
		resultList.setUcd_um_code(frontCmVO.getUcd_um_code());

		resultList.setResultList(frontLoungeDAO.allDiscussionDetail(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public boolean discussionWriteProc(FrontCmVO frontCmVO) {
		int result = 0;

		if (StringUtils.isNotEmpty(frontCmVO.getUcd_code())) {
			// 토론 수정
			result = frontLoungeDAO.updateDiscussion(frontCmVO);
		} else {
			// 토론 등록
			CommonVO commonVO = new CommonVO();
			commonVO.setSeq_name("CONTENT_DISCUSSION_SEQ");

			frontCmVO.setUcd_code(Integer.toString(frontLoungeDAO.getSeqence(commonVO)));
			result = frontLoungeDAO.insertDiscussion(frontCmVO);
		}

		return result > 0;
	}

	@Override
	public int modifyDiscussionService(FrontCmVO frontCmVO) {
		int result = 0;

		if (StringUtils.isNotEmpty(frontCmVO.getUcd_comment())) {
			// 토론 수정
			result = frontLoungeDAO.updateDiscussion(frontCmVO);
		} else {
			// 토론 삭제
			result = frontLoungeDAO.deleteDiscussion(frontCmVO);
		}

		return result;
	}

	@Override
	public int modifyDiscussionCommentService(FrontCmVO frontCmVO) {
		int result = 0;

		if (StringUtils.isNotEmpty(frontCmVO.getUcdc_code())) {
			// 토론 댓글 삭제
			result = frontLoungeDAO.deleteDiscussionComment(frontCmVO);
		} else {
			// 토론 댓글 등록
			CommonVO commonVO = new CommonVO();
			commonVO.setSeq_name("CONTENT_DISCUSSION_COMMENT_SEQ");

			frontCmVO.setUcdc_code(Integer.toString(frontLoungeDAO.getSeqence(commonVO)));
			result = frontLoungeDAO.insertDiscussionComment(frontCmVO);
		}

		return result;
	}

	@Override
	public FrontCmVO selectDiscussionComment(FrontCmVO frontCmVO) {
		return frontLoungeDAO.selectDiscussionComment(frontCmVO);
	}

	@Override
	public int insertReportCopyright(FrontCmVO frontCmVO) {
		int result = 0;

		CommonVO commonVO = new CommonVO();
		commonVO.setSeq_name("REPORT_COPYRIGHT_SEQ");

		frontCmVO.setUrc_no(frontLoungeDAO.getSeqence(commonVO));
		result = frontLoungeDAO.insertReportCopyright(frontCmVO);

		return result;
	}

	@Override
	public FrontCmVO selectProhibition(FrontCmVO frontCmVO) {
		return frontLoungeDAO.selectProhibition(frontCmVO);
	}
}
