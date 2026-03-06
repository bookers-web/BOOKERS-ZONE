package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrmRecommendVO extends SearchVO {

	// 추천도서 관련
	private String uil_code				 = ""; // 기관  추천 서재 코드
	private String uil_uis_code			 = ""; // 기관 코드
	private String uil_name				 = ""; // 추천 서재명
	private String uil_display_startdate = ""; // 서재 추천 시작일
	private String uil_display_enddate	 = ""; // 서재 추천 종료일
	private String uil_uis_userid		 = ""; // 등록자(기관 마스터 아이디)
	private String uil_useyn			 = ""; // 사용여부(Y,N)
	private String uil_regdate			 = ""; // 등록일

	// 추천도서  - 서재의 도서
	private String uie_uil_code			 = ""; // 기관 추천 서재 코드
	private String uie_ucm_code			 = ""; // 도서 코드
	private String uie_uis_userid		 = ""; // 등록자(기관 마스터 아이디)
	private String uie_regdate			 = ""; // 등록일

	// view 매핑용
	private int uie_uis_count			 = 0;  // 추천 도서수
	private String uis_name				 = ""; // 기관명
	private String uis_useyn			 = ""; // 기관명

	private String[] uie_ucm_codes;	           // 추천 도서 코드 모음
	private String[] uil_codes;			       // 추천 도서 코드 모음
	private int uil_display_number	     = 0;  // 추천 도서 코드 모음

	// view 매핑용
	private String uis_manager			 = ""; // 추천 도서 코드 모음
	private String am_name				 = ""; // 추천 도서 코드 모음
	private String uct_code				 = ""; // 카테고리 코드
	private String uct_type				 = ""; // 카테고리 그룹 ( E: 전자책, A: 오디오북, C: CP)
	private String uct_name				 = "";
	private String uct_parent_name		 = "";
	private String uct_parent			 = "";
	private String uis_copy_book_flag	 = "";
	private String uis_return_flag		 = "";

	private String[] org_excludes; // 제외기관코드
	private String org_exclude; // 제외기관코드

	private String exclude_code;
	private String exclude_name;
	
	private String uil_svryn			= "Y";	// 서비스 상태( 판매중: Y, 판매 정지 : N)
	private String um_code				= "";

}
