package life.bks.zone.dto;

import lombok.Getter;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SessionCreateResponse {
    
    private boolean success;
    private String sessionId;
    private String message;
    private String errorCode;
    private String umCode;
}
