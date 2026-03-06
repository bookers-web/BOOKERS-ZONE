<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	
});

</script>
</head>
<body>

<div id="wrap">
	<div id="header">
		<div class="top">
			<%@ include file="/WEB-INF/views/common/logo.jsp" %>
			<%@ include file="/WEB-INF/views/common/gnb.jsp" %>
			<div class="header-side"><!-- 251119 [고] : div 그룹핑 추가 -->
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
		<div class="footerM">
			<ul class="snb_list">
				<li>
					<a href="/front/home/tosInfo.do" class="nav_focus">이용약관</a>
				</li>
			</ul>
		</div>
		<hr/>
	</div>
	<div id="container" style="background-color: #f1f1f1;">
		<div class="content2">
			<div class="Tos_Htitle">이용약관</div>
			<div class="Tos_box">
				<div class="Tos_scroll">
					<div class="Tos_wrap">
						${tosVO.uts_content }
					</div>
				</div>
			</div>
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
