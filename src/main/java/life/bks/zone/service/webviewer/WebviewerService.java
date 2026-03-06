package life.bks.zone.service.webviewer;

import life.bks.zone.dto.WebviewerResponse;

public interface WebviewerService {
    WebviewerResponse processWebviewer(String ucmCode, String umeCode, String umCode, String uisCode);
}
