package life.bks.zone.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GuestLoginResponse {
    
    private boolean success;
    private String message;
    private String umCode;
    private String sessionId;
    private String errorCode;
}
