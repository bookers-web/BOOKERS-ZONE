package life.bks.zone.controller.home;

import life.bks.zone.service.home.FrontRecommendService;
import life.bks.zone.service.member.MemberService;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.MemberVO;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping(value = "/front")
public class MobileController {

    @Autowired
    private FrontRecommendService frontRecommendService;

    @Autowired
    private MemberService memberService;

    @RequestMapping(value = "/mobile/main.do")
    public ModelAndView main() {
        ModelAndView model = new ModelAndView();
        model.setViewName("redirect:/front/home/main.do?searchMobileYn=Y");
        return model;
    }

    @RequestMapping(value = "/mobile/recommendList.do")
    public ModelAndView recommendList(HttpServletRequest request, FrontCmVO frontCmVO) {
        ModelAndView model = new ModelAndView();

        MemberVO memberVO = new MemberVO();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);
        if (ormAuthVO != null) {
            frontCmVO.setUis_copy_book_flag(ormAuthVO.getUis_copy_book_flag());
            frontCmVO.setUis_return_flag(ormAuthVO.getUis_return_flag());
        }

        frontCmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));
        frontCmVO.setUis_ucp_code((String) request.getSession().getAttribute("UIS_UCP_CODE"));
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));

        FrontCmVO recommendBookList = frontRecommendService.recommendList(frontCmVO);
        String groupName = frontRecommendService.selectRecommendGroupName(frontCmVO);

        model.addObject("chooseCmList", recommendBookList.getResultList());
        model.addObject("paging", recommendBookList);
        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);
        model.addObject("groupName", groupName);
        model.setViewName("mo/mo_01");
        return model;
    }

    @RequestMapping(value = "/mobile/bookDetail.do")
    public ModelAndView bookDetail(HttpServletRequest request, FrontCmVO cmVO) {
        ModelAndView model = new ModelAndView();

        cmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));
        cmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));
        cmVO.setUis_ucp_code((String) request.getSession().getAttribute("UIS_UCP_CODE"));

        MemberVO memberVO = new MemberVO();
        String[] introList = null;

        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);
        if (ormAuthVO != null) {
            cmVO.setUis_copy_book_flag(ormAuthVO.getUis_copy_book_flag());
            cmVO.setUis_common_book_flag(ormAuthVO.getUis_common_book_flag());
            cmVO.setUis_return_flag(ormAuthVO.getUis_return_flag());
            cmVO.setUis_return_ui_flag(ormAuthVO.getUis_return_ui_flag());
            cmVO.setUis_preview_flag(ormAuthVO.getUis_preview_flag());
        }

        FrontCmVO resultVO = frontRecommendService.bookDetail(cmVO);
        if (resultVO == null) {
            model.setViewName("mo/mo_index");
            return model;
        }
        if (resultVO.getUcm_intro_img_url() != null && !resultVO.getUcm_intro_img_url().isEmpty()) {
            resultVO.setUcm_intro_img_url(resultVO.getUcm_intro_img_url().replaceAll(" ", ""));
            introList = resultVO.getUcm_intro_img_url().trim().split(",");
        }

        FrontRecommendVO ormRecommendVO = frontRecommendService.bookDetailCuration(cmVO);

        model.addObject("cmVO", resultVO);
        model.addObject("seriesList", resultVO.getSeriesList());
        model.addObject("popularList", resultVO.getPopular());
        model.addObject("introList", introList);
        model.addObject("curation", ormRecommendVO == null ? List.of() : ormRecommendVO.getGroupList());
        model.setViewName("mo/mo_02");
        return model;
    }

    @RequestMapping(value = "/mobile/searchList.do")
    public ModelAndView searchList(HttpServletRequest request, FrontCmVO frontCmVO, @RequestParam String preUrl) {
        ModelAndView model = new ModelAndView();

        MemberVO memberVO = new MemberVO();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);
        if (ormAuthVO != null) {
            frontCmVO.setUis_copy_book_flag(ormAuthVO.getUis_copy_book_flag());
            frontCmVO.setUis_return_flag(ormAuthVO.getUis_return_flag());
        }

        frontCmVO.setUis_code((String) request.getSession().getAttribute("UM_UIS_CODE"));
        frontCmVO.setUis_ucp_code((String) request.getSession().getAttribute("UIS_UCP_CODE"));
        frontCmVO.setUm_code((String) request.getSession().getAttribute("UM_CODE"));

        FrontCmVO bookList = frontRecommendService.bookSearchList(frontCmVO);
        model.addObject("BookList", bookList.getResultList());
        model.addObject("BookPaging", bookList);
        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);
        model.addObject("preUrl", preUrl);

        // 검색 결과 없을 때 실시간 인기 도서 표시용 (HomeController searchList.do 동일)
        if (bookList == null || bookList.getResultList() == null || bookList.getResultList().isEmpty()) {
            frontCmVO.setLimit_count(10);
            java.util.List<FrontCmVO> searchPopularList = frontRecommendService.searchPopularList(frontCmVO);
            model.addObject("searchPopularList", searchPopularList);
        }

        model.setViewName("mo/mo_search");
        return model;
    }

    @RequestMapping(value = "/mobile/category.do")
    public ModelAndView category(HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        String queryString = request.getQueryString();

        if (StringUtils.isNotEmpty(queryString)) {
            model.setViewName("redirect:/front/home/categoryList.do?searchMobileYn=Y&" + queryString);
        } else {
            model.setViewName("redirect:/front/home/categoryList.do?searchMobileYn=Y");
        }

        return model;
    }
}
