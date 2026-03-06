package life.bks.zone.service.mypage;

import life.bks.zone.vo.FrontCmVO;

public interface FrontMypageService {
    FrontCmVO mainFaqList(FrontCmVO frontCmVO);
    FrontCmVO faqList(FrontCmVO frontCmVO);
    FrontCmVO myExcellentSelect(FrontCmVO frontCmVO);
    FrontCmVO myInfoSelect(FrontCmVO frontCmVO);
    FrontCmVO myInfoNoSelect(FrontCmVO frontCmVO);
    boolean myInfoModifyProc(FrontCmVO frontCmVO);
    FrontCmVO myDeviceList(FrontCmVO frontCmVO);
    int myDeviceModify(FrontCmVO frontCmVO);
    boolean deleteDevice(FrontCmVO frontCmVO);
    FrontCmVO myExcellentList(FrontCmVO frontCmVO);
    int myExcellentPrintState(FrontCmVO frontCmVO);
}
