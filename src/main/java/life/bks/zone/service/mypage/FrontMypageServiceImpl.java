package life.bks.zone.service.mypage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import life.bks.zone.dao.mypage.FrontMypageDAO;
import life.bks.zone.vo.FrontCmVO;

@Service
public class FrontMypageServiceImpl implements FrontMypageService {

	@Autowired
	private FrontMypageDAO frontMypageDAO;

	@Override
	public FrontCmVO mainFaqList(FrontCmVO frontCmVO) {
		frontCmVO.setResultList(frontMypageDAO.mainFaqList(frontCmVO));
		return frontCmVO;
	}

	@Override
	public FrontCmVO faqList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		resultList.setTotalCount(frontMypageDAO.faqListCount(frontCmVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		if (ppageSize == 10) {
			resultList.setPagenum(resultList.getPagenum() * 10);
		} else if (ppageSize == 50) {
			resultList.setPagenum(resultList.getPagenum() * 50);
		} else if (ppageSize == 100) {
			resultList.setPagenum(resultList.getPagenum() * 100);
		}

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

		resultList.setResultList(frontMypageDAO.faqList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public FrontCmVO myExcellentSelect(FrontCmVO frontCmVO) {
		return frontMypageDAO.myExcellentSelect(frontCmVO);
	}

	@Override
	public FrontCmVO myInfoSelect(FrontCmVO frontCmVO) {
		return frontMypageDAO.myInfoSelect(frontCmVO);
	}

	@Override
	public FrontCmVO myInfoNoSelect(FrontCmVO frontCmVO) {
		return frontMypageDAO.myInfoNoSelect(frontCmVO);
	}

	@Override
	public boolean myInfoModifyProc(FrontCmVO frontCmVO) {
		int result = frontMypageDAO.myInfoModifyProc(frontCmVO);
		return result > 0;
	}

	@Override
	public FrontCmVO myDeviceList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		resultList.setTotalCount(frontMypageDAO.myDeviceListCount(frontCmVO));
		resultList.setResultList(frontMypageDAO.myDeviceList(frontCmVO));

		return resultList;
	}

	@Override
	public int myDeviceModify(FrontCmVO frontCmVO) {
		return frontMypageDAO.myDeviceModify(frontCmVO);
	}

	@Override
	public boolean deleteDevice(FrontCmVO frontCmVO) {
		int result = frontMypageDAO.deleteDevice(frontCmVO);
		return result > 0;
	}

	@Override
	public FrontCmVO myExcellentList(FrontCmVO frontCmVO) {
		FrontCmVO resultList = new FrontCmVO();

		int ppageSize = frontCmVO.getPageSize();
		int cpagenum = frontCmVO.getPagenum();

		resultList.setTotalCount(frontMypageDAO.myExcellentListCount(frontCmVO));

		resultList.setPagenum(cpagenum - 1);
		resultList.setPageSize(ppageSize);
		resultList.setCurrentblock(cpagenum);
		resultList.setLastblock(resultList.getTotalCount());

		resultList.prevnext(cpagenum);
		resultList.setStartPage(resultList.getCurrentblock());
		resultList.setEndPage(resultList.getLastblock(), resultList.getCurrentblock());

		if (ppageSize == 10) {
			resultList.setPagenum(resultList.getPagenum() * 10);
		} else if (ppageSize == 50) {
			resultList.setPagenum(resultList.getPagenum() * 50);
		} else if (ppageSize == 100) {
			resultList.setPagenum(resultList.getPagenum() * 100);
		}

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

		resultList.setResultList(frontMypageDAO.myExcellentList(resultList));

		resultList.setPagenum(cpagenum);

		return resultList;
	}

	@Override
	public int myExcellentPrintState(FrontCmVO frontCmVO) {
		return frontMypageDAO.myExcellentPrintState(frontCmVO);
	}

}
