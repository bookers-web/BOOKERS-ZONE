package life.bks.zone.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FrontEventVO extends SearchVO {
    private String um_code = "";
    private String uis_code = "";
    private String uem_code = "";
    private String uemc_code = "";
    private String uem_uis_code = "";
    private String um_userid = "";
    private String uemc_um_code = "";
    private String uemc_um_userid = "";
    private String uem_type = "";
    private String uem_title = "";
    private String uem_thumbnail_image = "";
    private String uem_web_detail_image = "";
    private String uem_mobile_detail_image = "";
    private String uem_mobile_notice_image = "";
    private String uis_company_flag = "";
    private String uem_a_web_detail_image = "";
    private String uem_a_mobile_detail_image = "";
    private String uem_web_notice_image = "";
    private String uem_url = "";
    private String uem_display_startdate = "";
    private String uem_display_enddate = "";
    private String uem_uis_userid = "";
    private String uem_useyn = "Y";
    private int uem_display_number = 0;
    private String uem_regdate = "";
    private String uemc_regdate = "";
    private int date_diff = 0;
    private String mobileYn = "N";
    private String type = "";
    private String myComment = "N";
    private int existUis = 0;
    private String uemc_comment = "";
    private String uemc_apply_yn = "N";
    private String uemc_um_phone;
    private String uemc_um_name;
    private List<FrontEventVO> validEventList;
    private List<FrontEventVO> endEventList;
    private String uem_web_button = "";
    private String uem_mobile_button = "";
    private String uem_book_yn = "N";
    private String uem_book_link = "D";
}
