package life.bks.zone.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InstitutionInfo {

    private String uisCode;
    private String uisName;
    private String uisUcpCode;
    private String uisWebLogoUrl;
    private String uisMobileLogoUrl;
    private String uisKeycolor;
    private String uisPreviewFlag;
    private String uisReturnFlag;
    private String uisReturnUiFlag;
    private String uisPwFlag;
    private String uisCommonBookFlag;
    private String uisCopyBookFlag;
    private String uisAuthMethod;
}
