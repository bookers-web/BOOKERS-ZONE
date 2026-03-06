package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class FrontCmVO extends SearchVO {

	// 컨텐츠 도서 정보
	private String ucm_code					= "";	// 컨텐츠 코드
	private String ucm_reg_type				= "";	// 등록 형태 ( 시스템 관리자 : S, CP사 등록 : C )
	private String ucm_svryn				= "Y";	// 서비스 상태( 판매중: Y, 판매 정지 : N)
	private String ucm_sales_type			= "0";	// 판매 형태(B2B : 0, B2B + B2BC : 1, B2B + B2BC + B2C : 2 )
	private Integer ucm_rent_period			= 28;	// 대여 일수
	private String ucm_sale_enddate			= "";	// 판매 정지 예정일
	private String ucm_paper_isbn			= "";	// 종이책 ISBN 13자리
	private String ucm_ebook_isbn			= "";	// eBook ISBN 13자리
	private String ucm_ucp_code				= "";	// CP사 코드
	private String ucm_title				= "";	// 도서명
	private String ucm_sub_title			= "";	// 부제
	private String ucm_writer				= "";	// 저자명
	private String ucm_region				= "";	// 출간지역(국내 : D, 외서 : F)
	private Integer ucm_paper_price			= 0;;	// 종이책 정가
	private Integer ucm_ebook_price			= 0; 	// eBook 정가
	private String ucm_paper_pubdate		= "";	// 종이책 출간일
	private String ucm_ebook_pubdate		= "";	// eBook 출간일
	private String ucm_limit_age			= "N";	// 나이제한(19세 이상 : R , 19세 미만 : N )
	private Integer ucm_paper_pages			= 0;	// 종이책 페이지수
	private Integer ucm_preview_ratio		= 0; 	// 미리보기 비율
	private String ucm_orientation			= "L";	// 콘텐츠 방향(L2R : L, R2L : R)
	private Integer ucm_filesize			= 0;	// 파일 용량
	private String ucm_total_playtime		= "";	// 총 재생 시간
	private Integer ucm_text_count			= 0; 	// 글자 수
	private String ucm_support_tts			= "N";	// TTS 지원 여부 (Y , N)
	private Integer ucm_supply_price		= 0;	// 공급가
	private Integer ucm_supply_ratio		= 0;	// 공급률
	private String ucm_contract_type		= "";	// 계약형태 (매절 계약: A, 일반 계약 : R)
	private String ucm_soldout_start_date	= "";	// 매절 계약 시작일
	private String ucm_soldout_end_date		= "";	// 매절 계약 종료일
	private Integer ucm_soldout_count		= 0;	// 매절 권 수
	private Integer ucm_max_rent_count		= 25;	// 1 카피당 대여 횟수
	private Integer ucm_sales_price			= 1000;	// 권당 차감 금액 ( 구독형)
	private String ucm_intro				= "";	// 도서 소개
	private String ucm_review				= "";	// 저자 소개
	private String ucm_publish_review		= "";	// 출판사 리뷰
	private String ucm_toc					= "";	// 목차
	private String ucm_cover_url			= "";	// 표지 이미지
	private String ucm_thumb_url			= "";	// 표지 이미지 저용량
	private String ucm_intro_img_url		= "";	// 도서 소개 이미지
	private String ucm_intro_movie_url		= "";	// 도서 소개 동영상
	private String ucm_uct_code				= "";	// 카테고리 코드
	private String ucm_in_uct_code			= "";	// CP사 카테고리 코드
	private String ucm_file_type			= "";	// 파일형태 (EPUB, PDF, ZIP, AUDIO)
	private Integer ucm_ucmf_version		= 0;	// 현재 파일 버전
	private String ucm_ucmf_updatedate		= "";	// 파일 업데이트 일자.
	private String ucm_drm_type				= "N";	// DRM 형태 (N: NONE, U : UnDRM )
	private String ucm_drm_product_code		= "";	// DRM 상품 코드
	private String ucm_ucs_code				= "";	// 시리즈 상품 코드
	private Integer ucm_series_no			= 0;	// 시리즈 연번
	private Integer ucm_download_count		= 0;	// 도서 다운로드 수
	private Integer ucm_read_count			= 0;	// 도서 열람 수
	private String ucm_inspect_am_userid	= "";	// 검수자
	private String ucm_inspect_yn			= "N";	// 검수 완료 여부(Y, N)
	private String ucm_status				= "C";	// 상태
	private String ucm_modify_date			= "";	// 수정일
	private String ucm_reg_userid			= "";	// 등록자
	private String ucm_regdate				= "";	// 등록일
	private String ucm_preview_flag			= "";	// 미리보기 여부(Y, N)
	private String ucm_webdrm_yn			= "";	// 웹뷰어 패킹 여부(Y, N)
	private String ucp_name					= "";
	private String ucp_cp_brand				= "";
	private String ucp_brand				= "";	// 출판사명 표시를 위해
	private String ucm_codes[]				= {};
	
	// 리딩노트 관련
	private String uba_code									= "";	// UBA000000000001
	private String uba_um_code								= "";	// 회원 코드
	private String uba_ucm_code								= "";	// 도서 코드
	private String uba_id									= "";	// 리딩노트 아이디
	private int uba_seq										= 0;	// 동기화를 위한 코드
	private int uba_type									= 0;	// 북마크 : 0, 하이라이트 : 1, 메모 : 2, 필기 : 3
	private int uba_ver										= 0;	// 리딩노트 버전
	private int uba_index									= 0;	// 파일 번호
	private int uba_chapterno								= 0;	// 목차 번호
	private String uba_chaptertitle							= "";	// 목차 명
	private String uba_startpos								= "";	// 시작 위치
	private String uba_endpos								= "";	// 마지막 위치
	private String uba_text									= "";	// 선택된 텍스트
	private String uba_memo									= "";	// 메모 내용
	private String uba_color								= "";	// #ffffff
	private String uba_freewrite_data						= "";	// 필기 내용
	private int uba_page									= 0;	// 페이지번호
	private int uba_percent									= 0;	// 전체 페이지 중의 백분률
	private String uba_regdate								= "";	// 등록일
	
	// 독서감상문 댓글
	private String ubrc_code								= "";	// 독서감상문 댓글 코드
	private String ubrc_ubr_code							= "";	// 독서 감상문 코드
	private String ubrc_um_code								= "";	// 회원 코드
	private String ubrc_type								= "";	// 좋아요 : Y, 싫어요 : N
	private String ubrc_content								= "";	// 한줄 평가
	private String ubrc_regdate								= "";	// 등록일
	
	// 독서토론
	private String ucd_code									= "";	// 독서 토론 코드
	private String ucd_ucm_code								= "";	// 도서 코드
	private String ucd_uis_code								= "";	// 기관 코드
	private String ucd_um_code								= "";	// 회원 코드
	private String ucd_um_userid							= "";	// 회원 아이디
	private String ucd_comment								= "";	// 코멘트
	private String ucd_regdate								= "";	// 등록일
	
	// 독서 토론 댓글
	private String ucdc_code								= "";	// 독서 토론 댓글 코드
	private String ucdc_ucd_code							= "";	// 독서 토론 코드
	private String ucdc_um_code								= "";	// 회원 코드
	private String ucdc_type								= "";	// 좋아요 : Y, 싫어요 : N
	private String ucdc_content								= "";	// 한줄 평가
	private String ucdc_regdate								= "";	// 등록일
	
	// 저작권 신고
	private int urc_no										= 0;	// 일련번호
	private String urc_um_code								= "";	// 회원코드
	private String urc_ucm_code								= "";	// 도서코드
	private String urc_ucd_code								= "";	// 독서토론코드
	private String urc_title								= "";	// 제목
	private String urc_content								= "";	// 내용
	private String urc_am_userid							= "";	// 확인한 관리자 아이디
	private String urc_regdate								= "";	// 등록일
	
	// 금칙어
	private int upw_no										= 0;	// 일련번호
	private String upw_list									= "";	// 금칙어 리스트
	private String upw_am_userid							= "";	// 관리자 아이디
	private String upw_regdate								= "";	// 등록일
	
	// faq
	private int ufq_no										= 0;	// faq 번호
	private String ufq_question								= "";	// 질문
	private String ufq_answer								= "";	// 답변
	private String ufq_am_userid							= "";	// 관리자 아이디
	private String ufq_regdate								= "";	// 등록일
	
	// 독서 우수자
	private String uib_code									= "";	// 기관 독서 우수자 관리 코드
	private String uib_uis_code								= "";	// 기관 코드
	private String uib_year									= "";	// 대상 년
	private String uib_month								= "";	// 대상 월
	private String uib_startdate							= "";	//
	private String uib_enddate								= "";	//
	private String uib_uis_userid							= "";	// 등록자(기관 마스터 아이디)
	private String uib_regdate								= "";	// 등록일
	private String uim_code									= "";	// 기관 독서 우수자 코드
	private String uim_uib_code								= "";	// 기관 독서 우수자 관리 코드
	private String uim_uis_code								= "";	// 기관 코드
	private String uim_um_code								= "";	// 회원 코드
	private String uim_readed								= "";	// 완독 도서 수
	private String uim_readed_rmd							= "";	// 추천 도서 내 완독 독서 수
	private String uim_read									= "";	// 읽은 도서 수
	private String uim_read_rmd								= "";	// 추천 도서 내 읽은 도서 수
	private String uim_report								= "";	// 감상문 수
	private String uim_report_rmd							= "";	// 추천 도서 내 감상문 수
	private String uim_point								= "";	// 독서 지수
	private String uim_issued_yn							= "";	// 인증서 발급 유무 (Y/N)
	private String uim_regdate								= "";	// 등록일
	private String uim_cancel_yn							= "";	// 취소여부
	
	// 회원 디바이스 관련
	private String umd_code						= "";	// 디바이스 코드
	private String umd_um_code					= "";	// 회원 코드
	private String umd_uid						= "";	// 디바이스 아이디
	private String umd_name						= "";	// 디바이스 명칭
	private String umd_os						= "";	// OS
	private String umd_regdate					= "";	// 등록일
	
	// 공지사항
	private int un_no							= 0;	// 일련번호
	private String un_title						= "";	// 제목
	private String un_uis_code					= "";	// 기관코드
	private String un_content					= "";	// 내용
	private String un_am_userid					= "";	// 관리자 아이디
	private String un_regdate					= "";	// 등록일

	// 개인정보 처리방침, 이용약관
	private String uts_content					= "";	// 개인정보 처리방침 내용
	private String upp_content					= "";	// 이용약관 내용

	// view 매핑용
	private String ucm_old_cover_url		= "";
	private String ucm_old_intro_img_url	= "";
	private String ucm_old_intro_movie_url	= "";
	private String uct_parent				= "";
	private String um_code					= "";	// 회원 코드
	private String uct_parent_name			= "";	// 카테고리 상위명
	private String uct_name					= "";	// 카테고리 명
	private int ume_finishread_count		= 0;	// 완독 횟수
	private int ume_last_read_percent		= 0;	// 읽은 퍼센트
	private String ume_input_date			= "";	// 목록에 담은 일자
	private String ume_code					= "";	// 회원 서재 도서 코드
	private String uis_code					= "";	// 기관 코드
	private String uiscode					= "";	// 기관 코드
	private String uis_ucp_code				= "";	// 기관 CP사 코드
	private int ucm_series_count			= 0;	// 시리즈 수(실제 등록된 도서 기준)
	private String ubr_code					= "";	// 독서 감상문 코드
	private String ubr_um_code				= "";	// 회원 코드
	private String ubr_ucm_code				= "";	// 도서 코드
	private String ubr_ume_code				= "";	// 회원 도서 코드
	private String ubr_title				= "";	// 독서 감상문 제목
	private String ubr_content				= "";	// 독서 감상문 내용
	private String ubr_content_preview		= "";	// 독서 감상문 내용 미리보기 태그 생략된 텍스트만 존재
	private String ubr_is_open				= "";	// 공개여부 ( Y, N)
	private int ubr_like					= 0;	// 좋아요 수치
	private int ubr_dislike					= 0;	// 싫어요 수치
	private String ubr_regdate				= "";	// 등록일
	private String ubr_flag					= "";	// 내 리포트인지 확인
	private int bm_count					= 0;	// 북마크 수
	private int hl_count					= 0;	// 하이라이트 수
	private int mm_count					= 0;	// 메모 수
	private int pm_count					= 0;	// 필기 수
	private String um_userid				= "";	// 회원 아이디
	private String um_pwd					= "";	// 회원 비밀번호
	private String um_name					= "";	// 회원 이름
	private int like_count					= 0;	// 독서토론 좋아요 수
	private int book_report_count			= 0;	// 도서별 감상문 수
	private int totalReadCount				= 0;	// 오늘까지 읽은 책
	private String totalReadingTime			= "";	// 오늘까지 독서 총 시간
	private String readingTime				= "";	// 이번달 독서 총 시간
	private String readingTimeAvg			= "";	// 오늘까지 독서 총 시간 평균
	private int monthReadCount				= 0;	// 이번달 읽은 책
	private int monthEbookCount				= 0;	// 이번달 읽은 책(eBook)
	private int monthAudioCount				= 0;	// 이번달 읽은 책(오디오북)
	private int ebook_count					= 0;	// 추천도서 별 도서 수
	private int read_count					= 0;	// 추천도서 별 읽은 수
	private int order_percent				= 0;	// 추천도서 별 읽은 백분율
	private int category_count				= 0;	// 선호 카테고리 수
	private int category_total_count		= 0;	// 토탈 카테고리 수
	private int book_count					= 0;	// 선호 작가 도서 수
	private int calendar_date				= 0;	// 오늘까지 읽은 책 년월
	private int totalBookCount				= 0;	// category용 전체 도서 수
	private String ucs_title				= "";	// 시리즈 명
	private String uct_code					= "";	// 카테고리 코드
	private String uct_type					= "";	// 카테고리 그룹 ( E: 전자책, A: 오디오북, C: CP)
	private int uct_depth					= 0;	// 카테고리 뎁스
	private int uct_priorty					= 0;	// 카테고리 우선순위
	private String uct_ucp_code				= "";	// 카테고리 CP 코드
	private int content_count				= 0;	// 카테고리별 콘텐츠 수
	private String uil_code					= "";	// 기관  추천 서재 코드
	private String uil_name					= "";	// 기관 추천 서재명
	private String ume_status				= "";	// 인기 도서 리스트
	private String iat_img					= "";	// 템플릿 경로
	private String iat_text					= "";	// 템플릿 내용
	private String uis_name					= "";	// 기관명
	private String uim_issued_date			= "";	// 인증서 발급일
	private String udr_startdate			= "";	// 대출 시작일
	private String udr_enddate				= "";	// 대출 종료일
	private String udr_regdate				= "";	// 대출일
	private String udr_remaindate			= "";	// 대출 남은일
	private boolean seriesMeta				= false; // 시리즈 정보인지 아닌지.
	private String[] uclc_codes;					// 좋아요 배열
	private Integer uclc_like				= 0;	// 콘텐츠 좋아요 수
	private String uclc_code				= "";	// 콘텐츠 좋아요 수
	private String uclc_ucm_code			= "";	// 콘텐츠 좋아요 수
	private String uclc_type				= "";	// 콘텐츠 본인의 좋아요 여부
	private String uis_copy_book_flag		= "";	// 기관 카피 제한 여부
	private String uis_common_book_flag		= "";	// 기관 공통추천 사용 여부
	private String uis_preview_flag			= "";	// 기관 카피 제한 여부
	private String ucm_copy_book_flag		= "";	// 책 카피 제한 여부
	private Integer copy_book_flag			= 0;	// 책 카피 제한 여부
	private Integer copy_order_exist		= 0;	// 책 카피 제한 여부
	private Integer today_copy_count		= 0;	// 이용중인 카피 권수
	private String uis_return_flag			= "";	// 기관 대출반납 프로세스 여부
	private String uis_return_ui_flag		= "";	// 기관 대출반납 UI 여부
	private String type_result				= "";	// 검색 결과 타입 유형
	
	private List<FrontCmVO> seriesList;				// 도서 시리즈 리스트
	private List<FrontCmVO> popular;				// 인기 도서 리스트
	private List<FrontCmVO> bookReportList;			// 독서 감상문 리스트
	private List<FrontCmVO> writeBookReportList;	// 작성한 독서 감상문 리스트
	private List<FrontCmVO> categoryEbookList;			// 선호하는 카테고리 E북 대분류
	private List<FrontCmVO> categoryEbookDetailList;	// 선호하는 카테고리 A북 대분류
	private List<FrontCmVO> categoryAbookList;			// 선호하는 카테고리 E북 중분류
	private List<FrontCmVO> categoryAbookDetailList;	// 선호하는 카테고리 A북 중분류

	/**
	 * 2023-11-16
	 */
	private String deviceType; // deviceType 구별
	private String sortField = ""; //sortType
	private String sortFieldLibrary = ""; //sortType2
	private String ubr_is_open_checking;

	/* 2024-02-07*/
	private int current_books_read; // 현재 읽은 책
	private int limit_count;
	private int audio_count;
	private int epub_pdf_count;

	/*2024-03-28*/
	private String startDate;
	private String endDate;

	private List<String> solrData;

	public FrontCmVO() {
	}
}
