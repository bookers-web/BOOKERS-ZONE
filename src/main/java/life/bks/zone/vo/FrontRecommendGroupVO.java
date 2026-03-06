package life.bks.zone.vo;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

public class FrontRecommendGroupVO extends SearchVO {
	
	// 추천도서 관련
	@Setter @Getter private String uil_code					= "";	// 기관  추천 서재 코드
	@Setter @Getter private String uil_name					= "";	// 추천 서재명
	@Setter @Getter private int book_count					= 0;	// 추천 도서 수
	@Setter @Getter private String uis_use_adult_book		= "";	// 19금 도서 노출 유무
	@Setter @Getter private String search_uis_copy_book_flag		= "";	// 19금 도서 노출 유무
	
	@Setter @Getter private List<CmVO> bookList;					// 도서 리스트
}
