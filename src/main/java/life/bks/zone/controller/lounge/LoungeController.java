package life.bks.zone.controller.lounge;

import life.bks.zone.service.lounge.FrontLoungeService;
import life.bks.zone.service.member.MemberService;
import life.bks.zone.service.home.FrontRecommendService;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

import static org.apache.logging.log4j.util.Strings.isNotEmpty;

@Controller
@RequiredArgsConstructor
public class LoungeController {

    private final MemberService memberService;
    private final FrontLoungeService frontLoungeService;
    private final FrontRecommendService frontRecommendService;

    @RequestMapping(value = "/front/lounge/main.do")
    public ModelAndView loungePage(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        setCommonSessionValues(request, frontCmVO);

        MemberVO memberVO = new MemberVO();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);
        frontCmVO.setUis_copy_book_flag(
                ormAuthVO != null && ormAuthVO.getUis_copy_book_flag() != null
                        ? ormAuthVO.getUis_copy_book_flag()
                        : "N"
        );
        frontCmVO.setUis_return_flag(
                ormAuthVO != null && ormAuthVO.getUis_return_flag() != null
                        ? ormAuthVO.getUis_return_flag()
                        : "N"
        );

        String searchKey = frontCmVO.getSearchKey();
        FrontCmVO resultVO = frontLoungeService.allBookReportList(frontCmVO);
        frontCmVO.setSearchKey(searchKey);

        model.addObject("list", resultVO.getResultList());
        model.addObject("paging", resultVO);
        model.addObject("searchVO", frontCmVO);

        model.setViewName("lr/lr_01");

