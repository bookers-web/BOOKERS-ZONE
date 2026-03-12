<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="filePath" value="https://files.bookers.life" />
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	 if (self.name != 'reload') {
         self.name = 'reload';
         self.location.reload(true);
     }
     else self.name = ''; 
	oldAction = $("#frm").attr("action")
	
	$(".anonymousId").each(function(){
			var maskingStr;
			var originStr = $(this).html();
			var strLength = originStr.length;
			
			maskingStr = originStr.substring(0,2);
			for(var i=0; i< strLength; i++){
				maskingStr += '*';
			}
			$(this).html(maskingStr);
		});
	// 정렬 방식 변경 시
	$("#sortField").on('change', function() {
		var frm = $("#frm");
		
		$("#sortField1").val($("#sortField").val());
		
		$("#frm").attr("action", oldAction)
		frm.submit();
	});
	
	// 도서 이미지 클릭 시
	$(".book img.cover").on("click", function() {
		
		var frm = $("#frm");
		
		if($("#selectUcsCode").length > 0 ){
			$("#selectUcsCode").val($(this).parent().attr("ucm_ucs_code"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcsCode" name="ucm_ucs_code" value="' + $(this).parent().attr("ucm_ucs_code") +'">');
		}
		
		$("#frm").attr("action","/front/home/bookDetail.do");
		
		frm.submit();
	});
	
	// 썸네일형 도서리스트 커버 영역 감싸고 상세 페이지 링크 연결
	$(".reportList img.cover").on("click", function() {
		
		var frm = $("#frm");
		$("#ubr_code").val($(this).parent().attr("id"));
		
		// Zone에서는 내서재 접근 불가 — 상세보기로 이동
		$("#frm").attr("action","/front/lounge/detailView.do");
		
		frm.submit();
	});
	
	$(".reportTitle, .btn_newWindow, .reportBody_txt").on("click", function() {
		var frm = $("#frm");
		$("#ubr_code").val($(this).parent().parent().attr("id"));
		
		frm.attr("action","/front/lounge/detailView.do");
		
		frm.append('<input type="hidden" id="ubr_flag" name="ubr_flag" value="A">');
		frm.submit();
	});
	
	// 독서감상문 좋아요 버튼(빈 하트일 경우). 타인의 독서감상문 좋아요 하기
	$(".like_off").on("click", function() {
		var like_off = $(this).attr("id");
		var ubr_code = $(this).attr("id").split("_")[2];
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/lounge/bookReportCommentStateService.json",
			data: {"ubrc_code" : '', "ubrc_ubr_code": ubr_code },
			dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async : false,
			success: function( data ) {
				if(data.count == -1){
					alert(data.resultMsg);
					var url = '/login';
					location.replace(url);
				} else if(data.count > 0 ){
					$("#"+like_off).css("display","none");
					$("#"+like_on).css("display","inline-block");
					var Like=$("#count_"+ubr_code).text();
					var LikeNum=parseInt(Like);
					$("#count_"+ubr_code).text(LikeNum+1);
					
					$("#ubrc_code_"+ubr_code).val(data.resultMsg);
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
		
		
	});
	// 독서감상문 좋아요 취소(채워진 하트일 경우). 타인의 독서감상문 좋아요 취소하기
	$(".like_on").on("click", function() {
		var ubr_code = $(this).attr("id").split("_")[2];
		var like_off = "like_off_"+ubr_code;
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/lounge/bookReportCommentStateService.json",
			data: {"ubrc_code" : $("#ubrc_code_"+ubr_code).val(), "ubrc_ubr_code": ubr_code },
			dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async : false,
			success: function( data ) {
				if(data.count == -1){
					alert(data.resultMsg);
					var url = '/login';
					location.replace(url);
				} else if(data.count > 0 ){
					$("#"+like_on).css("display","none");
					$("#"+like_off).css("display","inline-block");
					var Like=$("#count_"+ubr_code).text();
					var LikeNum=parseInt(Like);
					$("#count_"+ubr_code).text(LikeNum-1);
					$("#ubrc_code").val("");
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
		
		
	});
});

/*한페이지당 게시물 */

var oldAction = ""

function page(pagenum) {
	var frm = $("#frm");

	if($("#pagenum").length > 0 ){
		$("#pagenum").val(pagenum)
	}
	else {
		frm.append('<input type="hidden" id="pagenum" name="pagenum" value="' + pagenum +'">');
	}

	$("#frm").attr("action", oldAction)
	frm.submit();
}

function fn_only_agency_view(event) {
	var frm = $("#frm");
	frm.append('<input type="hidden" id="ubr_flag" name="ubr_flag" value="I">');
	frm.attr("action","/front/lounge/view.do");
	
	frm.submit();
}

function fn_all_view(event) {
	var frm = $("#frm");
	frm.append('<input type="hidden" id="ubr_flag" name="ubr_flag" value="A">');
	frm.attr("action","/front/lounge/view.do");
	
	frm.submit();
}

</script>
</head>
<body>

<div id="wrap">
	<div id="header">
		<div class="top">
			<%@ include file="/WEB-INF/views/common/logo.jsp" %>
			<%@ include file="/WEB-INF/views/common/gnb.jsp" %>
			<div class="header-side">
				<div class="search_input">
					<form name="searchForm" id="searchForm" action="/front/home/searchList.do" method="post" accept-charset="UTF-8">
						<input type="text" onKeyDown="javascript:if(event.keyCode == 13){fn_go_search_page(); return false;}" class="searchWord" id="searchName" name="searchName" value="${searchVO.searchName }" placeholder="제목, 저자 , 출판사 검색" title="도서 검색">
						<button type="button" class="search" onClick="javascript:fn_go_search_page();return false;"><img src="/images/v2/icon/icon_search_black.svg" alt="" /></button>
					</form>
				</div>
				<div class="myInfo">
					<a href="/front/mypage/faqList.do"><img src="/images/v2/icon/icon_faq.svg" alt=""/></a>
				</div>
			</div>
		</div>
		<hr/>
		<div class="reportDetail">
			<a href="/front/lounge/main.do"><img src="/images/icon_back.png" alt="" /></a>
			<span>독서감상문</span>
		</div>
		<hr/>
	</div>
	<div id="container">
		<form name="frm" id="frm" action="/front/lounge/view.do" method="post">
			<input type="hidden" id="ucm_code"		name="ucm_code"		value="${searchVO.ucm_code }" />
			<input type="hidden" id="ubr_code"		name="ubr_code"		value="${searchVO.ubr_code }" />
			<input type="hidden" id="um_code"		name="um_code"		value="${searchVO.um_code }" />
			<input type="hidden" id="sortField1"	name="sortField1"	value="${searchVO.sortField1 }" />

		</form>
		<div class="content">
			<div class="contentsYes">
				<div class="rDetail_bookInfo mT_15">
					<div class="coverArea">
						<div class="book" id="${cmVO.ucm_code }">
							<!-- 19금 도서 노출 유무 -->
							<c:if test="${cmVO.ucm_limit_age eq 'R' }">
							<img class="badge_adult" src="/images/icon_adult.png" alt="" />
							</c:if>
							
							<!-- 파일 형태 -->
							<c:choose>
							<c:when test='${cmVO.ucm_file_type eq "PDF" }'>
							<img class="book_badge" src="/images/icon_pdf.png" alt="" />
							</c:when>
							<c:when test='${cmVO.ucm_file_type eq "ZIP" or cmVO.ucm_file_type eq "COMIC" }'>
							<img class="book_badge" src="/images/icon_comic.png" alt="" />
							</c:when>
							<c:when test='${cmVO.ucm_file_type eq "AUDIO" }'>
							<img class="book_badge" src="/images/icon_audiobook.png" alt="" />
							</c:when>
							<c:otherwise>
							
							</c:otherwise>
							</c:choose>
							
							<!-- 표지 이미지 -->
							<c:choose>
							<c:when test="${empty cmVO.ucm_cover_url }">
							
								<c:choose>
								<c:when test='${cmVO.uis_ucp_code eq sessionScope.UIS_UCP_CODE }'>
								<img class="cover" src="/images/img_coverNot.png" alt="" />
								</c:when>
								<c:otherwise>
								<img class="cover2" src="/images/img_coverNot.png" alt="" />
								</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
								<c:when test='${cmVO.uis_ucp_code eq sessionScope.UIS_UCP_CODE }'>
								<img class="cover" src="${filePath}${cmVO.ucm_cover_url }" alt="" />
								</c:when>
								<c:otherwise>
								<img class="cover2" src="${filePath}${cmVO.ucm_cover_url }" alt="" />
								</c:otherwise>
								</c:choose>
								
							</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="info_bookTitle">${cmVO.ucm_title }</div>
					<c:if test="${not empty cmVO.ucm_sub_title and cmVO.ucm_sub_title ne '' }"><div class="bookSubtitle">${cmVO.ucm_sub_title }</div></c:if>
					<div class="authorName">${cmVO.ucm_writer }</div>
					<div class="publisher">${cmVO.ucp_brand }</div>
				</div>
				<div class="optionMenu_area mT_15">
					<div class="totalNum">총 <span class="txt_primary_c"><fmt:formatNumber value="${paging.totalCount }" pattern="#,###" /></span> 건</div>
					<div style="margin-top: 9px; float:right; display:none;">
						<button class="report_btn_all" onclick="javascript:fn_all_view('${searchVO.um_code}','${searchVO.ucm_code}');">전체 보기</button>
						<button class="report_btn_agency" onclick="javascript:fn_only_agency_view('${searchVO.um_code}','${searchVO.ucm_code}');">내 소속기관 보기</button>
						<!-- Zone(비회원)에서는 내 감상문 보기 비활성화 -->
					</div>
				</div>
				<div class="LR_reportList">
					<ul>
						<c:forEach items="${list }" var="list">
						<li id="${list.ubr_code }">
							<div class="report_Box myR">
								<!-- Zone(비회원): 수정/삭제/공개설정 버튼 숨김 -->
									<c:if test="${list.ubr_is_open eq 'Y' }">
										<div class="clear markBox"><span class="mark_all">모든 기관 공개</span></div>
									</c:if>
									<c:if test="${list.ubr_is_open eq 'N' }">
										<div class="clear markBox"><span class="mark_agency">소속 기관 공개</span></div>
									</c:if>
									<div class="reportTitle">${list.ubr_title } <div class="btn_newWindow" ></div></div>
									<div class="reportDate"><div class="anonymousId">${list.um_userid }</div>${fn:split(list.ubr_regdate, ' ')[0].replace('-','.') }</div>
									
									<div class="reportBody_txt">${list.ubr_content }</div>
									<div class="report_Unfold">더보기</div>
									<div class="float_L reportBody_footer">
										<div class="LR_likeCount">
											
											<c:choose>
											<c:when test="${list.ubrc_type eq 'Y' }">
											<input type="hidden" id="ubrc_code_${list.ubr_code }" value="${list.ubrc_code }" />
											<span class="like_on" id="like_on_${list.ubr_code }" style="display:inline-block;"><img src="/images/icon_favorite_on.png" alt="" /><span class="like_txt"> 좋아요</span></span>
											<span class="like_off" id="like_off_${list.ubr_code }" style="display:none;"><img src="/images/icon_favorite_off.png" alt="" /><span class="like_txt"> 좋아요</span></span>
											</c:when>
											<c:otherwise>
											<input type="hidden" id="ubrc_code_${list.ubr_code }" />
											<span class="like_off" id="like_off_${list.ubr_code }"><img src="/images/icon_favorite_off.png" alt="" /><span class="like_txt"> 좋아요</span></span>
											<span class="like_on" id="like_on_${list.ubr_code }"><span class="like_txt"><img src="/images/icon_favorite_on.png" alt="" /> 좋아요</span></span>
											</c:otherwise>
											</c:choose>
											<span class="likeCount" id="count_${list.ubr_code }"><fmt:formatNumber value="${list.ubr_like }" pattern="#,###" /></span>
										</div>
									</div>
							</div>
						</li>
						</c:forEach>
					</ul>
				</div>
				<div class="page_pn">
					<ul>
						<c:if test="${not empty list }">
							<c:if test="${paging.prev}">
								<li><a href="javascript:page(1);"><img src="/images/icon_page_first.png" alt="첫페이지" /></a></li>
								<li><a href="javascript:page(${paging.getStartPage()-10});"><img src="/images/icon_page_prev.png" alt="이전페이지" /></a></li>
							</c:if>
							<c:forEach begin="${paging.getStartPage()}" end="${paging.getEndPage()}" var="idx">
								<li class="n <c:if test='${paging.pagenum eq idx}'>LNB_focus</c:if>"><a href="javascript:page(${idx});">${idx}</a></li>
							</c:forEach>
							<c:if test="${paging.next}">
								<li><a href="javascript:page(${paging.getEndPage()+1});"><img src="/images/icon_page_next.png" alt="다음페이지" /></a></li>
								<li><a href="javascript:page(${paging.getTotalPage() });"><img src="/images/icon_page_end.png" alt="마지막페이지" /></a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
