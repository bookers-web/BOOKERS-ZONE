package life.bks.zone.service.lounge;

import life.bks.zone.vo.FrontCmVO;

public interface FrontLoungeService {

    FrontCmVO allBookReportList(FrontCmVO frontCmVO);

    FrontCmVO allBookReportDetail(FrontCmVO frontCmVO);

    FrontCmVO allBookReportDetailView(FrontCmVO frontCmVO);

    int bookReportCommentStateService(FrontCmVO frontCmVO);

    FrontCmVO selectBookReportComment(FrontCmVO frontCmVO);

    FrontCmVO allDiscussionList(FrontCmVO frontCmVO);

    FrontCmVO allDiscussionDetail(FrontCmVO frontCmVO);

    boolean discussionWriteProc(FrontCmVO frontCmVO);

    int modifyDiscussionService(FrontCmVO frontCmVO);

    int modifyDiscussionCommentService(FrontCmVO frontCmVO);

    FrontCmVO selectDiscussionComment(FrontCmVO frontCmVO);

    int insertReportCopyright(FrontCmVO frontCmVO);

    FrontCmVO selectProhibition(FrontCmVO frontCmVO);
}
