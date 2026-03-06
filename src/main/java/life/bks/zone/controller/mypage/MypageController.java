package life.bks.zone.controller.mypage;

import jakarta.servlet.http.HttpServletRequest;
import life.bks.zone.service.mypage.FrontMypageService;
import life.bks.zone.vo.FrontCmVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "/front")
public class MypageController {

	@Autowired
	private FrontMypageService frontMypageService;

	@RequestMapping(value = "/mypage/faqList.do")
	public ModelAndView faqList(HttpServletRequest request, ModelAndView model, FrontCmVO frontCmVO) {

		frontCmVO.setUm_name((String) request.getSession().getAttribute("UM_NAME"));

		FrontCmVO resultVO = frontMypageService.faqList(frontCmVO);

		model.addObject("faqVO", resultVO.getResultList());
		model.addObject("paging", resultVO);
		model.addObject("searchVO", frontCmVO);
		model.setViewName("my/my_03");

		return model;
	}
}
