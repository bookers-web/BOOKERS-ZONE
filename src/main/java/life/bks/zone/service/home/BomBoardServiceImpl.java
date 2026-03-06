package life.bks.zone.service.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import life.bks.zone.dao.home.BomBoardDAO;
import life.bks.zone.vo.BomBoardVO;

@Service
public class BomBoardServiceImpl implements BomBoardService {

	@Autowired
	private BomBoardDAO bomBoardDAO;

	@Override
	public List<BomBoardVO> getNoticesByUisCode(String uis_code) {
		return bomBoardDAO.getNoticesByUisCode(uis_code);
	}
}
