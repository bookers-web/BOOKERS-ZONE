package life.bks.zone.vo;

import org.apache.commons.lang3.StringUtils;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SearchVO extends PagingVO {
	
	private String searchName = "";
	private String searchGrade = "";
	private String searchUseYn = "";
	private String searchStartDate = "";
	private String searchEndDate = "";
	private String searchStartDate2 = "";
	private String searchEndDate2 = "";
	private String searchKey = "";
	private String searchValue = "";
	private String sortField1 = "";
	private String sortField2 = "";
	private String sortField = "";
	private String searchName2 = "";
	private String searchName3 = "";
	private String searchName4 = "";
	private String[] exceptWords;
	private String status = "";
	private String filesort = "";
	private String searchYear = "";
	private String searchMonth = "";
	private String searchDate = "";
	private String now_date	 = "";
	private String next_date = "";
	private String now_month = "";
	private String next_month = "";
	private String searchDateSort = "";
	private String uis_code = "";
	private String upm_type = "";
	private String searchAladin = "";
	private String searchAladinOp = "";
	private String search_uis_common_book_flag	= "Y";
	private String search_uis_copy_book_flag	= "N";
	private String search_uis_return_flag = "N";
	private String searchMemberGroup = "";
	private String searchMemberRank	= "";
	private String searchMemberGroup2 = "";
	private String searchMobileYn = "";
	private String uct_type	= "";
	private String searchYn	= "";
	private String searchYn2 = "";
	private String uis_company_flag	= "B";
	private String itsflag	= "";
	/**
	 * 특정 CP의 도서만 검색 하기 위해서 추가함 
	 */
	private String searchUcpCode = "";
	/**
	 * 특정 기관의 회원, 메일, 푸쉬, 추천도서, 독서감상문, 우수자, 통계, 정산, 공지사항을 검색하기 위함.
	 */
	private String searchUisCode = "";
	/**
	 * 검색 대상에서 제외할 아이디
	 */
	private String searchExceptUserId = "";
	/**
	 * 콘텐츠에서 카테고리 검색을 위해 
	 */
	private String searchCategoryCode = "";
	/**
	 * 각 비밀번호 변경을 위해 
	 */
	private String changeToken = "";
	/**
	 * 화면 모드 설정
	 */
	private String viewMode = "";
	private String _SearchName;
	private String _SearchName2;
	private String _SearchStartDate;
	private String _SearchEndDate;
	private String _SearchKey;

	private List<String> solrData;

	public void makeSearchName() {
		_SearchName = this.searchName;

		if(StringUtils.isNotEmpty(_SearchName)) {
			searchName = _SearchName.replace(" ","");
		}
	}

	public void makeSearchName2() {
		_SearchName2 = this.searchName2;

		if(StringUtils.isNotEmpty(_SearchName2)) {
			searchName2 = _SearchName2.replace(" ","");
		}
	}

	public void makeSearchDate() {
		_SearchStartDate = this.searchStartDate;
		_SearchEndDate = this.searchEndDate;
		
		if(StringUtils.isNotEmpty(_SearchStartDate)) {
			searchStartDate = _SearchStartDate +" 00:00:00";
		}
		
		if(StringUtils.isNotEmpty(_SearchEndDate)) {
			searchEndDate = _SearchEndDate +" 23:59:59";
		}
	}
	
	public void resetSearchDate() {
		this.searchStartDate =_SearchStartDate;
		this.searchEndDate =_SearchEndDate;
	}
	
	public void makeSearchKey() {
		_SearchKey = this.searchKey;

		if(StringUtils.isNotEmpty(_SearchKey)) {
			searchKey = _SearchKey.replace(" ","");
		}
	}
}
