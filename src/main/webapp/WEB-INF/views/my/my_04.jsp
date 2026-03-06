<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	$(".prize_preview").on("click", function() {
		var year = $(this).parent().find("#year_"+$(this).attr("id")).val();
		var month = $(this).parent().find("#month_"+$(this).attr("id")).val();
		var um_userid = $(this).parent().find("#um_userid_"+$(this).attr("id")).val();
		var um_name = $(this).parent().find("#um_name_"+$(this).attr("id")).val();
		var uis_name = $(this).parent().find("#uis_name_"+$(this).attr("id")).val();
		var date1 = $(this).parent().find("#date1_"+$(this).attr("id")).val();
		var date2 = $(this).parent().find("#date2_"+$(this).attr("id")).val();
		var date3 = $(this).parent().find("#date3_"+$(this).attr("id")).val();
		
		if(month.length == 1){
			month = '0'+month;
		}
		
		$(".bookCert_Pop_"+$(this).attr("id")).show();
		$("body").css("overflow","hidden");
	});
});

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

function fn_close_popup(target){
	$(".bookCert_Pop_" + target).hide();
	$("body").css("overflow","scroll");
	$(".certWording").empty();
	$("#certImage_"+target).empty();
}
</script>
<style>
	
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
<div id="wrap">
	<div id="header">
		<div class="top">
			<%@ include file="/WEB-INF/views/common/logo.jsp" %>
			<%@ include file="/WEB-INF/views/common/gnb.jsp" %>
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
				<form name="frm" id="frm" action="/front/mypage/myExcellentList.do" method="post" accept-charset="UTF-8">
				</form>
				<c:choose>
				<c:when test="${empty list }">
				<div class="selectNot" style="display:block;">
					<div class="LNB_title">독서우수자 선정 내역</div>
					<img src="/images/img_nodata.png" alt="" />
					<div class="txt">아직 독서우수자로 선정된 내역이 없어요.</div>
				</div>
				</c:when>
				<c:otherwise>
				<div class="selectYes">
					<div class="LNB_title">독서우수자 선정 내역</div>
					<div class="LNB_noticeBox">
						<img src="/images/icon_info.png" alt="" />독서우수자는 어떻게 선정되나요?
						<div class="LNB_noticeTxt">일정 기간 동안 책 완독, 독서감상문 작성 등의 꾸준한 독서 활동을 통해 독서우수자로 선정됩니다.<br/>
						독서우수자로 선정되면 독서인증서를 발급받을 수 있습니다.</div>
					</div>
					<table class="bookPrize_list">
						<caption>독서우수자 선정 내역</caption>
						<colgroup>
							<col style="width:380px;">
							<col style="width:380px;">
						</colgroup>
						<tbody>
							<thead>
								<tr class="border_T">
									<th>선정 기간</th>
									<th>독서 인증서</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${list }" var="list">
								<tr>
									<td><div class="bookPrize_open" id="${list.uim_code }">${list.uib_year }.${list.uib_month }</div></td>
									<td class="certPreview">
										<c:choose>
										<c:when test="${list.uim_issued_yn eq 'Y' and list.uim_cancel_yn eq 'N' and (not empty list.um_name  and list.um_name ne '') }">
											<div class="prizePrint">
												<button type="button" class="prize_preview" id="${list.uim_code }">인쇄</button>
												
												<input type="hidden" id="iat_img_${list.uim_code }" value="${list.iat_img }" />
												<input type="hidden" id="iat_text_${list.uim_code }" value="${list.iat_text }" />
												<input type="hidden" id="uis_name_${list.uim_code }" value="${list.uis_name }" />
												<input type="hidden" id="um_userid_${list.uim_code }" value="${list.um_userid }" />
												<input type="hidden" id="um_name_${list.uim_code }" value="${list.um_name }" />
												<input type="hidden" id="year_${list.uim_code }" value="${list.uib_year }" />
												<input type="hidden" id="month_${list.uim_code }" value="${list.uib_month }" />
												<input type="hidden" id="date1_${list.uim_code }" value="${fn:split(list.uim_issued_date, '-')[0] }" />
												<input type="hidden" id="date2_${list.uim_code }" value="${fn:split(list.uim_issued_date, '-')[1] }" />
												<input type="hidden" id="date3_${list.uim_code }" value="${fn:split(list.uim_issued_date, '-')[2] }" />
											</div>
										</c:when>
										<c:when test="${list.uim_issued_yn eq 'N' and list.uim_cancel_yn eq 'N' and (not empty list.um_name  and list.um_name ne '') }">
											<div class="prizeWait">발급 대기중</div>
										</c:when>
										<c:otherwise>
											<div class="prizeNot"><img src="/images/icon_info.png" alt="" /> 발급불가</div>
										</c:otherwise>
										</c:choose>
									</td>
								</tr>
								</c:forEach>
								
							</tbody>
						</tbody>
					</table>
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
			</div>
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>
<c:choose>
<c:when test="${empty list }">
</c:when>
<c:otherwise>
<c:forEach items="${list }" var="list">
<div id="bookPrize_Pop" class="bookPrize_Pop_${list.uim_code }" style="display:none;">
	<div class="bookPrize_box">
		<div class="prizeTitle"><span></span>${list.uib_year }년 <span></span>${list.uib_month }월 독서우수자 내역 상세</div>
		<div class="prizeSubtitle">평가기간</div>
		<div class="prizeTerm">${list.uib_startdate }~${list.uib_enddate }</div>
		<div class="prizeSubtitle">활동내역</div>
		<table class="prizeTable">
			<caption>독서우수자 활동내역</caption>
			<colgroup>
				<col style="width:193px;">
				<col style="width:193px;">
				<col style="width:193px;">
			</colgroup>
			<thead>
				<tr class="border_T">
					<th>완독 도서 수<br/><span class="subTxt">(추천 도서 수)</span></th>
					<th>읽은 도서 수<br/><span class="subTxt">(추천 도서 수)</span></th>
					<th>감상문 수<br/><span class="subTxt">(추천 도서 수)</span></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${list.uim_readed_rmd }<br><span class="subTxt">(${list.uim_readed })</span></td>
					<td>${list.uim_read_rmd }<br><span class="subTxt">(${list.uim_read })</span></td>
					<td>${list.uim_report_rmd }<br><span class="subTxt">(${list.uim_report })</span></td>
				</tr>
			</tbody>
		</table>
		<div class="prizeExit">확 인</div>
	</div>
