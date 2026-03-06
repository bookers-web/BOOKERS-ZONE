package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

public class MemberLogVO {
	
	// 회원 로그인 로그
	@Setter @Getter private int mal_no														= 0;	// 순번
	@Setter @Getter private String mal_um_code												= "";	// 기관 코드
	@Setter @Getter private String mal_um_userid											= "";	// 기관 마스터 아이디
	@Setter @Getter private String umd_uid													= "";	// 디바이스 아이디
	@Setter @Getter private String umd_os													= "";	// OS
	@Setter @Getter private String mal_login_date											= "";	// 로그인 시각
	@Setter @Getter private String mal_login_ip												= "";	// 로그인 IP
	@Setter @Getter private String mal_regdate												= "";	// 등록일
}
