package life.bks.zone.controller;

import jakarta.servlet.http.HttpServletRequest;
import life.bks.zone.dto.WebviewerResponse;
import life.bks.zone.service.webviewer.WebviewerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/front/myLibrary")
public class WebviewerController {

    private final WebviewerService webviewerService;

    @RequestMapping(value = "/webViewer.json")
    @ResponseBody
    public WebviewerResponse webviewerDetail(
            @RequestParam String ucm_code,
            @RequestParam String ume_code,
            HttpServletRequest request) {

        String umCode = (String) request.getSession().getAttribute("UM_CODE");
        String uisCode = (String) request.getSession().getAttribute("UM_UIS_CODE");

        if (umCode == null || umCode.isEmpty()) {
            return WebviewerResponse.builder()
                    .count(-1)
                    .resultMsg("로그인 후 이용가능합니다.")
                    .build();
        }

        return webviewerService.processWebviewer(ucm_code, ume_code, umCode, uisCode);
    }
}
