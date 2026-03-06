<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%
	String filePath = "https://files.bookers.life";
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/gtmhead.jsp" %>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<title>부커스 모바일 웹:추천 리스트 화면</title>
	<link rel="stylesheet" href="/css/basic.css?v=<%= System.currentTimeMillis() %>">
	<link rel="stylesheet" href="/css/screen.css?v=<%= System.currentTimeMillis() %>">
	<script src="/js/jquery.min.js"></script>
	<link rel="stylesheet" href="/css/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="/js/jquery-ui.js"></script>
<script type="text/javascript">
$(document).ready(function() {

	
	oldAction = $("#frm").attr("action")
	
	// 이미지 상세 페이지 링크 연결
	$(".p_Bookcover img.cover").on("click", function() {
		
		var frm = $("#frm");

		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("id"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("id") +'">');
		}
		
		$("#frm").attr("action","/front/mobile/bookDetail.do");
		
		frm.submit();
	});
});

function fn_back(){
    location.href="/front/mobile/main.do"
}

</script>

</head>
<body>
 <%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
	<header class="m_head">
		<div class="mainTop">
			<div class="btn_prevArea">
				<button class="btn_Prev" onclick="javascript:fn_back();"><span class="blind">이전페이지 이동</span></button>
			</div>
			<div class="screenTitle" style="text-align:left; margin-left:56px;">
				${groupName}
			</div>	
		</div>
	</header>
	<main class="max_main">
	<form name="frm" id="frm" action="/front/mobile/recommendList.do" method="post">
	<input type="hidden" id="uil_code" name="uil_code" value="${searchVO.uil_code }" />
				<input type="hidden" id="viewMode" name="viewMode" value="${searchVO.viewMode }" />
				<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
				<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
	</form>
		<div class="clear m_wrap_sub">
			<ul class="book_list_all">
			<c:forEach items="${chooseCmList }" var="list" varStatus="status">
				<li class="p_Book_item">
					
					<!-- 표지 이미지 -->
					<div class="p_Bookcover" id="${list.ucm_code }">
						<c:choose>
						<c:when test='${list.ucm_file_type eq "PDF" }'>
						<div class="mark m_pdf"><span class="blind">pdf</span></div>
						</c:when>
						<c:when test='${list.ucm_file_type eq "ZIP" or list.ucm_file_type eq "COMIC" }'>
						<div class="mark m_comic"><span class="blind">comic</span></div>
						</c:when>
						<c:when test='${list.ucm_file_type eq "AUDIO" }'>
						<div class="mark m_audio"><span class="blind">audio</span></div>
						</c:when>
						<c:otherwise>
						<div class="mark "><span class="blind">epub</span></div>
						</c:otherwise>
						</c:choose>
						<c:choose>
						<c:when test="${empty list.ucm_cover_url }">
						<img class="cover" src="/images/img_coverNot.png" alt="" />
						</c:when>
						<c:otherwise>
						<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
						</c:otherwise>
						</c:choose>		
					</div>
					<a href="#">
						<div class="p_book_titleArea"><!--책제목 나오는 부분-->
							<span class="p_book_tit">${list.ucm_title }</span>
						</div>
					</a>
				</li>
				</c:forEach>
			</ul>

		</div>
	</main>
	<%@include file="../common/m_footer.jsp" %>
</body>
</html>