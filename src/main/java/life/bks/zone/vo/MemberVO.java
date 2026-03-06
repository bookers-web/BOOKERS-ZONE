package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberVO extends SearchVO {
	
	// 회원
	private String um_code						= "";	// 회원코드 
	private String um_userid					= "";	// 회원 아이디
	private String um_pwd						= "";	// 회원 비밀번호
	private String um_uis_code					= "";	// 기관 코드
	private String um_reg_type					= "";	// 등록 형태 ( 시스템 관리자 : S, CP사 등록 : C )
	private String um_name						= "";	// 회원 성명
	private String um_tel						= "";	// 연락처
	private String um_email						= "";	// 이메일주소
	private Integer um_max_device_count			= 0;	// 최대 사용 등록 기기 수
	private Integer um_max_library_in_book		= 0;	// 다운로드 가능 최대 도서 수
	private String um_free_account				= "";	// 무료 계정 여부(Y,N)
	private String um_reg_userid				= "";	// 등록한 관리자 아이디
	private String um_useyn						= "";	// 사용여부(Y,N)
	private String um_regdate					= "";	// 등록일
	private String uis_ucp_code					= "";	// 기관 cp사 코드
	private String uis_web_logo_url				= "";	// 웹 로고
	private String uis_mobile_logo_url			= "";	// 모바일 로고
	private String uis_keycolor					= "";	// 기업 색상
	private String uis_common_book_flag			= "Y";	// 공통추천 사용 여부
	private String uis_copy_book_flag			= "N";	// 카피수 제한 콘텐츠 사용 여부
	private String uis_preview_flag				= "N";	// 미리보기만 되는 체험 도서관용 여부
	private String uis_return_flag				= "N";	// 대출반납이 되는 도서관용 여부
	private String uis_return_ui_flag			= "N";	// 대출반납이 되는 도서관용 UI 사용 여부
	private String uis_pw_flag					= "N";	// 비밀번호 강제 변경 안내 기능 사용 여부
	
	// view 매핑용
	private Integer device_count				= 0;	// 현재 등록 기기 수
	private String uis_name						= "";	// 기관 명
	
	private String uis_auth_method				= "";	// SSO 방식 
	private String excelYn						= "N";	// 엑셀 다운 유무
	private String schedulerQuery;
	private String errorMsg;
	private int upjmCode; // 입과자 리스트 번호
	private String um_pw_change					= "";	// 비밀번호 변경 여부(Y,N)
}
