<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
});

/*한페이지당 게시물 */
function page(pagenum) {
	var contentnum = $("#pageSize option:selected").val();
	var frm = $("#frm");

	if($("#pagenum").length > 0 ){
		$("#pagenum").val(pagenum)
	}
	else {
		frm.append('<input type="hidden" id="pagenum" name="pagenum" value="' + pagenum +'">');
	}

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
	</div>
	<div id="container">
		<div class="contentMY">
			<div class="LNB_area">
				<div class="LNB_list">
					<a href="/front/mypage/faqList.do" class="LNB_focus">FAQ</a>
				</div>
			</div>
			<div class="content_area">
				<div class="LNB_title">FAQ</div>
				<form class="FAQ_search" name="frm" id="frm" action="/front/mypage/faqList.do" method="post" accept-charset="UTF-8">
					<button type="submit"><img src="/images/icon_search_gr.png" alt="" /></button>
					<input type="text" id="searchKey" name="searchKey" value="${searchVO.searchKey }" placeholder="FAQ 검색">
				</form>
				<c:choose>
				<c:when test="${empty searchVO.searchKey and searchVO.searchKey eq '' }">
					<c:choose>
					<c:when test="${empty faqVO }">
					<div class="FAQNot" style="display:block;">
						<img src="/images/img_nodata.png" alt="" />
						<div class="txt">아직 등록된 FAQ가 없어요.</div>
					</div>
					</c:when>
					<c:otherwise>
					<div class="FAQYes">
						<table class="FAQ_table">
							<caption>전체 FAQ 목록</caption>
							<colgroup>
								<col style="width:50px;">
								<col style="width:710px;">
							</colgroup>
							<tbody>
								<c:forEach items="${faqVO }" var="list">
								<tr class="border_T">
									<td class="Qcell_down"></td>
									<td>
										<div class="QTitle">${list.ufq_question }</div>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="Acell">
										${list.ufq_answer }
									</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
						<div class="page_pn">
							<ul>
								<c:if test="${not empty faqVO }">
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
				</c:when>
				<c:otherwise>
					<c:choose>
					<c:when test="${empty faqVO }">
					<div class="FAQ_searchResultNot" style="display:block;">
						<div class="result"><span class="highlight">'${searchVO.searchKey }'</span>에 대한 검색 결과가 없습니다.</div>
						<div class="result_sub">입력하신 단어의 띄어쓰기, 맞춤법 등을 정확하게 입력해 주세요.<br/>
							검색하신 단어 수를 줄이거나, 다른 검색어로 검색해 보세요.</div>
					</div>
					</c:when>
					<c:otherwise>
					<div class="FAQ_searchResultYes" style="display:block;">
						<div class="result"><span class="highlight">'${searchVO.searchKey }'</span>에 대한 검색 결과는 <span class="highlight">${paging.totalCount }</span>건 입니다.</div>
						<table class="FAQ_table">
							<caption>검색어 결과 FAQ 목록</caption>
							<colgroup>
								<col style="width:50px;">
								<col style="width:710px;">
							</colgroup>
							<tbody>
								<c:forEach items="${faqVO }" var="list">
								<tr class="border_T">
									<td class="Qcell_down"></td>
									<td>
										<div class="QTitle">${list.ufq_question }</div>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="Acell">
										${list.ufq_answer }
									</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
						<div class="page_pn">
							<ul>
								<c:if test="${not empty faqVO }">
									<c:if test="${paging.prev}">
										<li><a href="javascript:page(1);"><img src="/images/icon_page_first.png" alt="첫페이지" /></a></li>
										<li><a href="javascript:page(${paging.getEndPage()-1});"><img src="/images/icon_page_prev.png" alt="이전페이지" /></a></li>
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
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>