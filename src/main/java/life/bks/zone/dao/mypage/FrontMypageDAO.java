package life.bks.zone.dao.mypage;

import life.bks.zone.vo.FrontCmVO;
import java.util.List;

public interface FrontMypageDAO {
    List<FrontCmVO> mainFaqList(FrontCmVO frontCmVO);
    int faqListCount(FrontCmVO frontCmVO);
    List<FrontCmVO> faqList(FrontCmVO frontCmVO);
    FrontCmVO myExcellentSelect(FrontCmVO frontCmVO);
    FrontCmVO myInfoSelect(FrontCmVO frontCmVO);
    FrontCmVO myInfoNoSelect(FrontCmVO frontCmVO);
    int myInfoModifyProc(FrontCmVO frontCmVO);
    int myDeviceListCount(FrontCmVO frontCmVO);
    List<FrontCmVO> myDeviceList(FrontCmVO frontCmVO);
    int myDeviceModify(FrontCmVO frontCmVO);
    int deleteDevice(FrontCmVO frontCmVO);
    int myExcellentListCount(FrontCmVO frontCmVO);
    List<FrontCmVO> myExcellentList(FrontCmVO frontCmVO);
    int myExcellentPrintState(FrontCmVO frontCmVO);
}
