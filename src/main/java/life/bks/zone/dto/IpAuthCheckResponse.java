package life.bks.zone.dto;

import lombok.Getter;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class IpAuthCheckResponse {
    
    private boolean ipAuthRequired;
    private String uisCode;
    private String uisName;
    private Integer maxConcurrent;
    private Integer currentCount;
    private String clientIp;
}
