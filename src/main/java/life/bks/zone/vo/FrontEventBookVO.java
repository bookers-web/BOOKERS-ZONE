package life.bks.zone.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FrontEventBookVO extends SearchVO {

	private String uis_code = "";    		// 기관 코드
    private String uem_code = "";    		// 이벤트 코드
    private String ucm_code = "";			// 콘텐츠 코드 
    private String ucm_ebook_isbn = "";		// isbn
    private String ucm_file_type = "";		// 파일타입 
    private String ucm_title = "";			// 책제목 
    private String ucm_sub_title = "";		// 책서브제목 
    private String ucm_ucp_code = "";		// CP 코드 
    private String ucm_writer = "";			// 저자 
    private String ucm_cover_url = "";		// 썸네일 
    private String ucm_publisher = "";		// 출판사 
    private String ucm_limit_age = "";		// 19 
    private String um_code = "";			// 회원 코드 
    private int ume_finishread_count = 0;	// 이벤트도서 완독 여부 
    private String ubr_code = "";			// 독서감상문 코드 
    
    private String uis_return_flag = "N";	// 특정콘텐츠게시형 
    
}
