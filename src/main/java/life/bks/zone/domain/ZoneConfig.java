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
public class ZoneConfig {

    private String uisCode;          // PK (TBL_ZONE_CONFIG)
    private Integer maxConcurrent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // JOIN 필드 (TBL_INSTITUTION_MASTER)
    private String uisName;
}