</div>
</c:forEach>
</c:otherwise>
</c:choose>

<c:choose>
<c:when test="${empty list }">
</c:when>
<c:otherwise>
<c:forEach items="${list }" var="list">
<div id="bookCert_Pop" class="bookCert_Pop_${list.uim_code }">
	<div class="bookCert_box">
		<div class="page bookCertTitle page">독서 인증서 미리보기</div>
		<div class="subpage bookCert_area subpage" id="printArea_${list.uim_code }">
			<div class="bookcert_frame">
				<div class="certNum">제 <span id="year_${list.uim_code }">${list.uib_year }</span>-<span id="month_${list.uim_code }">${list.uib_month }</span>-<span>0001</span> 호</div>
			<div class="certTxt_ko">독서 인증서</div>
			<div class="certID">아이디: <span id="target_um_userid_${list.uim_code }">${list.um_userid }</span></div>
			<div class="certName">성&nbsp;&nbsp;&nbsp;명: <span id="target_um_name_${list.uim_code }">${list.um_name }</span></div>
			<div class="certWording">${list.iat_text }</div>
			<div class="certDate"><span id="print_date1_${list.uim_code }">${fn:split(list.uim_issued_date, '-')[0] }</span>년 <span id="print_date2_${list.uim_code }">${fn:split(list.uim_issued_date, '-')[1] }</span>월 <span id="print_date3_${list.uim_code }">${fn:split(list.uim_issued_date, '-')[2] }</span>일</div>
			<div class="orgSign" id="target_uis_name_${list.uim_code }">${list.uis_name }</div>
			</div>
			<div class="certIMG" id="certImage_${list.uim_code }"><img class="certImage_${list.uim_code }" alt="" src="https://files.bookers.life${list.iat_img }">  </div>
		</div>
		<div class="bookCertExit" onClick="fn_close_popup('${list.uim_code }');">취 소</div>
		<div class="bookCert_print" onClick="printPage('${list.uim_code }');">인 쇄</div>
	</div>
</div>
</c:forEach>
</c:otherwise>
</c:choose>

<script>
	function  printPage(uim_code){
		$.ajax({
			url : "/front/mypage/myExcellentPrintState.json",
			data : {
				"uim_code" : uim_code
			},
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			dataType : "json",
			success: function(data) {
			}
		});
		
		$("#printArea_"+uim_code).printThis({
			debug: false,
			importCSS:false,
			pritContainer:true,
			loadCSS:"/css/printThis/printCSS.css",
			pageTitle:"",
			removeInline:false
		});
		
		return false;
	}
</script>


</body>
</html>
