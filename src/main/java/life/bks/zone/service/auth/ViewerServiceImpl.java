package life.bks.zone.service.auth;

import life.bks.zone.domain.IpAuthSession;
import life.bks.zone.dto.ViewerRedirectResponse;
import life.bks.zone.mapper.IpAuthSessionMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class ViewerServiceImpl implements ViewerService {
    
    private final IpAuthSessionMapper sessionMapper;
    
    @Value("${app.www-base-url:https://www.bookers.life}")
    private String wwwBaseUrl;
    
    @Override
    public ViewerRedirectResponse getViewerUrl(String sessionId, String bookId) {
        
        if (sessionId == null || sessionId.isEmpty()) {
            return ViewerRedirectResponse.builder()
                    .success(false)
                    .message("세션 ID가 필요합니다.")
                    .errorCode("MISSING_SESSION_ID")
                    .build();
        }
        
        if (bookId == null || bookId.isEmpty()) {
            return ViewerRedirectResponse.builder()
                    .success(false)
                    .message("도서 ID가 필요합니다.")
                    .errorCode("MISSING_BOOK_ID")
                    .build();
        }
        
        IpAuthSession session = sessionMapper.selectById(sessionId);
        
        if (session == null) {
            return ViewerRedirectResponse.builder()
                    .success(false)
                    .message("유효하지 않은 세션입니다.")
                    .errorCode("INVALID_SESSION")
                    .build();
        }
        
        String umCode = session.getUmCode();
        String uisCode = session.getUisCode();
        
        String redirectUrl = wwwBaseUrl + "/home/loginSso.do?um_code=" + umCode + "&uis_code=" + uisCode + "&bookId=" + bookId;
        
        log.info("뷰어 리다이렉트 - sessionId: {}, bookId: {}, umCode: {}", sessionId, bookId, umCode);
        
        return ViewerRedirectResponse.builder()
                .success(true)
                .message("성공")
                .viewerUrl(redirectUrl)
                .build();
    }
}
