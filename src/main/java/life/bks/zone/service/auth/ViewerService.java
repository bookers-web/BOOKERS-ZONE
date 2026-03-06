package life.bks.zone.service.auth;

import life.bks.zone.dto.ViewerRedirectResponse;

public interface ViewerService {
    
    ViewerRedirectResponse getViewerUrl(String sessionId, String bookId);
}
