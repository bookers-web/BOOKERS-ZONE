package life.bks.zone.controller.auth;

import life.bks.zone.dto.ApiResponse;
import life.bks.zone.dto.GuestLoginRequest;
import life.bks.zone.dto.GuestLoginResponse;
import life.bks.zone.dto.ViewerRedirectResponse;
import life.bks.zone.service.auth.GuestLoginService;
import life.bks.zone.service.auth.ViewerService;
import life.bks.zone.util.IpUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/guest")
@RequiredArgsConstructor
public class GuestLoginController {
    
    private final GuestLoginService guestLoginService;
    private final ViewerService viewerService;
    
    @PostMapping("/login")
    public ApiResponse<GuestLoginResponse> guestLogin(
            @RequestBody GuestLoginRequest request,
            HttpServletRequest httpRequest) {
        
        String clientIp = IpUtils.getClientIp(httpRequest);
        String userAgent = httpRequest.getHeader("User-Agent");
        
        GuestLoginResponse response = guestLoginService.guestLogin(
                request.getRequestCode(),
                request.getRequestId(),
                clientIp,
                userAgent
        );
        
        if (response.isSuccess()) {
            return ApiResponse.ok(response);
        } else {
            return ApiResponse.fail(response.getMessage(), response.getErrorCode());
        }
    }
    
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
