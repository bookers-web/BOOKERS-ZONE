package life.bks.zone.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

public class FrontRecommendVO extends SearchVO {
    @Setter @Getter private List<FrontRecommendGroupVO> groupList;
}
