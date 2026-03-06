package life.bks.zone.controller.home;

import life.bks.zone.service.home.BomBoardService;
import life.bks.zone.service.home.FrontRecommendService;
import life.bks.zone.service.member.MemberService;
import life.bks.zone.vo.BomBoardVO;
import life.bks.zone.vo.FrontCmVO;
import life.bks.zone.vo.FrontEventVO;
import life.bks.zone.vo.FrontRecommendVO;
import life.bks.zone.vo.MemberVO;
import life.bks.zone.vo.SearchVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final MemberService memberService;
    private final FrontRecommendService frontRecommendService;
    private final BomBoardService bomBoardService;

    @RequestMapping(value = "/front/home/main.do")
    public ModelAndView main(HttpServletRequest request, SearchVO searchVO) {
        ModelAndView model = new ModelAndView();
        searchVO.setSearchUisCode((String) request.getSession().getAttribute("UM_UIS_CODE"));
        searchVO.setSearchUcpCode((String) request.getSession().getAttribute("UIS_UCP_CODE"));

        MemberVO memberVO = new MemberVO();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        memberVO.setUm_uis_code(uisCode);

        MemberVO ormAuthVO = memberService.selectOrm(memberVO);

        if (ormAuthVO != null) {
            searchVO.setSearch_uis_copy_book_flag(ormAuthVO.getUis_copy_book_flag());
            searchVO.setSearch_uis_return_flag(ormAuthVO.getUis_return_flag());

            if ("Y".equals(ormAuthVO.getUis_common_book_flag())) {
                FrontRecommendVO ormRecommendVO = frontRecommendService.commonlist(searchVO);
                model.addObject("list", ormRecommendVO.getGroupList());
                model.addObject("paging", ormRecommendVO);
                model.addObject("searchVO", searchVO);
            } else {
                FrontRecommendVO ormRecommendVO = frontRecommendService.list(searchVO);
                model.addObject("list", ormRecommendVO.getGroupList());
                model.addObject("paging", ormRecommendVO);
                model.addObject("searchVO", searchVO);
            }
        } else {
            model.addObject("list", null);
            model.addObject("paging", null);
            model.addObject("searchVO", searchVO);
        }

        List<BomBoardVO> bomBoardVO = bomBoardService.getNoticesByUisCode(uisCode);
        model.addObject("bomBoardVO", bomBoardVO);

        // 주제별 nav에 eBook/오디오북 서브메뉴 표시 여부
        List<FrontCmVO> categoryList = frontRecommendService.selectCategoryList(new FrontCmVO());
        boolean hasEbook = categoryList.stream().anyMatch(c -> "E".equals(c.getUct_type()));
        boolean hasAudio = categoryList.stream().anyMatch(c -> "A".equals(c.getUct_type()));
        model.addObject("hasEbook", hasEbook);
        model.addObject("hasAudio", hasAudio);

        String target = life.bks.zone.util.CommonUtil.browerCheck((String) request.getHeader("User-Agent"));
        HttpSession httpSession = request.getSession();
        if (searchVO.getSearchMobileYn().equals("Y")) {
            httpSession.setAttribute("mobileYn", "Y");
            model.setViewName("mo/mo_index");
        } else if (searchVO.getSearchMobileYn().equals("N")) {
            httpSession.setAttribute("mobileYn", "N");
            model.setViewName("home/index");
        } else {
            if (org.apache.commons.lang3.StringUtils.isNotEmpty(target) && (("iPhone").equals(target) || ("Android").equals(target)) || ("else model").equals(target)) {
                model.setViewName("mo/mo_index");
            } else {
                model.setViewName("home/index");
            }
        }

        return model;
    }

    @RequestMapping(value = "/front/home/recommendList.do")
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

        // 주제별 nav에 eBook/오디오북 서브메뉴 표시 여부
        List<FrontCmVO> categoryList = frontRecommendService.selectCategoryList(new FrontCmVO());
        model.addObject("hasEbook", categoryList.stream().anyMatch(c -> "E".equals(c.getUct_type())));
        model.addObject("hasAudio", categoryList.stream().anyMatch(c -> "A".equals(c.getUct_type())));
        model.setViewName("home/hm_01");

        return model;
    }

    @RequestMapping(value = "/front/home/categoryList.do")
    public ModelAndView categoryList(HttpServletRequest request, FrontCmVO frontCmVO) {

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

        // 모바일/PC deviceType 세팅 (서비스에서 pageSize 분기에 사용)
        if (isMobile(request, frontCmVO.getSearchMobileYn())) {
            frontCmVO.setDeviceType("mobile");
        } else {
            frontCmVO.setDeviceType("pc");
        }

        FrontCmVO newBookList = frontRecommendService.categoryList(frontCmVO);
        model.addObject("chooseCmList", newBookList.getResultList());
        model.addObject("paging", newBookList);
        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);

        // 카테고리 시작 — WWW CategoryController 로직 이식 (hm_02와 동일 패턴)
        List<String> availableTypes = frontRecommendService.selectAvailableCategoryTypes(frontCmVO);

        if (availableTypes == null || availableTypes.isEmpty()) {
            model.addObject("hasEbook", false);
            model.addObject("hasAudio", false);
            model.addObject("hasAll", false);
            model.addObject("categoryMainList", List.of());
            model.addObject("categorySubList", List.of());
            model.addObject("selectedRowIndex", -1);
            model.setViewName(isMobile(request, frontCmVO.getSearchMobileYn()) ? "mo/mo_04" : "home/hm_04");
            return model;
        }

        boolean hasEbook = availableTypes.contains("E");
        boolean hasAudio = availableTypes.contains("A");
        boolean hasAll   = hasEbook || hasAudio;

        model.addObject("hasEbook", hasEbook);
        model.addObject("hasAudio", hasAudio);
        model.addObject("hasAll", hasAll);

        String categoryText = "";
        String selectedMainCategroy = "";
        String selectedSubCategroy = "";
        List<FrontCmVO> categoryMainList = new ArrayList<>();
        List<FrontCmVO> categorySubList = new ArrayList<>();
        int selectedRowIndex = -1;

        if (frontCmVO.getUct_type() != null && !frontCmVO.getUct_type().isEmpty()) {
            if ("E".equals(frontCmVO.getUct_type())) categoryText = "eBook";
            if ("A".equals(frontCmVO.getUct_type())) categoryText = "오디오북";
            FrontCmVO mainAllVO = new FrontCmVO();
            mainAllVO.setUct_code("");
            mainAllVO.setUct_name("전체");
            mainAllVO.setUct_depth(0);
            mainAllVO.setUct_parent(null);
            mainAllVO.setUct_type(frontCmVO.getUct_type());
            categoryMainList.add(mainAllVO);

            FrontCmVO subAllVO = new FrontCmVO();
            subAllVO.setUct_code(frontCmVO.getUct_parent());
            subAllVO.setUct_name("전체");
            subAllVO.setUct_depth(1);
            subAllVO.setUct_parent(frontCmVO.getUct_parent());
            subAllVO.setUct_type(frontCmVO.getUct_type());
            categorySubList.add(subAllVO);

            List<FrontCmVO> resultList = frontRecommendService.selectCategoryListV2(frontCmVO);
            if (resultList != null) {
                for (FrontCmVO vo : resultList) {
                    if (vo.getUct_depth() == 0) {
                        categoryMainList.add(vo);
                        if (vo.getUct_code().equals(frontCmVO.getUct_parent())) {
                            selectedMainCategroy = vo.getUct_name();
                        }
                    } else if (vo.getUct_depth() == 1) {
                        categorySubList.add(vo);
                        if (vo.getUct_code().equals(frontCmVO.getUct_code())) {
                            selectedSubCategroy = vo.getUct_name();
                        }
                    }
                }
            }

            if (frontCmVO.getUct_code() != null && !frontCmVO.getUct_code().isEmpty()
                    && frontCmVO.getUct_parent() != null && !frontCmVO.getUct_parent().isEmpty()) {
                for (int i = 0; i < categoryMainList.size(); i++) {
                    if (frontCmVO.getUct_parent().equals(categoryMainList.get(i).getUct_code())) {
                        selectedRowIndex = i / 8;
                        break;
                    }
                }
            }
        } else {
            categoryText = "전체";
        }

        model.addObject("selectedRowIndex", selectedRowIndex);
        model.addObject("categoryMainList", categoryMainList);
        model.addObject("categorySubList", categorySubList);
        model.addObject("categoryText", categoryText);
        model.addObject("selectedMainCategroy", selectedMainCategroy);
        model.addObject("selectedSubCategroy", selectedSubCategroy);
        model.setViewName(isMobile(request, frontCmVO.getSearchMobileYn()) ? "mo/mo_04" : "home/hm_04");

        return model;
    }

    @RequestMapping(value = "/front/home/newBookList.do")
    public ModelAndView newBookList(HttpServletRequest request, FrontCmVO frontCmVO) {

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

        FrontCmVO newBookList = frontRecommendService.newBookList(frontCmVO);
        model.addObject("chooseCmList", newBookList.getResultList());
        model.addObject("paging", newBookList);
        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);

        // 카테고리 시작 — WWW CategoryController 로직 이식
        List<String> availableTypes = frontRecommendService.selectAvailableCategoryTypes(frontCmVO);

        if (availableTypes == null || availableTypes.isEmpty()) {
            model.addObject("hasEbook", false);
            model.addObject("hasAudio", false);
            model.addObject("hasAll", false);
            model.addObject("categoryMainList", List.of());
            model.addObject("categorySubList", List.of());
            model.addObject("selectedRowIndex", -1);
            model.setViewName("home/hm_02");
            return model;
        }

        boolean hasEbook = availableTypes.contains("E");
        boolean hasAudio = availableTypes.contains("A");
        boolean hasAll   = hasEbook || hasAudio;

        model.addObject("hasEbook", hasEbook);
        model.addObject("hasAudio", hasAudio);
        model.addObject("hasAll", hasAll);

        List<FrontCmVO> categoryMainList = new ArrayList<>();
        List<FrontCmVO> categorySubList = new ArrayList<>();
        int selectedRowIndex = -1;

        if (frontCmVO.getUct_type() != null && !frontCmVO.getUct_type().isEmpty()) {

            // 메인 전체 카테고리
            FrontCmVO mainAllVO = new FrontCmVO();
            mainAllVO.setUct_code("");
            mainAllVO.setUct_name("전체");
            mainAllVO.setUct_depth(0);
            mainAllVO.setUct_parent(null);
            mainAllVO.setUct_type(frontCmVO.getUct_type());
            categoryMainList.add(mainAllVO);

            // 서브 전체 카테고리
            FrontCmVO subAllVO = new FrontCmVO();
            subAllVO.setUct_code(frontCmVO.getUct_parent());
            subAllVO.setUct_name("전체");
            subAllVO.setUct_depth(1);
            subAllVO.setUct_parent(frontCmVO.getUct_parent());
            subAllVO.setUct_type(frontCmVO.getUct_type());
            categorySubList.add(subAllVO);

            // selectCategoryListV2는 List<FrontCmVO>를 반환 — DAO를 직접 호출
            List<FrontCmVO> resultList = frontRecommendService.selectCategoryListV2(frontCmVO);
            if (resultList != null) {
                for (FrontCmVO vo : resultList) {
                    if (vo.getUct_depth() == 0) {
                        categoryMainList.add(vo);
                    } else if (vo.getUct_depth() == 1) {
                        categorySubList.add(vo);
                    }
                }
            }

            // 중분류 노출 — selectedRowIndex 계산
            if (frontCmVO.getUct_code() != null && !frontCmVO.getUct_code().isEmpty()
                    && frontCmVO.getUct_parent() != null && !frontCmVO.getUct_parent().isEmpty()) {
                for (int i = 0; i < categoryMainList.size(); i++) {
                    if (frontCmVO.getUct_parent().equals(categoryMainList.get(i).getUct_code())) {
                        selectedRowIndex = i / 8;
                        break;
                    }
                }
            }
        }

        model.addObject("selectedRowIndex", selectedRowIndex);
        model.addObject("categoryMainList", categoryMainList);
        model.addObject("categorySubList", categorySubList);
        model.setViewName("home/hm_02");

        return model;
    }
    @RequestMapping(value = "/front/home/popularList.do")
    public ModelAndView popularList(HttpServletRequest request, FrontCmVO frontCmVO) {

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

        // 기간/기관 필터 기본값 설정 (WWW 동일)
        if (frontCmVO.getSearchName2() == null || frontCmVO.getSearchName2().isEmpty()) {
            frontCmVO.setSearchName2("D");
        }
        if (frontCmVO.getSearchName3() == null || frontCmVO.getSearchName3().isEmpty()) {
            frontCmVO.setSearchName3("ALL");
        }

        FrontCmVO popularList = frontRecommendService.popularList(frontCmVO);
        model.addObject("chooseCmList", popularList.getResultList());
        model.addObject("paging", popularList);

        FrontCmVO bestPopularList = frontRecommendService.bestPopularList(frontCmVO);
        model.addObject("bestCmList", bestPopularList.getResultList());

        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);

        // 카테고리 시작 — WWW CategoryController 로직 이식 (hm_02와 동일 패턴)
        List<String> availableTypes = frontRecommendService.selectAvailableCategoryTypes(frontCmVO);

        if (availableTypes == null || availableTypes.isEmpty()) {
            model.addObject("hasEbook", false);
            model.addObject("hasAudio", false);
            model.addObject("hasAll", false);
            model.addObject("categoryMainList", List.of());
            model.addObject("categorySubList", List.of());
            model.addObject("selectedRowIndex", -1);
            model.setViewName("home/hm_03");
            return model;
        }

        boolean hasEbook = availableTypes.contains("E");
        boolean hasAudio = availableTypes.contains("A");
        boolean hasAll   = hasEbook || hasAudio;

        model.addObject("hasEbook", hasEbook);
        model.addObject("hasAudio", hasAudio);
        model.addObject("hasAll", hasAll);

        String categoryText = "";
        String selectedMainCategroy = "";
        String selectedSubCategroy = "";
        List<FrontCmVO> categoryMainList = new ArrayList<>();
        List<FrontCmVO> categorySubList = new ArrayList<>();
        int selectedRowIndex = -1;

        if (frontCmVO.getUct_type() != null && !frontCmVO.getUct_type().isEmpty()) {
            if ("E".equals(frontCmVO.getUct_type())) categoryText = "eBook";
            if ("A".equals(frontCmVO.getUct_type())) categoryText = "오디오북";
            FrontCmVO mainAllVO = new FrontCmVO();
            mainAllVO.setUct_code("");
            mainAllVO.setUct_name("전체");
            mainAllVO.setUct_depth(0);
            mainAllVO.setUct_parent(null);
            mainAllVO.setUct_type(frontCmVO.getUct_type());
            categoryMainList.add(mainAllVO);

            FrontCmVO subAllVO = new FrontCmVO();
            subAllVO.setUct_code(frontCmVO.getUct_parent());
            subAllVO.setUct_name("전체");
            subAllVO.setUct_depth(1);
            subAllVO.setUct_parent(frontCmVO.getUct_parent());
            subAllVO.setUct_type(frontCmVO.getUct_type());
            categorySubList.add(subAllVO);

            List<FrontCmVO> resultList = frontRecommendService.selectCategoryListV2(frontCmVO);
            if (resultList != null) {
                for (FrontCmVO vo : resultList) {
                    if (vo.getUct_depth() == 0) {
                        categoryMainList.add(vo);
                        if (vo.getUct_code().equals(frontCmVO.getUct_parent())) {
                            selectedMainCategroy = vo.getUct_name();
                        }
                    } else if (vo.getUct_depth() == 1) {
                        categorySubList.add(vo);
                        if (vo.getUct_code().equals(frontCmVO.getUct_code())) {
                            selectedSubCategroy = vo.getUct_name();
                        }
                    }
                }
            }

            if (frontCmVO.getUct_code() != null && !frontCmVO.getUct_code().isEmpty()
                    && frontCmVO.getUct_parent() != null && !frontCmVO.getUct_parent().isEmpty()) {
                for (int i = 0; i < categoryMainList.size(); i++) {
                    if (frontCmVO.getUct_parent().equals(categoryMainList.get(i).getUct_code())) {
                        selectedRowIndex = i / 8;
                        break;
                    }
                }
            }
        } else {
            categoryText = "전체";
        }

        model.addObject("selectedRowIndex", selectedRowIndex);
        model.addObject("categoryMainList", categoryMainList);
        model.addObject("categorySubList", categorySubList);
        model.addObject("categoryText", categoryText);
        model.addObject("selectedMainCategroy", selectedMainCategroy);
        model.addObject("selectedSubCategroy", selectedSubCategroy);
        model.setViewName("home/hm_03");

        return model;
    }

    @RequestMapping(value = "/front/home/searchList.do")
    public ModelAndView searchList(HttpServletRequest request, FrontCmVO frontCmVO) {

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

        FrontCmVO bookList = frontRecommendService.bookSearchList(frontCmVO);
        model.addObject("BookList", bookList.getResultList());
        model.addObject("BookPaging", bookList);
        model.addObject("frontCmVO", frontCmVO);
        model.addObject("searchVO", frontCmVO);
        model.addObject("categoryList", List.of());

        // 검색 결과 없을 때 실시간 인기 도서 표시용 (WWW 동일: limit_count=10, 검색결과 없을 때만)
        if (bookList == null || bookList.getResultList() == null || bookList.getResultList().isEmpty()) {
            frontCmVO.setLimit_count(10);
            List<FrontCmVO> searchPopularList = frontRecommendService.searchPopularList(frontCmVO);
            model.addObject("searchPopularList", searchPopularList);
        }

        FrontCmVO categoryTypeVO = new FrontCmVO();
        categoryTypeVO.setType_result("TYPEALL");
        model.addObject("cmVO", categoryTypeVO);

        model.setViewName("sh/sh_04");
        return model;
    }

    @RequestMapping(value = "/front/home/bookDetail.do")
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
        if (resultVO.getUcm_intro_img_url() != null && !resultVO.getUcm_intro_img_url().isEmpty()) {
            resultVO.setUcm_intro_img_url(resultVO.getUcm_intro_img_url().replaceAll(" ", ""));
            introList = resultVO.getUcm_intro_img_url().trim().split(",");
        }

        List<FrontEventVO> resultEventVO = frontRecommendService.bookDetailEvent(cmVO);
        FrontRecommendVO ormRecommendVO = frontRecommendService.bookDetailCuration(cmVO);

        model.addObject("cmVO", resultVO);
        model.addObject("seriesList", resultVO.getSeriesList());
        model.addObject("popularList", resultVO.getPopular());
        model.addObject("introList", introList);
        model.addObject("eventList", resultEventVO);
        model.addObject("curation", ormRecommendVO == null ? List.of() : ormRecommendVO.getGroupList());

        model.setViewName("home/hm_05");
        return model;
    }

    @RequestMapping(value = "/front/home/companyInfo.do")
    public ModelAndView companyInfo() {
        ModelAndView model = new ModelAndView();
        model.setViewName("ft/ft_01");
        return model;
    }

    @RequestMapping(value = "/front/home/noticeList.do")
    public ModelAndView noticeList(HttpServletRequest request, FrontCmVO frontCmVO) {
        ModelAndView model = new ModelAndView();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        frontCmVO.setUis_code(uisCode);

        FrontCmVO noticeList = frontRecommendService.noticeList(frontCmVO);
        model.addObject("noticeList", noticeList.getResultList());
        model.addObject("paging", noticeList);
        model.setViewName("ft/ft_02");
        return model;
    }

    @RequestMapping(value = "/front/home/tosInfo.do")
    public ModelAndView tosInfo(HttpServletRequest request, FrontCmVO frontCmVO) {
        ModelAndView model = new ModelAndView();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        frontCmVO.setUis_code(uisCode);

        FrontCmVO tosVO = frontRecommendService.tosInfo(frontCmVO);
        model.addObject("tosVO", tosVO);
        model.setViewName("ft/ft_03");
        return model;
    }

    @RequestMapping(value = "/front/home/policyInfo.do")
    public ModelAndView policyInfo(HttpServletRequest request, FrontCmVO frontCmVO) {
        ModelAndView model = new ModelAndView();
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");
        frontCmVO.setUis_code(uisCode);

        FrontCmVO policyVO = frontRecommendService.policyInfo(frontCmVO);
        model.addObject("policyVO", policyVO);
        model.setViewName("ft/ft_04");
        return model;
    }

    private boolean isMobile(HttpServletRequest request, String searchMobileYn) {
        if ("Y".equals(searchMobileYn)) return true;
        if ("N".equals(searchMobileYn)) return false;
        String target = life.bks.zone.util.CommonUtil.browerCheck(request.getHeader("User-Agent"));
        return org.apache.commons.lang3.StringUtils.isNotEmpty(target)
                && ("iPhone".equals(target) || "Android".equals(target) || "else model".equals(target));
    }
}
