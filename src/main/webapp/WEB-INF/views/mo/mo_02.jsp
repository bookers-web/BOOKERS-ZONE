<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="bcf" uri="/WEB-INF/tld/bookersFunctions"%>
<%
	String filePath = "https://files.bookers.life";
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/gtmhead.jsp" %>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<title>부커스 모바일 웹:상세 페이지</title>
	<link rel="stylesheet" href="/css/basic.css?v=<%= System.currentTimeMillis() %>">
	<link rel="stylesheet" href="/css/screen.css?v=<%= System.currentTimeMillis() %>">
	<script src="/js/jquery.min.js"></script>
	<link rel="stylesheet" href="/css/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="/js/jquery-ui.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	// 썸네일형 도서리스트 커버 영역 감싸고 상세 페이지 링크 연결
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



function webviewer_Btn(ucm_code, ume_code){
	
	$.ajax( {
		url: "/front/myLibrary/webViewer.json",
		data: {"ucm_code" : ucm_code, "ume_code" : ume_code},
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		async : false,
		success: function( data ) {
			if (data.count == 0){
				alert(data.resultMsg);
			} else if (data.count == -1){
				alert(data.resultMsg);
				var url = '/login.do';
				location.replace(url);
			} else if (data.count == -21){
				alert(data.resultMsg);
			} else {
				window.open(data.resultMsg,"content");
				$(".btn_myLibrary_add").hide();
				$(".btn_myLibrary_del").show();
			}
		},
		error: function(resultMsg) {
			// $("#idCheck").val("N");
			alert(resultMsg);
		}
	});
}

function fn_modal(ucm_code, ume_code, ucm_title) {
	$("#myModal").css("display","inline-block");
	$(".btn_webRead").attr("onclick","webviewer_Btn('"+ucm_code+"','"+ume_code+"');");
	$(".t_bold").html(ucm_title);	
};

function fn_modal_close() {
    $("#myModal").css("display","none");
    $(".btn_webRead").removeAttr("onclick")
};

function fn_back(){
    history.go(-1);
}

function fn_goTop () {
	$('html').scrollTop(0);
}

function preview_click() {
	var url= "https://www.bookers.life/front/preview/viewer.do?ucm_code=${cmVO.ucm_code}";    //팝업창에 출력될 페이지 URL
	var winWidth = 768;
	var winHeight = 704.4;
	var popupOption= "width="+winWidth+", height="+winHeight;    //팝업창 옵션(optoin)
	var myWindow = window.open(url,"미리보기",popupOption);
}

function fn_appLink(ucm_code) {
		var uid = "<%=session.getAttribute("UM_USERID") %>";
		var uisCode = "<%=session.getAttribute("UM_UIS_CODE") %>";
		var uisResult = uisCode.replace('UIS','');
		
		var str = "{\"SSOID\":\""+uid+"\",\"SITEID\":\""+uisResult+"\"}";
		//
		
		var base64Str = btoa(str);
		console.log(str);
		console.log(base64Str);
		location.href="intent://main/?SSO="+base64Str+"#Intent;scheme=bookersebook;package=com.bookers.ebook;end"
		// location.href= "intent://main/?SSO=eyJTU09JRCI6ImJvb2tlcnMwNCIsIlNJVEVJRCI6IjAwMDAwMDAwMjIifQ==#Intent;scheme=bookersebook;package=com.bookers.ebook;end";
}

function fn_vol() {
	alert("앱에서 읽기는 준비중입니다.");
}

