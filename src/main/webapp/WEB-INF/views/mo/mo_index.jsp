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
	<title>부커스 모바일 웹</title>
	<link rel="stylesheet" href="/css/basic.css?v=<%= System.currentTimeMillis() %>">
	<link rel="stylesheet" href="/css/screen.css?v=<%= System.currentTimeMillis() %>">
	<script src="/js/jquery.min.js"></script>
	<link rel="stylesheet" href="/css/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="/js/jquery-ui.js"></script>
<script type="text/javascript">

// 맨 위로 이동
function fn_goTop () {
	$('html').scrollTop(0);
}

// 상세 페이지 이동 (제목/표지 공통 사용)
function fn_Detail(ucm_ucs_code, ucm_code){
	var frm = $("#frm2");
	
	if($("#selectUcmCode").length > 0 ){
		$("#selectUcmCode").val(ucm_code);
	} else {
		frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + ucm_code +'">');
	}
	
	if($("#selectUcmUcsCode").length > 0 ){
		$("#selectUcmUcsCode").val(ucm_ucs_code);
	} else {
		frm.append('<input type="hidden" id="selectUcmUcsCode" name="ucm_ucs_code" value="' + ucm_ucs_code +'">');
	}
	
	$("#frm2").attr("action","/front/mobile/bookDetail.do");
	frm.submit();
}

// 상단 검색 버튼
function fn_go_search() {
	var frm = $("#frm3");
	frm.submit();
}
</script>
</head>
<body>
 <%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
	<header class="m_head">
		<div class="mainTop">
			<div class="Toplogo">
				<c:choose>
				<c:when test="${empty sessionScope.UIS_MOBILE_LOGO_URL }">
					<img src="/images/mobile/logo_top.svg" alt="bookers logo" >
				</c:when>
				<c:otherwise>
					<img src="<%=filePath %>${sessionScope.UIS_MOBILE_LOGO_URL }" alt="bookers logo image" />
				</c:otherwise>
				</c:choose>
			</div>
			<div class="btn_T_searchArea">
				<button class="btn_search" onclick="fn_go_search();"><span class="blind">검색하기</span></button>
			</div>
			<div class="GNBpart">
				<ul class="GNB"><!-- GNB -->
					<li class="on"><a href="/front/mobile/main.do">추천</a></li>
					<li>
						<a href="/front/mobile/category.do">주제별</a>
						<c:if test="${hasEbook or hasAudio}">
						<div class="depth-sub">
							<c:if test="${hasEbook}">
							<a href="/front/mobile/category.do?uct_type=E" class="<c:if test="${searchVO.uct_type eq 'E'}">on</c:if>">eBook</a>
							</c:if>
							<c:if test="${hasAudio}">
							<a href="/front/mobile/category.do?uct_type=A" class="<c:if test="${searchVO.uct_type eq 'A'}">on</c:if>">오디오북</a>
							</c:if>
						</div>
						</c:if>
					</li>
					
				</ul>
			</div>
		</div>

	</header>
	<main class="max_main">
	<form name="frm" id="frm" action="/front/mobile/recommendList.do" method="post">
	</form>
	<form name="frm2" id="frm2" action="/front/mobile/bookDetail.do" method="post">
	</form>
	<form name="frm3" id="frm3" action="/front/mobile/searchList.do" method="post">
		<input type="hidden" id="preUrl" name="preUrl" value="main">
	</form>
	<div class="clear m_wrap_gnb wrap_curaWidth">
	<c:forEach items="${list }" var="mainList">
		<section class="curation"><!-- 큐레이션 01 -->
			<div class="title_cura">
			<!-- 큐레이션 제목 최대 수 : 공백 포함 25자 (26자 이상은 점점이로 표시) -->
				<div class="tit_txt" onclick="location.href='/front/mobile/recommendList.do?uil_code=${mainList.uil_code }'">${mainList.uil_name }</div>
				<div class="btn_Area">
					<button class="btn_goPage"  onclick="location.href='/front/mobile/recommendList.do?uil_code=${mainList.uil_code }'"><span class="blind">자세히 보기</span></button>
				</div>
			</div>
			<div class="bookArea_scroll">
				<ul class="book_list display_inFlex ">
				<c:forEach items="${mainList.bookList }" var="book">
					<li class="book_item">
						<div class="book_cover">
							<!-- 파일 형태 -->
							<c:choose>
							<c:when test='${book.ucm_file_type eq "PDF" }'>
								<div class="mark m_pdf"><span class="blind">pdf</span></div>
							</c:when>
							<c:when test='${book.ucm_file_type eq "ZIP" or book.ucm_file_type eq "COMIC" }'>
								<div class="mark m_comic"><span class="blind">comic</span></div>
							</c:when>
							<c:when test='${book.ucm_file_type eq "AUDIO" }'>
								<div class="mark m_audio"><span class="blind">audio</span></div>
							</c:when>
							<c:otherwise>
								<div class="mark "><span class="blind">epub</span></div>
							</c:otherwise>
							</c:choose>
							<!-- 표지 클릭 시에도 fn_Detail 사용 -->
							<div class="p_Bookcover type-vh"
								 id="${book.ucm_code }"
								 onclick="fn_Detail('${book.ucm_ucs_code }','${book.ucm_code}');">
								<c:choose>
								<c:when test="${empty book.ucm_cover_url }">
									<img class="cover" src="/images/img_coverNot.png" alt="" />
								</c:when>
								<c:otherwise>
									<img class="cover" src="<%=filePath %>${book.ucm_cover_url }" alt="" />
									<c:if test='${book.uce_use_yn eq "Y" }'>
										<img src="/images/v2/badge/badge_bookers_only.png" class="bdg-booker-only" width="36" alt="부커스단독 /"><!-- 251119 [고] : 부커스단독 뱃지 추가 -->
									</c:if>
								</c:otherwise>
								</c:choose>		
							</div>
						</div>
						<p class="book_titleArea"><!--책제목 나오는 부분-->
							<a href="#" onClick="fn_Detail('${book.ucm_ucs_code }','${book.ucm_code}');return false;">
								<span class="books_tit">${book.ucm_title }</span>
							</a>
						</p>
						<div class="infoAuthorName">${book.ucm_writer }</div><!-- 251119 [고] : 저자명 추가 -->
						<div class="bookBadgeGroup"><!-- 251119 [고] : 리스트 뱃지 추가 -->
							<c:if test='${book.badge_e eq "Y" }'>
								<span class="book-bdg-event">이벤트</span>
							</c:if>
							<c:if test='${book.badge_n eq "Y" }'>
								<span class="book-bdg-recent">최신</span>
							</c:if>
							<c:if test='${book.badge_p eq "Y" }'>
								<span class="book-bdg-best">인기</span>
							</c:if>
						</div>
					</li>
					</c:forEach>
				</ul>
			</div>
		</section>
		</c:forEach>
	</div>
	</main>
	<%@include file="../common/m_footer.jsp" %>
	<button class="btn_goTop" onclick="javascript:fn_goTop();">
		<span class="blind">상단으로 이동</span>
	</button>

</body>
</html>
