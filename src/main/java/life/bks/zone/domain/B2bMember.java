package life.bks.zone.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class B2bMember {
    
    private String umCode;         // UM_CODE - 회원코드 (UM + padded sequence)
    private String umUserid;       // UM_USERID - 사용자ID
    private String umPwd;          // UM_PWD - 비밀번호
    private String umUisCode;      // UM_UIS_CODE - 기관코드
    private String umRegType;      // UM_REG_TYPE - 등록유형 (S:시스템, C:기관, Z:Zone관내이용자)
    private String umName;         // UM_NAME - 회원명
    private String umRegUserid;    // UM_REG_USERID - 등록자
    private String umUseyn;        // UM_USEYN - 사용여부
    private String umFreeAccount;   // UM_FREE_ACCOUNT - 무료 계정 여부 (Y/N)
    private LocalDateTime umRegdate;  // UM_REGDATE - 등록일

    // 시퀀스 조회용 (TBL_SEQUENCES)
    private String seqName;        // SEQ_NAME
    private int seqCurrval;        // SEQ_CURRVAL
}
