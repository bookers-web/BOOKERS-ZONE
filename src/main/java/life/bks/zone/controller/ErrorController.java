package life.bks.zone.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/error")
public class ErrorController {
    
    @GetMapping("/not-authorized")
    @ResponseBody
    public String notAuthorized() {
        return """
            <!DOCTYPE html>
            <html>
            <head><meta charset="UTF-8"></head>
            <body>
            <script>
                alert('부커스 존을 사용할 수 없는 기관입니다.');
                window.history.back();
            </script>
            </body>
            </html>
            """;
    }
    
    @GetMapping("/session-full")
    @ResponseBody
    public String sessionFull() {
        return """
            <!DOCTYPE html>
            <html>
            <head><meta charset="UTF-8"></head>
            <body>
            <script>
                alert('현재 인원이 꽉차서 사용할 수 없습니다.');
                window.history.back();
            </script>
            </body>
            </html>
            """;
    }
}
