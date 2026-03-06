package life.bks.zone.dto;

import lombok.Getter;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SessionValidateResponse {
    
    private boolean valid;
    private String sessionId;
    private String uisCode;
    private String message;
}
