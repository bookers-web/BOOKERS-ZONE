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

<div id="wrap">
	<div id="header">
		<div class="top">
			<%@ include file="/WEB-INF/views/common/logo.jsp" %>
			<%@ include file="/WEB-INF/views/common/gnb.jsp" %>
			<div class="search_input">
				<form name="searchForm" id="searchForm" action="/front/home/searchList.do" method="post" accept-charset="UTF-8">
					<input type="text" onKeyDown="javascript:if(event.keyCode == 13){fn_go_search_page(); return false;}" class="searchWord" id="searchName" name="searchName" value="${searchVO.searchName }" placeholder="제목, 저자 , 출판사 검색" title="도서 검색">
					<button type="button" class="search" onClick="javascript:fn_go_search_page();return false;"><img src="/images/icon_search_bk.png" alt="" /></button>
				</form>
			</div>
		</div>
		<hr/>
		<div class="footerM">
			<ul class="snb_list">
				<li>
					<a href="/front/home/noticeList.do" class="nav_focus">공지사항</a>
				</li>
			</ul>
		</div>
		<hr/>
	</div>
	<div id="container">
		<form name="frm" id="frm" action="/front/home/noticeList.do" method="post">
		
		</form>
		<div class="content">
			<c:choose>
			<c:when test="${empty noticeList }">
			<div class="contentsNot" style="display:block;">
				<img src="/images/img_nodata.png" alt="" />
				<div>아직 등록된 공지사항이 없어요.</div>
			</div>
			</c:when>
			<c:otherwise>
			<div class="contentsYes">
				<table class="NoticeBody">
					<caption>공지사항 목록</caption>
					<colgroup>
						<col style="width:64px;">
						<col style="width:1016px;">
					</colgroup>
					<tbody>
						<c:forEach items="${noticeList }" var="list">
						<tr class="questionLine">
							<td class="Qcell_down"></td>
							<td>
								<div class="QTitle">${list.un_title }</div>
								<div class="QDate">${list.un_regdate }</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="Acell">
								${list.un_content }
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
				<div class="page_pn">
					<ul>
						<c:if test="${not empty noticeList }">
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
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
