<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
	// 툴팁 닫기 버튼
	$(".pop_close").on("click", function() {
		$(this).closest(".LR_toolTip").hide();
	});	
	// 독서라운지 독서감상문 리스트 도서 커버 클릭시 해당 도서 독서감상문 리스트 상세로 이동
	$(".LR_commentThumb img.cover").on("click", function() {
		
		var frm = $("#frm");
		
		if($("#selectUcdCode").length > 0 ){
			$("#selectUcdCode").val($(this).parent().attr("id") )
		}
		else {
			frm.append('<input type="hidden" id="selectUcdCode" name="ucd_code" value="' + $(this).parent().attr("id")  +'">');
		}
		
		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("ucm_code"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("ucm_code") +'">');
		}
		
		$("#frm").attr("action","/front/lounge/discussionView.do");
		
		frm.submit();
	});
	
});
var oldAction = ""

	function page(pagenum) {
		var contentnum = $("#pageSize option:selected").val();
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

</script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
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
		<nav id="snb">
			<ul class="snb_list">
				<li>
					<a href="/front/lounge/main.do">독서감상문</a>
				</li>
				<li>
					<a href="/front/lounge/discussion.do" class="nav_focus">독서토론</a>
				</li>
			</ul>
		</nav>
		<hr/>
	</div>
	<div id="container">
		<div class="content">
			<c:choose>
			<c:when test="${empty list and empty searchVO.searchKey}">
			<!--독서감상문 없는 경우-->
			<div class="LibNot" style="display:block;">
				<img src="/images/img_nodata_book.png" alt="데이터가 없는 책" /><!-- 수정 date 04.29 -->
				<div class="LibNot_txt2">아직 토론할 수 있는 책이 없어요.</div><!-- 클래스 추가 04.29 -->
				<div class="LibNot_txt">추천도서의 독서토론을 시작하면<br/>여기에 보여집니다.</div><!-- 클래스 추가 04.29 -->
			</div>
			</c:when>
			<c:otherwise>
			<!--독서감상문 있는 경우-->
			<div class="LR_toolTip">
				<span>${frontCmVO.uis_name }</span>의 콘텐츠를 이용하고<img class="pop_close" src="/images/icon_tooltip_close.png" alt="" /><br/>
				토론할 수 있는 공간입니다.
			</div>
			<div class="contentsYes">
				<form name="frm" id="frm" action="/front/lounge/discussion.do" method="post" accept-charset="UTF-8">
					<div class="reportSearch_input">
						<input type="text" id="searchKey" name="searchKey" value="${searchVO.searchKey }" class="search_report" placeholder="독서토론 콘텐츠 검색">
						<button type="submit" class="report_search"><img src="/images/icon_search_bl.png" alt="" /></button><!-- 이미지 변경04.29 -->
					</div>
				</form>
				<c:choose>
				<c:when test="${empty searchVO.searchKey and searchVO.searchKey eq '' }">
				<div class="reportYes_list"><!--독서토론 있는 도서 리스트-->
					<div class="optionMenu_area mT_30">
						<div class="totalNum">총 <span class="txt_primary_c"><fmt:formatNumber value="${paging.totalCount }" pattern="#,###" /></span>권</div><!-- span 클래스 추가 04.29 -->
					</div>
					<ul class="LR_commentThumb">
						<c:forEach items="${list }" var="list" >
						<li>
							<div class="bookCover">
								<div class="book" id="${list.ucd_code }" ucm_code="${list.ucm_code }">
									<!-- 19금 도서 노출 유무 -->
									<c:if test="${list.ucm_limit_age eq 'R' }">
									<img class="badge_adult" src="/images/icon_adult.png" alt="" />
									</c:if>
									<!-- 파일 형태 -->
									<c:choose>
									<c:when test='${list.ucm_file_type eq "PDF" }'>
									<img class="book_badge" src="/images/icon_pdf.png" alt="" />
									</c:when>
									<c:when test='${list.ucm_file_type eq "ZIP" or list.ucm_file_type eq "COMIC" }'>
									<img class="book_badge" src="/images/icon_comic.png" alt="" />
									</c:when>
									<c:when test='${list.ucm_file_type eq "AUDIO" }'>
									<img class="book_badge" src="/images/icon_audiobook.png" alt="" />
									</c:when>
									<c:otherwise>
									</c:otherwise>
									</c:choose>
									<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt=""/>
								</div>
							</div>
							<div class="LR_bookTitle">${list.ucm_title }</div>
							<div class="LR_Subtitle">${list.ucm_sub_title }</div>
							<div class="LR_authorName">${list.ucm_writer }</div>
							<div class="LR_publisher">${list.ucp_brand }</div>
						</li>
						</c:forEach>
					</ul>
					<div style="clear:both;"></div>
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
				</c:when>
				<c:otherwise>
					<c:choose>
					<c:when test="${empty list }">
					<!--검색 결과 없는 경우-->
					<div class="searchNot" style="display:block;">
						<img src="/images/img_search.png" alt="" />
						<div><span>${searchVO.searchKey }</span>에 대한 검색 결과가 없습니다.</div>
					</div>
					</c:when>
					<c:otherwise>
					<div class="searchYes" style="display:block;"><!--검색 결과 있는 경우-->
						<div class="optionMenu_area mT_30">
							<div class="totalNum">총 <span class="txt_primary_c"><fmt:formatNumber value="${paging.totalCount }" pattern="#,###" /></span>권</div>
						</div>
						<ul class="LR_commentThumb">
							<c:forEach items="${list }" var="list" >
							<li>
								<div class="bookCover">
									<div class="book" id="${list.ucd_code }" ucm_code="${list.ucm_code }">
										<!-- 19금 도서 노출 유무 -->
										<c:if test="${list.ucm_limit_age eq 'R' }">
										<img class="badge_adult" src="/images/icon_adult.png" alt="" />
										</c:if>
										<!-- 파일 형태 -->
										<c:choose>
										<c:when test='${list.ucm_file_type eq "PDF" }'>
										<img class="book_badge" src="/images/icon_pdf.png" alt="" />
										</c:when>
										<c:when test='${list.ucm_file_type eq "ZIP" or list.ucm_file_type eq "COMIC" }'>
										<img class="book_badge" src="/images/icon_comic.png" alt="" />
										</c:when>
										<c:when test='${list.ucm_file_type eq "AUDIO" }'>
										<img class="book_badge" src="/images/icon_audiobook.png" alt="" />
										</c:when>
										<c:otherwise>
										</c:otherwise>
										</c:choose>
										<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt=""/>
									</div>
								</div>
								<div class="LR_bookTitle">${list.ucm_title }</div>
								<div class="LR_Subtitle">${list.ucm_sub_title }</div>
								<div class="LR_authorName">${list.ucm_writer }</div>
								<div class="LR_publisher">${list.ucp_brand }</div>
							</li>
							</c:forEach>
						</ul>
						<div style="clear:both;"></div>
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
					</c:otherwise>
					</c:choose>
				</c:otherwise>
				</c:choose>
			</div>
			</c:otherwise>
			</c:choose>
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>
</body>
</html>