        return model;
    }

    @RequestMapping(value = "/front/lounge/view.do")
    public ModelAndView view(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        setCommonSessionValues(request, frontCmVO);
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));

        FrontCmVO cmVO = frontRecommendService.bookDetailInfo(frontCmVO);
        model.addObject("cmVO", cmVO);

        FrontCmVO resultVO = frontLoungeService.allBookReportDetail(frontCmVO);
        model.addObject("list", resultVO.getResultList());
        model.addObject("paging", resultVO);
        model.addObject("searchVO", frontCmVO);

        model.setViewName("lr/lr_01_2");

        return model;
    }

    @RequestMapping(value = "/front/lounge/detailView.do")
    public ModelAndView detailView(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        setCommonSessionValues(request, frontCmVO);
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));

        FrontCmVO resultVO = frontLoungeService.allBookReportDetailView(frontCmVO);
        if (resultVO == null) {
            return new ModelAndView("redirect:/front/lounge/view.do?ucm_code=" + frontCmVO.getUcm_code());
        }

        model.addObject("frontCmVO", frontCmVO);
        model.addObject("reportVO", resultVO);
        model.setViewName("lr/lr_01_3");
        return model;
    }

    @RequestMapping(value = "/front/lounge/discussion.do")
    public ModelAndView discussionPage(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        setCommonSessionValues(request, frontCmVO);

        MemberVO memberVO = new MemberVO();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);
        frontCmVO.setUis_copy_book_flag(
                ormAuthVO != null && ormAuthVO.getUis_copy_book_flag() != null
                        ? ormAuthVO.getUis_copy_book_flag()
                        : "N"
        );
        frontCmVO.setUis_return_flag(
                ormAuthVO != null && ormAuthVO.getUis_return_flag() != null
                        ? ormAuthVO.getUis_return_flag()
                        : "N"
        );

        String searchKey = frontCmVO.getSearchKey();
        FrontCmVO resultVO = frontLoungeService.allDiscussionList(frontCmVO);
        frontCmVO.setSearchKey(searchKey);

        model.addObject("list", resultVO.getResultList());
        model.addObject("paging", resultVO);
        model.addObject("searchVO", frontCmVO);

        model.setViewName("lr/lr_02");

        return model;
    }

    @RequestMapping(value = "/front/lounge/discussionView.do")
    public ModelAndView discussionView(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        setCommonSessionValues(request, frontCmVO);

        FrontCmVO cmVO = frontRecommendService.bookDetail(frontCmVO);
        if (cmVO == null || cmVO.getUcm_code() == null || cmVO.getUcm_code().isBlank()) {
            return new ModelAndView("redirect:/front/lounge/discussion.do");
        }

        model.addObject("cmVO", cmVO);

        FrontCmVO resultVO = frontLoungeService.allDiscussionDetail(frontCmVO);
        if (isNotEmpty(cmVO.getUcd_code())) {
            frontCmVO.setUcd_um_code((String) request.getSession().getAttribute("UM_CODE"));
            FrontCmVO myDiscussionVO = frontLoungeService.allDiscussionDetail(frontCmVO);
            model.addObject("myDiscussionVO", myDiscussionVO.getResultList());
        }

        FrontCmVO prohibitionVO = frontLoungeService.selectProhibition(frontCmVO);
        model.addObject("prohibitionVO", prohibitionVO);

        model.addObject("list", resultVO.getResultList());
        model.addObject("paging", resultVO);
        model.addObject("searchVO", frontCmVO);

        model.setViewName("lr/lr_02_2");

        return model;
    }

    @RequestMapping(value = "/front/lounge/discussionWriteProc.do")
    public ModelAndView discussionWriteProc(
            jakarta.servlet.http.HttpServletRequest request,
            ModelAndView model,
            FrontCmVO frontCmVO
    ) {
        frontCmVO.setUcd_ucm_code(frontCmVO.getUcm_code());
        frontCmVO.setUcd_uis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));
        frontCmVO.setUcd_um_code((String) request.getSession().getAttribute("UM_CODE"));
        frontCmVO.setUcd_um_userid((String) request.getSession().getAttribute("UM_USERID"));
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));
        frontCmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));

        boolean result = frontLoungeService.discussionWriteProc(frontCmVO);

        if (result) {
            return new ModelAndView("redirect:/front/lounge/discussionView.do?ucm_code=" + frontCmVO.getUcm_code());
        }

        return new ModelAndView("redirect:/front/lounge/discussionView.do?ucm_code=" + frontCmVO.getUcm_code());
    }

    @RequestMapping(value = "/front/lounge/modifyDiscussionService.json")
    @ResponseBody
    public Map<String, Object> modifyDiscussionService(
            jakarta.servlet.http.HttpServletRequest request,
            @RequestParam(value = "ucd_code", required = false) String ucd_code,
            @RequestParam(value = "ucd_comments", required = false) String ucd_comments
    ) {
        FrontCmVO frontCmVO = new FrontCmVO();
        frontCmVO.setUcd_code(ucd_code);
        frontCmVO.setUcd_comment(ucd_comments);

        int count = frontLoungeService.modifyDiscussionService(frontCmVO);

        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        result.put("resultMsg", count > 0 ? "정상 처리되었습니다." : "정상 처리되지 않았습니다. 잠시 후 이용해주세요.");
        return result;
    }

    @RequestMapping(value = "/front/lounge/modifyDiscussionCommentService.json")
    @ResponseBody
    public Map<String, Object> modifyDiscussionCommentService(
            jakarta.servlet.http.HttpServletRequest request,
            @RequestParam(value = "ucdc_code", required = false) String ucdc_code,
            @RequestParam(value = "ucd_code", required = false) String ucd_code
    ) {
        FrontCmVO frontCmVO = new FrontCmVO();
        frontCmVO.setUcdc_code(ucdc_code);
        frontCmVO.setUcdc_um_code((String) request.getSession().getAttribute("UM_CODE"));
        frontCmVO.setUcdc_ucd_code(ucd_code);
        frontCmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));

        int count = frontLoungeService.modifyDiscussionCommentService(frontCmVO);

        Map<String, Object> result = new HashMap<>();
        result.put("count", count);

        if (count > 0) {
            if (ucdc_code == null || ucdc_code.isBlank()) {
                FrontCmVO resultCmVO = frontLoungeService.selectDiscussionComment(frontCmVO);
                result.put("resultMsg", resultCmVO != null ? resultCmVO.getUcdc_code() : "");
            }
            if (!result.containsKey("resultMsg")) {
                result.put("resultMsg", "정상 처리되었습니다.");
            }
        } else {
            result.put("resultMsg", "정상 처리되지 않았습니다. 잠시 후 이용해주세요.");
        }
        return result;
    }

    @RequestMapping(value = "/front/lounge/bookReportCommentStateService.json")
    @ResponseBody
    public Map<String, Object> bookReportCommentStateService(
            jakarta.servlet.http.HttpServletRequest request,
            @RequestParam(value = "ubrc_code", required = false) String ubrc_code,
            @RequestParam(value = "ubrc_ubr_code", required = false) String ubrc_ubr_code
    ) {
        FrontCmVO frontCmVO = new FrontCmVO();
        frontCmVO.setUbrc_code(ubrc_code);
        frontCmVO.setUbrc_ubr_code(ubrc_ubr_code);
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));

        int count = frontLoungeService.bookReportCommentStateService(frontCmVO);

        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        if (count > 0) {
            if (!isNotEmpty(ubrc_code)) {
                FrontCmVO resultCmVO = frontLoungeService.selectBookReportComment(frontCmVO);
                result.put("resultMsg", resultCmVO != null ? resultCmVO.getUbrc_code() : "");
            } else {
                result.put("resultMsg", "정상 처리되었습니다.");
            }
        } else {
            result.put("resultMsg", "정상 처리되지 않았습니다. 잠시 후 이용해주세요.");
        }
        return result;
    }

    @RequestMapping(value = "/front/lounge/reportCopyrightService.json")
    @ResponseBody
    public Map<String, Object> reportCopyrightService(
            jakarta.servlet.http.HttpServletRequest request,
            @RequestParam(value = "urc_ucd_code", required = false) String urc_ucd_code,
            @RequestParam(value = "urc_title", required = false) String urc_title,
            @RequestParam(value = "urc_content", required = false) String urc_content,
            @RequestParam(value = "urc_ucm_code", required = false) String urc_ucm_code
    ) {
        FrontCmVO frontCmVO = new FrontCmVO();
        frontCmVO.setUrc_um_code((String) request.getSession().getAttribute("UM_CODE"));
        frontCmVO.setUrc_ucd_code(urc_ucd_code);
        frontCmVO.setUrc_title(URLDecoder.decode(urc_title, StandardCharsets.UTF_8));
        frontCmVO.setUrc_content(URLDecoder.decode(urc_content, StandardCharsets.UTF_8));
        frontCmVO.setUrc_ucm_code(urc_ucm_code);

        int count = frontLoungeService.insertReportCopyright(frontCmVO);

        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        result.put("resultMsg", count > 0 ? "정상 처리되었습니다." : "정상 처리되지 않았습니다. 잠시 후 이용해주세요.");
        return result;
    }

    private void setCommonSessionValues(jakarta.servlet.http.HttpServletRequest request, FrontCmVO frontCmVO) {
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));
        frontCmVO.setUis_ucp_code((String) request.getSession().getAttribute("UIS_UCP_CODE"));
        frontCmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));
        frontCmVO.setUis_name((String) request.getSession().getAttribute("UIS_NAME"));
    }
}
