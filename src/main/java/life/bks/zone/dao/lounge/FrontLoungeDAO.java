package life.bks.zone.dao.lounge;

import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.CommonVO;

import java.util.List;

public interface FrontLoungeDAO {

    int getSeqence(CommonVO commonVO);

    int allBookReportListCount(FrontCmVO frontCmVO);

    List<FrontCmVO> allBookReportList(FrontCmVO frontCmVO);

    int allBookReportDetailCount(FrontCmVO frontCmVO);

    List<FrontCmVO> allBookReportDetail(FrontCmVO frontCmVO);

    FrontCmVO allBookReportDetailView(FrontCmVO frontCmVO);

    int insertBookReportComment(FrontCmVO frontCmVO);

    int deleteBookReportComment(FrontCmVO frontCmVO);

    FrontCmVO selectBookReportComment(FrontCmVO frontCmVO);

    void bookReportState(FrontCmVO frontCmVO);

    int allDiscussionListCount(FrontCmVO frontCmVO);

    List<FrontCmVO> allDiscussionList(FrontCmVO frontCmVO);

    int allDiscussionDetailCount(FrontCmVO frontCmVO);

    List<FrontCmVO> allDiscussionDetail(FrontCmVO frontCmVO);

    int insertDiscussion(FrontCmVO frontCmVO);

    int updateDiscussion(FrontCmVO frontCmVO);

    int deleteDiscussion(FrontCmVO frontCmVO);

    int insertDiscussionComment(FrontCmVO frontCmVO);

    int deleteDiscussionComment(FrontCmVO frontCmVO);

    FrontCmVO selectDiscussionComment(FrontCmVO frontCmVO);

    int insertReportCopyright(FrontCmVO frontCmVO);

    FrontCmVO selectProhibition(FrontCmVO frontCmVO);
}
