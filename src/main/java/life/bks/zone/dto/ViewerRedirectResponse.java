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
public class ViewerRedirectResponse {
    
    private boolean success;
    private String message;
    private String viewerUrl;
    private String errorCode;
}