function fn_eventDetail(uem_code, uem_url){
	
	var frm = $("#frm");
	
	if($("#selectUemCode").length > 0 ){
		$("#selectUemCode").val(uem_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUemCode" name="uem_code" value="' + uem_code +'">');
		frm.append('<input type="hidden" id="selectUemUrl" name="uem_url" value="' + uem_url +'">');
	}

	
	$("#frm").attr("action","/front/home/eventDetail.do");
	
	frm.submit();
}

function fn_Detail(ucm_ucs_code, ucm_code){
	
	var frm = $("#frm");
	
	if($("#selectUcmCode").length > 0 ){
		$("#selectUcmCode").val(ucm_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + ucm_code +'">');
	}
	
	if($("#selectUcmUcsCode").length > 0 ){
		$("#selectUcmUcsCode").val(ucm_ucs_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUcmUcsCode" name="ucm_ucs_code" value="' + ucm_ucs_code +'">');
	}
	
	$("#frm").attr("action","/front/mobile/bookDetail.do");
	
	frm.submit();
}
</script>
</head>
<body>
 <%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
	<div id="myModal" class="modal">
      <!-- Modal content -->
		<div class="modal-content">
			<div class="popup_wrap">
				<div class="popupHead">
					<h3 class="popup_Tit">읽기 방법 선택</h3>
					<button class="btn_close_pop" onclick="fn_modal_close();"><span class="blind">닫기</span></button>
				</div>
				<c:choose>
					<c:when test="${cmVO.ucm_webdrm_yn eq 'N'}">
					<div class="popup_Con">
						<!-- 제목 들어가는 부분 -->
						<i class="t_bold"></i>
						<br style="margin-top: 10px;">
						
							해당 도서는 바로읽기가 지원되지 않습니다.<br>부커스앱으로 이용해주세요.
							
					</div>
					</c:when>
					<c:otherwise>
					<div class="popup_Con_s">
						<!-- 제목 들어가는 부분 -->
						<i class="t_bold"></i>
						<br style="margin-top: 10px;">
						
							읽기 방법을 선택해주세요.
							
					</div>
					</c:otherwise>
				</c:choose>
				<div class="popup_btn">
				<c:choose>
					<c:when test="${cmVO.ucm_webdrm_yn eq 'Y'}">
						<button class="btn_webRead">바로 읽기</button>
						<button class="btn_appRead" onclick="javascript:fn_vol();">앱에서 읽기</button>
					</c:when>
					<c:otherwise>
						<!-- <button class="btn_appRead_alone" onClick="fn_appLink('${cmVO.ucm_code}');">앱에서 읽기</button> -->
						<button class="btn_appRead_alone" onClick="javascript:fn_vol();">앱에서 읽기</button>
					</c:otherwise>
				</c:choose>
					
				</div>
			</div>
		</div>
	</div>
	<header class="m_head">
		<div class="mainTop">
			<div class="btn_prevArea">
				<button class="btn_Prev" onclick="javascript:fn_back();"><span class="blind">이전페이지 이동</span></button>
			</div>
			<div class="screenTitle" style="text-align:left; margin-left:56px;"><!-- 책 제목 -->
				${cmVO.ucm_title }
			</div>
		</div>
	</header>
	<main class="max_main">
	<form name="frm" id="frm" action="/front/mobile/bookDetail.do" method="post">
	</form>
	<div class="clear m_wrap_detail">
		<section class="book_detail_head">
			<div class="detail_cover">
				<img src="<%=filePath %>${cmVO.ucm_cover_url }">
			</div>
			<div class="btn_previewArea">
				<c:if test="${cmVO.ucm_preview_flag eq 'Y' }">
					<button class="btn_preview" style="display:block;" onclick="preview_click();"><img src="/images/mobile/ic_preview.svg"><span>미리보기</span></button>
				</c:if>
			</div>
			<div class="detail_booktitleArea">
				<div class="detail_book_tit">
					${cmVO.ucm_title }
				</div>
				<div class="detail_writer">${cmVO.ucm_writer} </div>
				<div class="detail_publish">${cmVO.ucp_brand } &#8226; ${cmVO.ucm_ebook_pubdate }</div>
			</div>
		</section>
		<hr class="barGray" />
		<section class="detail_infoArea">
			<!-- add by 23y0718 begin -->
			<c:if test="${not empty cmVO.uil_name and cmVO.uil_name ne ''}">
				<div class="detail_curation"><!-- 큐레이션 부분 -->
					<img src="/images/mobile/mark_curation.svg" alt="큐레이션 표시"> ${cmVO.uil_name}
				</div>
			</c:if>
			
			
			<hr class="lineGray" />
			<c:choose>
				<c:when test="${cmVO.uis_return_flag eq 'Y'}">
					<c:choose>
						<c:when test="${cmVO.uis_copy_book_flag eq 'Y' and cmVO.ucm_copy_book_flag eq 'Y' and cmVO.copy_book_flag eq 1}">
							<c:choose>
								<c:when test="${cmVO.today_copy_count eq 0}">
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="mark_limited">
											<img src="/images/mobile/img_limited.svg"> 매일 선착순
										</div>
										<div class="countNumBox"><strong >현재 열람 가능한 권수가 없습니다.</strong></div>
									</div>
									
								</c:when>
								<c:otherwise>
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="mark_limited">
											<img src="/images/mobile/img_limited.svg"> 매일 선착순
										</div>
										<div class="countNumBox">현재 <strong >${cmVO.today_copy_count}권</strong> 열람이 가능합니다.</div>
									</div>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${cmVO.today_copy_count eq 0}">
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="countNumBox"><strong >현재 열람 가능한 권수가 없습니다.</strong></div>
									</div>
									
								</c:when>
								<c:otherwise>
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="countNumBox">현재 <strong >${cmVO.today_copy_count}권</strong> 열람이 가능합니다.</div>
									</div>
									
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>	
						<c:when test="${cmVO.uis_copy_book_flag eq 'Y' and cmVO.ucm_copy_book_flag eq 'Y' and cmVO.copy_book_flag eq 1}">
							<c:choose>
								<c:when test="${cmVO.today_copy_count eq 0}">
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="mark_limited">
											<img src="/images/mobile/img_limited.svg"> 매일 선착순
										</div>
										<div class="countNumBox"><strong>현재 열람 가능한 권수가 없습니다.</strong></div>
									</div>
								</c:when>
								<c:otherwise>
									<div class="notice_limitedBook"><!-- 도서 제한하는 수 -->
										<div class="mark_limited">
											<img src="/images/mobile/img_limited.svg"> 매일 선착순
										</div>
										<div class="countNumBox">현재 <strong>${cmVO.today_copy_count}권</strong> 열람이 가능합니다.</div>
									</div>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<div class="rederNumber"><!-- 총 도서 보는 유저 수 -->
								<img src="/images/mobile/ic_user.svg" alt="유저 아이콘"> <strong class="t_point"><fmt:formatNumber value="${cmVO.ucm_read_count}" pattern="#,###"/></strong>명이 읽고 있습니다.
							</div>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
			<!-- add by 23y0718 finish -->
			<div class="book_infoBox"><!-- 도서 정보 -->
				<table class="infoTbl">
					<caption></caption>
					<colgroup>
						<col style="width:18%;">
						<col style="width: ;">
						<col style="width:18% ;">
						<col style="width: ;">
					</colgroup>
					<tbody>
						<c:choose>
						<c:when test='${cmVO.ucm_file_type eq "EPUB" }'>
							<tr>
								<td class="tbl_item">파일정보:</td>
								<td>ePUB</td>
								<td class="tbl_item">용량:</td>
								<td>${ bcf:fileSizeToStr(cmVO.ucm_filesize)}</td>
							</tr>
							<tr>
								<td class="tbl_item">글자수:</td>
								<td>약 ${ bcf:textCountToStr(cmVO.ucm_text_count) }자</td>
								<td class="tbl_item">듣기기능:</td>
								<c:if test="${cmVO.ucm_support_tts eq 'Y' }"><td>TTS 지원</td></c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> 
							</tr>
						</c:when>
						<c:when test='${cmVO.ucm_file_type eq "PDF" }'>
							<tr>
								<td class="tbl_item">파일정보:</td>
								<td>PDF</td>
								<td class="tbl_item">용량:</td>
								<td>${ bcf:fileSizeToStr(cmVO.ucm_filesize)}</td>
							</tr>
							<tr>
								<td class="tbl_item">페이지수:</td>
								<td>${ cmVO.ucm_paper_pages}</td>
								<td class="tbl_item">듣기기능:</td>
								<c:if test="${cmVO.ucm_support_tts eq 'Y' }"><td>TTS 지원</td></c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> 
							</tr>
						</c:when>
						<c:when test='${cmVO.ucm_file_type eq "ZIP" or cmVO.ucm_file_type eq "COMIC"}'>
							<tr>
								<td class="tbl_item">파일정보:</td>
								<td>COMIC</td>
								<td class="tbl_item">용량:</td>
								<td>${ bcf:fileSizeToStr(cmVO.ucm_filesize)}</td>
							</tr>
							<tr>
								<td class="tbl_item">페이지수:</td>
								<td>${ cmVO.ucm_paper_pages}</td>
								<td class="tbl_item">듣기기능:</td>
								<c:if test="${cmVO.ucm_support_tts eq 'Y' }"><td>TTS 지원</td></c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> 
							</tr>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="tbl_item">파일정보:</td>
								<td>AUDIO</td>
								<td class="tbl_item">용량:</td>
								<td>${ bcf:fileSizeToStr(cmVO.ucm_filesize)}</td>
							</tr>
							<tr>
								<td class="tbl_item">총 재생시간:</td>
								<td>${cmVO.ucm_total_playtime }</td>
								<td class="tbl_item"></td>
								<td></td> 
							</tr>
						</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</section>
		<c:if test="${not empty eventList }">
		<section class="detail_infoArea">
			<div class="detail_subTit">이 책의 이벤트</div>
			<div class="bookArea_scroll"><!-- 도서 나열 -->
				<ul class="book_list display_inFlex" style="display:inline-flex; gap:8x; padding:0; margin:0; list-style:none;">
				<c:forEach items="${eventList }" var="list">
					<li class="book_item" style="display:inline-block; width:70vw; flex:0 0 auto;">
						<div class="book_cover" style="width:100%;">
							<div class="p_Bookcover" >
								<a href="javascript:fn_eventDetail('${list.uem_code }','');">
									<img class="" src="<%=filePath %>${list.uem_thumbnail_image }" alt="배너이미지" style="width:100%; height:auto; display:block;"/>
								</a>
							</div>	
						</div>
						<p class="book_titleArea" style="width:68vw"><!--책제목 나오는 부분-->
							<span class="books_tit">${list.uem_title }</span>
						</p>
						<span style="margin-top:6px;color:#595959;font-size:13px;line-height:19px">${list.uem_display_startdate } ~ ${list.uem_display_enddate}</span>
					</li>
				</c:forEach>
				</ul>
			</div>
		</section>
		</c:if>
		<hr class="barGray" />
		<section class="detail_infoArea">
			<div class="book_summaryBox"><!-- 책 소개 -->
				<div class="detail_subTit">책 소개</div>
				<div class="detail_book_con">
					${fn:replace(cmVO.ucm_intro,crcn,br) }
				</div>
			</div>
		</section>
		<hr class="barGray" />
		<c:if test="${not empty cmVO.ucm_ucs_code and cmVO.ucm_ucs_code ne ''}">
		<section class="detail_infoArea">
			<div class="detail_subTit">이 책의 시리즈</div>
			<div class="bookArea_scroll"><!-- 도서 나열 -->
				<ul class="book_list display_inFlex ">
				<c:forEach items="${seriesList }" var="list" varStatus="status">
					<li class="book_item">
						<div class="book_cover" id="${list.ucm_code }">
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
							<div class="p_Bookcover" id="${list.ucm_code }">
								<c:choose>
								<c:when test="${empty list.ucm_cover_url }">
								<img class="cover" src="/images/img_coverNot.png" alt="" />
								</c:when>
								<c:otherwise>
								<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
								</c:otherwise>
								</c:choose>		
							</div>	
						</div>
						<p class="book_titleArea"><!--책제목 나오는 부분-->
							<span class="books_tit">${list.ucm_title }</span>
						</p>
					</li>
				</c:forEach>
				</ul>
			</div>
		</section>
		<hr class="barGray" />
		</c:if>
		<c:if test="${not empty cmVO.ucm_toc and cmVO.ucm_toc ne ''}">
		<section class="detail_infoArea">
			<div class="detail_subTit">목차</div>
			<div class="detail_book_con">
				${fn:replace(cmVO.ucm_toc,crcn,br) }
			</div>
		</section>
		<hr class="barGray" />
		</c:if>
		<c:if test="${not empty cmVO.ucm_review and cmVO.ucm_review ne ''}">
		<section class="detail_infoArea">
			<div class="detail_subTit">저자 소개</div>
			<div class="detail_book_con"> 
				${fn:replace(cmVO.ucm_review,crcn,br) }
			</div>
		</section>
		<hr class="barGray" />
		</c:if>
		<c:if test="${not empty cmVO.ucm_publish_review and cmVO.ucm_publish_review ne ''}">
		<section class="detail_infoArea">
			<div class="detail_subTit">출판사 리뷰</div>
			<div class="detail_book_con" >${fn:replace(cmVO.ucm_publish_review,crcn,br) }</div>
		</section>
		<hr class="barGray" />
		</c:if>
		<c:forEach items="${curation }" var="curationList">
		<section class="curation"><!-- 큐레이션 01 -->
			<div class="title_cura">
			<!-- 큐레이션 제목 최대 수 : 공백 포함 25자 (26자 이상은 점점이로 표시) -->
				<div class="tit_txt" onclick="location.href='/front/mobile/recommendList.do?uil_code=${curationList.uil_code }'">${curationList.uil_name }</div>
				<div class="btn_Area">
					<button class="btn_goPage"  onclick="location.href='/front/mobile/recommendList.do?uil_code=${curationList.uil_code }'"><span class="blind">자세히 보기</span></button>
				</div>
			</div>
			<div class="bookArea_scroll"><!-- 도서 나열 -->
				<ul class="book_list display_inFlex ">
				<c:forEach items="${curationList.bookList }" var="book">
					<li class="book_item">
						<div class="book_cover" id="${book.ucm_code }">
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
							<div class="p_Bookcover" id="${book.ucm_code }">
								<c:choose>
									<c:when test="${empty book.ucm_cover_url }">
									<img class="cover" src="/images/img_coverNot.png" alt="" />
									</c:when>
									<c:otherwise>
									<img class="cover" src="<%=filePath %>${book.ucm_cover_url }" alt="" />
									</c:otherwise>
								</c:choose>		
							</div>	
						</div>
						<p class="book_titleArea"><!--책제목 나오는 부분-->
							<a href="#" onClick="fn_Detail('${book.ucm_ucs_code }','${book.ucm_code}'); return false;">
								<span class="books_tit">${book.ucm_title }</span>
							</a>
						</p>
					</li>
				</c:forEach>
				</ul>
			</div>
		</section>
		<hr class="barGray" />
		</c:forEach>
		<c:if test="${not empty popularList }">
		<section class="detail_infoArea">
			<div class="detail_subTit">이 분야의 인기 도서</div>
			<div class="bookArea_scroll"><!-- 도서 나열 -->
				<ul class="book_list display_inFlex ">
				<c:forEach items="${popularList }" var="list">
					<li class="book_item">
						<div class="book_cover" id="${list.ucm_code }">
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
							<div class="p_Bookcover" id="${list.ucm_code }">
								<c:choose>
									<c:when test="${empty list.ucm_cover_url }">
									<img class="cover" src="/images/img_coverNot.png" alt="" />
									</c:when>
									<c:otherwise>
									<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
									</c:otherwise>
								</c:choose>		
							</div>	
						</div>
						<p class="book_titleArea"><!--책제목 나오는 부분-->
							<span class="books_tit">${list.ucm_title }</span>
						</p>
					</li>
				</c:forEach>
				</ul>
			</div>
		</section>
		
		</c:if>
		<!-- 하단 버튼들 고정으로 나오는 부분 -->
		<div class="btn_bottomArea">
			<div class="btn_bottomBox" style="justify-content:center;">
				<c:choose>
				<c:when test='${cmVO.ucm_webdrm_yn eq "Y" }'>
				<button type="button" class="btn_detail_read" id='${cmVO.ucm_code }_Btn' onClick="webviewer_Btn('${cmVO.ucm_code }','${cmVO.ume_code}')">바로 읽기</button>
				</c:when>
				<c:otherwise>
				<button type="button" class="btn_detail_read" id='${cmVO.ucm_code }_Btn'>바로 읽기 미지원</button>
				</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	</main>
	<%@include file="../common/m_footer.jsp" %>
	<button class="btn_goTop mb_distan" onclick="javascript:fn_goTop();">
		<span class="blind">상단으로 이동</span>
	</button>
</body>
</html>