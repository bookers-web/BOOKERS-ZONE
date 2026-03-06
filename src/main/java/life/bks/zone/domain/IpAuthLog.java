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
public class IpAuthLog {
    
    private Long id;
    private String sessionId;
    private String uisCode;
    private String clientIp;
    private String action;
    private String bookId;
    private LocalDateTime createdAt;
}
