package life.bks.zone.controller;

import life.bks.zone.domain.ZoneConfig;
import life.bks.zone.domain.InstitutionInfo;
import life.bks.zone.mapper.InstitutionMapper;
import life.bks.zone.dto.SessionCreateResponse;
import life.bks.zone.service.auth.IpAuthService;
import life.bks.zone.service.member.MemberService;
import life.bks.zone.util.IpUtils;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequiredArgsConstructor
public class PageController {

    @Value("${zone.session.cookie-name}")
    private String sessionCookieName;

    @Value("${zone.session.cookie-max-age}")
    private int cookieMaxAge;

    private final IpAuthService ipAuthService;
    private final MemberService memberService;
    private final InstitutionMapper institutionMapper;

    /**
     * 랜딩 페이지 (로그인 선택 화면)
     * - maxConcurrent 값을 JSP에 전달
     */
    @GetMapping({"/", "/login"})
    public ModelAndView loginPage(HttpServletRequest request) {
        ModelAndView model = new ModelAndView("login");

        String clientIp = IpUtils.getClientIp(request);
        ZoneConfig config = ipAuthService.findConfigByIp(clientIp);

        if (config != null) {
            model.addObject("maxConcurrent", config.getMaxConcurrent());
            model.addObject("uisCode", config.getUisCode());
            model.addObject("uisName", config.getUisName());
        } else {
            model.addObject("maxConcurrent", 0);
        }

        return model;
    }

    /**
     * 비회원 관내 이용자 진입
     * - IP 기반 세션 생성 → 쿠키 설정 → 홈으로 리다이렉트
     * - 동시접속 초과 시 랜딩 페이지로 돌려보냄
     */
    @GetMapping("/zone/enter")
    public String zoneEnter(HttpServletRequest request, HttpServletResponse response) {
        String clientIp = IpUtils.getClientIp(request);
        String userAgent = request.getHeader("User-Agent");

        ZoneConfig config = ipAuthService.findConfigByIp(clientIp);
        if (config == null) {
            log.warn("IP 인증 실패 - 허용되지 않은 IP: {}", clientIp);
            return "redirect:https://www.bookers.life/";
        }

        SessionCreateResponse result = ipAuthService.createSession(
                config.getUisCode(), clientIp, userAgent);

        if (!result.isSuccess()) {
            log.info("세션 생성 실패 - IP: {}, 사유: {}", clientIp, result.getMessage());
            return "redirect:/login?error=max_concurrent";
        }

        // 세션 쿠키 설정
        Cookie sessionCookie = new Cookie(sessionCookieName, result.getSessionId());
        sessionCookie.setPath("/");
        sessionCookie.setHttpOnly(true);
        sessionCookie.setMaxAge(cookieMaxAge);
        response.addCookie(sessionCookie);

        // HttpSession에 기관 정보 저장 (레거시 컨트롤러에서 사용)
        HttpSession httpSession = request.getSession();
        httpSession.setAttribute("UM_UIS_CODE", config.getUisCode());
        httpSession.setAttribute("UIS_UCP_CODE", memberService.selectUcpCode(config.getUisCode()));
        httpSession.setAttribute("ZONE_SESSION_ID", result.getSessionId());
        httpSession.setAttribute("UM_CODE", result.getUmCode());

        // 기관 상세 정보 세션 저장 (JSP에서 참조)
        InstitutionInfo institutionInfo = institutionMapper.selectByUisCode(config.getUisCode());
        if (institutionInfo != null) {
            httpSession.setAttribute("UIS_RETURN_FLAG", institutionInfo.getUisReturnFlag());
            httpSession.setAttribute("UIS_RETURN_UI_FLAG", institutionInfo.getUisReturnUiFlag());
            httpSession.setAttribute("UIS_KEYCOLOR", institutionInfo.getUisKeycolor());
            httpSession.setAttribute("UIS_WEB_LOGO_URL", institutionInfo.getUisWebLogoUrl());
            httpSession.setAttribute("UIS_PREVIEW_FLAG", institutionInfo.getUisPreviewFlag());
            httpSession.setAttribute("UIS_NAME", institutionInfo.getUisName());
        }

        log.info("비회원 진입 성공 - IP: {}, sessionId: {}, 기관: {}, umCode: {}",
                clientIp, result.getSessionId(), config.getUisName(), result.getUmCode());

        // IP 인증 로그
        ipAuthService.logAction(result.getSessionId(), config.getUisCode(),
                clientIp, "ENTER", null);

        return "redirect:/front/home/main.do";
    }
}
