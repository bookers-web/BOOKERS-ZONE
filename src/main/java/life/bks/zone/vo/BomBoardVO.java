package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 공지사항 정보
 * @author namseokpark
 *
 */
@Getter
@Setter
public class BomBoardVO extends SearchVO {

    private int un_no = 0; //일련번호
    private String un_title = ""; //일련번호
    private String un_uis_code = ""; //기관코드
    private String un_content = ""; //내용
    private String un_am_userid = ""; //등록 CMS 또는 기관 관리자 아이디 기관 코드가 없으면 시스템 관리자로 표기
    private String un_regdate = ""; //등록일
    private String un_uis_name = ""; //view 매핑용 - 기관
    private String un_am_username = ""; //관리자 등록 계정 값이 없으면 기관 관리자 계정임
	private String un_notice_type = "";
	private String un_image_url;
	private String un_useyn = "";
    private String un_display_startdate;
    private String un_display_enddate;
    private String un_expiry_date;
    private String un_message;
    private String un_event_option;
    private String un_event_url;
    private String uhp_code = ""; //희망도서 메인코드 파라미터 사용
    private String h_uhp_code = ""; //희망도서 메인코드
    private String h_uis_name = ""; //희망도서 신청 기관이름
    private String h_uis_code = ""; //희망도서 신청 기관코드
    private String h_um_userid = ""; //희망도서 신청자 아이디
    private String h_title = ""; //희망도서 신청 책 제목
    private String h_author = ""; //희망도서 신청 책 저자명
    private String h_publisher = ""; //희망도서 신청 책 출판사명
    private String h_publishdate = ""; //희망도서 신청 책 출판사명
    private String h_content = ""; //희망도서 신청 책 출판사명
    private String h_cover_url = ""; //희망도서 신청 책 표지 URL
    private String h_regdate = ""; //희망도서 신청 등록일
    private String h_state_flag = ""; //희망도서 상태
    private String h_state_message = ""; //희망도서 상태 메세지
    private String h_ebook_isbn = ""; //희망도서 전자책isbn
    private String h_new_ebook_isbn = ""; //희망도서 전자책isbn
    private String h_paper_isbn = ""; //희망도서 전자책isbn
    private String h_ucm_code = ""; //바로읽기 ucm코드
    private String h_isbn_type = "";
    private String h_uis_useyn = "";
    private int h_book_count = 0; //희망도서 전자책isbn
    private int h_like = 0; //추천 카운
    private String h_uis_complete_flag = ""; //희망도서 신청한 기관의 상태값
    private String uan_no = ""; //일련번호
    private String uan_title = ""; //제목
    private String uan_uis_code = ""; //기관코드
    private String uan_content = ""; //내용
    private String uan_am_userid = ""; //등록 CMS 또는 기관 관리자 아이디 기관 코드가 없으면 시스템 관리자로 표기
    private String uan_more_url = "";
    private String uan_regdate = ""; //등록일
    private String uan_uis_name = ""; //view 매핑용 - 기관
    private String uan_am_username = ""; //관리자 등록 계정 값이 없으면 기관 관리자 계정임
    private String excelYn = "N";
    private String uan_display_startdate = "";	// APP 공지 시작일
    private String uan_display_enddate = "";	// APP 공지 종료일
    private String uct_code = "";	// 카테고리 코드
    private String uct_type = "";	// 카테고리 그룹 ( E: 전자책, A: 오디오북, C: CP)
    private String uct_name = "";
    private String uct_parent_name = "";
    private String uct_parent = "";
    private String uaeb_no = ""; //일련번호
    private String uaeb_title = ""; //제목
    private String uaeb_uis_code = ""; //기관코드
    private String uaeb_content = ""; //내용
    private String uaeb_am_userid = ""; //등록 CMS 또는 기관 관리자 아이디 기관 코드가 없으면 시스템 관리자로 표기
	private String uaeb_regdate = ""; //등록일
    private String uaeb_uis_name = ""; //view 매핑용 - 기관
    private String uaeb_am_username = ""; //관리자 등록 계정 값이 없으면 기관 관리자 계정임
    private String uaeb_display_startdate = "";	// APP 공지 시작일
    private String uaeb_display_enddate = "";
    private String[] uaebl_ucm_codes; // 추천 도서 코드 모음
	private String uaebl_uaeb_no = ""; //신간 안내 도서 일련번호
    private String uaebl_ucm_code = "";
    private String uaeb_useyn = "Y";
    private String uan_useyn = "Y";
    private String un_codes[] = {};
    private String un_svryn = "Y";	// 서비스 상태( 판매중: Y, 판매 정지 : N)

}
