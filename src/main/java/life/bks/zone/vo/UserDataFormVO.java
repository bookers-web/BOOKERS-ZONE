package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;
import java.net.URLDecoder;

public class UserDataFormVO extends SearchVO {
	
	@Setter @Getter private String udf_name				= "";	// 사용자 이름
	@Setter @Getter private String udf_tel				= "";	// 사용자 전화번호
	@Setter @Getter private String udf_dep				= "";	// 사용자 소속 부서
	@Setter @Getter private String udf_dob				= "";	// 사용자 생일
	@Setter @Getter private String udf_os				= "";	// 사용자 os
	@Setter @Getter private String udf_ip				= "";	// 사용자 ip
	
	@Setter @Getter private String udf_institution		= "";	// 사용자 기관
	@Setter @Getter private String udf_regdate			= "";	// 사용자 등록날짜
	
	@Setter @Getter private String um_name				= "";	// 입과자 확인용 이름
	@Setter @Getter private String um_phone				= "";	// 입과자 확인용 휴대폰번호
	
	private String entry_um_name				= "";	// 입과자 확인용 이름
	private String entry_um_phone				= "";	// 입과자 확인용 휴대폰번호
	
	public String getEntry_um_name() {
        return entry_um_name;
    }

    public void setEntry_um_name(String entry_um_name) {
        this.entry_um_name = URLDecoder.decode(entry_um_name);
    }

    public String getEntry_um_phone() {
        return entry_um_phone;
    }

    public void setEntry_um_phone(String entry_um_phone) {
        this.entry_um_phone = entry_um_phone;
    }
	
}
