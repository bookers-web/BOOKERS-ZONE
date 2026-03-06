package life.bks.zone.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WebviewerBook {
    private String ucmCode;
    private String ucpCode;
    private String title;
    private String writer;
    private String publisher;
    private String coverUrl;
    private String fileType;
    private String umCode;
    private String uisCode;
    private String ucmCode2;
    private String umeCode;
    private String umlCode;
    private String umeUmlCode;
    private String umeStatus;
    private String lastStatus;
    private String seqName;
    private int seqCurrval;
}
