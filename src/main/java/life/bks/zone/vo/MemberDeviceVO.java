package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

public class MemberDeviceVO extends SearchVO {
	
	@Getter @Setter private int rnum							= 0;
	
	// 회원 디바이스 관련
	@Getter @Setter private String umd_code						= "";	// 디바이스 코드
	@Getter @Setter private String umd_um_code					= "";	// 회원 코드
	@Getter @Setter private String umd_uid						= "";	// 디바이스 아이디
	@Getter @Setter private String umd_name						= "";	// 디바이스 명칭
	@Getter @Setter private String umd_os						= "";	// OS
	@Getter @Setter private String umd_regdate					= "";	// 등록일
	
	
}
