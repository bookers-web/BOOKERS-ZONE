package life.bks.zone.controller.auth;

import life.bks.zone.dto.ApiResponse;
import life.bks.zone.dto.ViewerRedirectResponse;
import life.bks.zone.service.auth.ViewerService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/guest")
@RequiredArgsConstructor
public class GuestLoginController {

    private final ViewerService viewerService;

    @PostMapping("/viewer")
    public ApiResponse<ViewerRedirectResponse> getViewerUrl(
            @RequestParam String sessionId,
            @RequestParam String bookId) {

        ViewerRedirectResponse response = viewerService.getViewerUrl(sessionId, bookId);

        if (response.isSuccess()) {
            return ApiResponse.ok(response);
        } else {
            return ApiResponse.fail(response.getMessage(), response.getErrorCode());
        }
    }
}
