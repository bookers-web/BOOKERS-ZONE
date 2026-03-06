package life.bks.zone.dao.home;

import life.bks.zone.vo.BomBoardVO;
import java.util.List;

public interface BomBoardDAO {
    List<BomBoardVO> getNoticesByUisCode(String uis_code);
}
