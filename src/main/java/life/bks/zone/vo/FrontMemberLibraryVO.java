package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

public class FrontMemberLibraryVO extends SearchVO {
	
	// 회원 서재 관련 - 기본 서재
	@Setter @Getter private String ucm_code					= "";	// 컨텐츠 코드
	@Setter @Getter private String uml_code					= "";	// 서재 코드
	@Setter @Getter private String uml_um_code				= "";	// 회원 코드
	@Setter @Getter private String uml_name					= "";	// 서재 명
	@Setter @Getter private String uml_pwd					= "";	// 서재 비밀번호
	@Setter @Getter private int uml_book_count				= 0;	// 서재의 도서 수
	@Setter @Getter private String uml_type					= "";	// 서재의 형태(D : 기본 책장, U : 사용자 책장)
	@Setter @Getter private String uml_regdate				= "";	// 등록일
	
	// 회원 서재 도서 관련
	@Setter @Getter private String ume_code					= "";	// 회원 도서 코드
	@Setter @Getter private String ume_uml_code				= "";	// 회원 서재 코드
	@Setter @Getter private String ume_ucm_code				= "";	// 도서 코드
	@Setter @Getter private String ume_udr_code				= "";	// 도서 주문 코드
	@Setter @Getter private int ume_seq						= 0;	// 도서 정보 동기화를 위한 코드
	@Setter @Getter private int ume_last_read_percent		= 0;	// 마지막 읽은 백분률
	@Setter @Getter private int ume_last_read_idx			= 0;	// 마지막 읽은 파일 번호
	@Setter @Getter private String ume_last_read_position	= "";	// 마지막 읽은 위치
	@Setter @Getter private String ume_last_read_date		= "";	// 마지막 읽은 일자
	@Setter @Getter private int ume_finishread_count		= 0;	// 완독 횟수
	@Setter @Getter private String ume_finishread_date		= "";	// 마지막 완독일
	@Setter @Getter private String ume_read_status			= "";	// 독서 상태
	@Setter @Getter private String ume_islock				= "";	// 잠금( Y , N )
	@Setter @Getter private String ume_password				= "";	// 비밀번호
	@Setter @Getter private String ume_status				= "";	// 서재 포함도서 여부 (Y/N)
	@Setter @Getter private String ume_isdownload			= "";	// 다운로드 여부(Y / N)
	@Setter @Getter private int ume_rate					= 0;	// 도서 별점 (0 ~ 5)
	@Setter @Getter private String ume_rate_memo			= "";	// 도서 한줄 평가
	@Setter @Getter private String ume_mod_date				= "";	// 마지막 업데이트 일자
	@Setter @Getter private String ume_regdate				= "";	// 등록일
	
	@Setter @Getter private String ume_codes[];						// 내서재 코드 배열
}
