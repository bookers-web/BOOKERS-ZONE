package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class CmVO extends SearchVO {

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
	private String ucm_publisher			= "";	// 출판사명
	private String ucm_region				= "";	// 출간지역(국내 : D, 외서 : F)
	private Integer ucm_paper_price			= 0;	// 종이책 정가
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

	private String ucp_name					= "";
	private String ucp_cp_brand				= "";
	private String ucp_brand				= "";	// 출판사명 표시를 위해

	private String ucm_codes[]				= {};

	// view 매핑용
	private String ucm_old_cover_url		= "";
	private String ucm_old_thumb_url		= "";
	private String ucm_old_intro_img_url	= "";
	private String ucm_old_intro_movie_url	= "";
	private String uct_parent				= "";
	private int ucm_series_count			= 0;
	private String old_ucm_ebook_isbn		= "";	// 기존 eBook ISBN 13자리

	private String uct_code					= "";	// 카테고리 코드
	private String uct_type					= "";	// 카테고리 그룹 ( E: 전자책, A: 오디오북, C: CP)
	private String uil_code					= "";	// 기관  추천 서재 코드

	private String uis_copy_book_flag		= "";	// 카피수 제한 콘텐츠 사용 여부
	private String uis_return_flag			= "";	// 대출반납 프로세스 콘텐츠 사용 여부
	private String um_code					= "";	// 회원코드
	private String ume_code					= "";	// 내서재코드
	private String ucm_webdrm_yn			= "";	// WEB DRM 패킹 여부

	// 엑셀 다운 유무
	private String excelYn					= "N";

	// category
	private String ucm_main_category		= "";	// 대분류
	private String ucm_middle_category		= "";	// 중분류

	// 단독
	private String uce_use_yn				= "N";
	private String uce_start_dt				= "";
	private String uce_end_dt				= "";

	// 뱃지
	private String badge_e					= "N";	// 이벤트
	private String badge_p					= "N";	// 인기
	private String badge_n					= "N";	// 신규

	//solr
	private List<String> solrData;
}
