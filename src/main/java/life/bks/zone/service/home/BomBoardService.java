package life.bks.zone.service.home;

import life.bks.zone.vo.BomBoardVO;
import java.util.List;

public interface BomBoardService {
    List<BomBoardVO> getNoticesByUisCode(String uis_code);
}
