<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<link type="text/css" rel="stylesheet" href="/css/WolfHaruSlider.css" />
<script type="text/javascript" src="/js/jquery.WolfHaruSlider-0.1.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$('.WolfHaruSlider').WolfHaruSlider();
	if('${not empty cmVO.ume_code and cmVO.ume_code ne "" and cmVO.ume_status eq "N"}' == 'true'){
		$(".delete_myLibrary").hide();
		$(".add_myLibrary").show();
	}
	// 썸네일형 도서리스트 커버 영역 감싸고 상세 페이지 링크 연결
	$(".book img.cover").on("click", function() {
		
		var frm = $("#frm");

		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("id"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("id") +'">');
		}
		
		$("#frm").attr("action","/front/home/bookDetail.do");
		
		frm.submit();
	});
	
	// 독서감상문 좋아요 버튼(빈 하트일 경우). 타인의 독서감상문 좋아요 하기
	$(".like_off").on("click", function() {
		
		var like_off = $(this).attr("id");
		var ucm_code = $(this).attr("id").split("_")[2];
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/home/bookDetailLikeStateService.json",
			data: {"uclc_code" : '', "uclc_ucm_code": ucm_code },
			dataType: "json",
			timeout: 3000,
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					$("#"+like_off).css("display","none");
					$("#"+like_on).css("display","inline-block");
					var Like=$("#count_"+ucm_code).text();//좋아요 값
					var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
					$("#count_"+ucm_code).text(LikeNum+1);//나의 좋아요 클릭으로 카운트+1
					
					$("#uclc_code_"+ucm_code).val(data.resultMsg);
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
		
		
	});
	// 독서감상문 좋아요 취소(채워진 하트일 경우). 타인의 독서감상문 좋아요 취소하기
	$(".like_on").on("click", function() {

		var ucm_code = $(this).attr("id").split("_")[2];
		var like_off = "like_off_"+ucm_code;
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/home/bookDetailLikeStateService.json",
			data: {"uclc_code" : $("#uclc_code_"+ucm_code).val(), "uclc_ucm_code": ucm_code },
			dataType: "json",
			timeout: 3000,
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					$("#"+like_on).css("display","none");
					$("#"+like_off).css("display","inline-block");
					var Like=$("#count_"+ucm_code).text();//좋아요 값
					var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
					$("#count_"+ucm_code).text(LikeNum-1);//나의 좋아요 클릭으로 카운트-1
					$("#uclc_code").val("");
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
		
		
	});
	
});

var oldAction = $("#frm2").attr("action")
function fn_search(uct_type, uct_code){
	$("#uct_type").val(uct_type);
	$("#uct_code").val(uct_code);

	$("#frm2").attr("action","/front/home/categoryList.do");
	$("#frm2").submit();
}
function fn_save_library(ume_code, ume_ucm_code, ume_codes){
	// ajax 내 서재 추가 or 삭제
	if(ume_codes == null || ume_codes == ''){
		ume_codes = new Array();
		ume_codes[0] = null;
	}
	$.ajax( {
		url: "/front/home/readBookService.json",
		data: {"ume_code" : ume_code, "ume_ucm_code" : ume_ucm_code, "ume_codes" : ume_codes },
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		success: function( data ) {
			if(data.count > 0 ){
				if(ume_code == ""){
					alert("내 서재에 추가되었습니다.");
					var resultData = data.resultMsg
					$(".add_myLibrary").hide();
					$(".delete_myLibrary").show();
					$(".delete_myLibrary").attr("onClick", "fn_save_library('"+resultData+"','${cmVO.ucm_code}');");
				}else{
					alert("내 서재에 삭제되었습니다.");
					
					$(".add_myLibrary").show();
					$(".delete_myLibrary").hide();
				}
			} else {
				alert(data.resultMsg);
			}
		},
		error: function() {
			// $("#idCheck").val("N");
			alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
		}
	});
}

function fn_save_library_return_ui(ume_code, ume_ucm_code, ume_codes){
	// ajax 내 서재 추가 or 삭제
	if(ume_codes == null || ume_codes == ''){
		ume_codes = new Array();
		ume_codes[0] = null;
	}
	$.ajax( {
		url: "/front/home/readBookService.json",
		data: {"ume_code" : ume_code, "ume_ucm_code" : ume_ucm_code, "ume_codes" : ume_codes },
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		success: function( data ) {
			if(data.count > 0 ){
				if(ume_code == ""){
					alert("대출 처리 되었습니다.");
					var resultData = data.resultMsg
					$(".add_myLibrary").hide();
					$(".delete_myLibrary").show();
					$(".delete_myLibrary").attr("onClick", "fn_save_library_return_ui('"+resultData+"','${cmVO.ucm_code}');");
				}else{
					alert("반납 처리 되었습니다.");
					
					$(".add_myLibrary").show();
					$(".delete_myLibrary").hide();
				}
			} else {
				alert(data.resultMsg);
			}
		},
		error: function() {
			// $("#idCheck").val("N");
			alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
		}
	});
}

function fn_write_book_report(ume_finishread_count, ucm_code, ume_code, ubr_code){
	
	if(ume_finishread_count <= 0){
		alert("완독 후 이용가능합니다.");
		return false;
	}else{
		// ML_02_5.html
		
		var frm = $("#frm");
		
		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val(ucm_code)
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + ucm_code +'">');
		}
		
		if($("#selectUmeCode").length > 0 ){
			$("#selectUmeCode").val(ume_code)
		}
		else {
			frm.append('<input type="hidden" id="selectUmeCode" name="ume_code" value="' + ume_code +'">');
		}
		
		if($("#selectUbrCode").length > 0 ){
			$("#selectUbrCode").val(ubr_code)
		}
		else {
			frm.append('<input type="hidden" id="selectUbrCode" name="ubr_code" value="' + ubr_code +'">');
		}
		
		$("#frm").attr("action","/front/myLibrary/writeReportBook.do");
		
		frm.submit();
	}
	
}
function preview_click() {
	var url= "https://www.bookers.life/front/preview/viewer.do?ucm_code=${cmVO.ucm_code}";    //팝업창에 출력될 페이지 URL
	var winWidth = 768;
	var winHeight = 704.4;
	var popupOption= "width="+winWidth+", height="+winHeight;    //팝업창 옵션(optoin)
	var myWindow = window.open(url,"미리보기",popupOption);
}
	
function webviewer_Btn(ucm_code, ume_code){
	
	$.ajax( {
		url: "/front/myLibrary/webViewer.json",
		data: {"ucm_code" : ucm_code, "ume_code" : ume_code },
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		async : false,
		success: function( data ) {
			if (data.count == 0){
				alert(data.resultMsg);
			} else if (data.count == -1){
				alert(data.resultMsg);
				var url = '/login';
				location.replace(url);
			} else if (data.count == -21){
				alert(data.resultMsg);
			} else {
				window.open(data.resultMsg,"content");
				$(".add_myLibrary").hide();
				$(".delete_myLibrary").show();
				
			}
			
		},
		error: function(resultMsg) {
			// $("#idCheck").val("N");
			alert(resultMsg);
		}
	});

}


//상세 페이지 액션 URL(공통)
const DETAIL_URL = "/front/home/bookDetail.do";

// 유틸: 주어진 폼 안에 name 기준 hidden input을 보장 생성/값 세팅
function ensureHidden($form, name, value) {
  let $input = $form.find('input[name="' + name + '"]');
  if ($input.length === 0) {
    $input = $('<input/>', { type: 'hidden', name: name });
    $form.append($input);
  }
  $input.val(value);
}

//별도 상세 이동 함수(버튼/링크 등에서 호출)
function fn_Detail(ucm_ucs_code, ucm_code) {
  const $frm = $('#frm');

  ensureHidden($frm, 'ucm_code', ucm_code || '');
  ensureHidden($frm, 'ucm_ucs_code', ucm_ucs_code || '');

  $frm.attr('action', DETAIL_URL).trigger('submit');
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
		<form name="frm" id="frm" action="/front/home/recommendList.do" method="post">
		</form>
		<form name="frm2" id="frm2" action="/front/home/categoryList.do" method="post">
				<input type="hidden" id="viewMode" name="viewMode" value="S" />
				<input type="hidden" id="uct_code" name="uct_code" value="${cmVO.uct_code }" />
				<input type="hidden" id="uct_type" name="uct_type" value="${cmVO.uct_type }" />
		</form>
		<div class="content">
			
			<div class="coverArea2">
				<div class="book2">
					<!-- 19금 도서 노출 유무 -->
					<c:if test="${cmVO.ucm_limit_age eq 'Y' }">
					<img class="badge_adult" src="/images/icon_adult_lg.png" alt="" />
					</c:if>
					<!-- 파일 형태 -->
					<c:choose>
					<c:when test='${cmVO.ucm_file_type eq "PDF" }'>
					<img class="book_badge_big" src="/images/icon_pdf_lg.png" alt="" />
					</c:when>
					<c:when test='${cmVO.ucm_file_type eq "ZIP" or cmVO.ucm_file_type eq "COMIC" }'>
					<img class="book_badge_big" src="/images/icon_comic_lg.png" alt="" />
					</c:when>
					<c:when test='${cmVO.ucm_file_type eq "AUDIO" }'>
					<img class="book_badge_big" src="/images/icon_audiobook_lg.png" alt="" />
					</c:when>
					<c:otherwise>
					
					</c:otherwise>
					</c:choose>
					<div class="cover2"><img src="<%=filePath %>${cmVO.ucm_cover_url }" width="270px;" height="394px;" alt=""/></div>
				</div>
				<!-- 22y1018 바로읽기와 미리보기 버튼 추가 및 수정 -->
				<c:if test="${cmVO.ucm_preview_flag eq 'Y' }">
					<button class="btn_preview" style="display:block;" onclick="preview_click();"><img src="/images/ic_preview.svg"><span>미리보기</span></button>
				</c:if>
			</div>
			<div class="infoArea2">
				<div class="cateTitle">
					<span class="cateName">
					<c:choose>
						<c:when test="${cmVO.uct_type eq 'E' }"><a href="#"  onClick="fn_search('${cmVO.uct_type }');">eBook</a></c:when>
						<c:when test="${cmVO.uct_type eq 'A' }"><a href="#"  onClick="fn_search('${cmVO.uct_type }');">오디오북</a></c:when>
						<c:otherwise>미분류</c:otherwise>
					</c:choose>
					</span>
					<img alt="" src="/images/ic_arrow.png">
					<span class="cateName"><a href="#"  onClick="fn_search('${cmVO.uct_type }','${cmVO.ucm_uct_code}');">${cmVO.uct_parent_name }</a></span>
					<img alt="" src="/images/ic_arrow.png">
					<span class="cateName"><a href="#"  onClick="fn_search('${cmVO.uct_type }','${cmVO.ucm_uct_code}');">${cmVO.uct_name }</a></span>
				</div>
				<div class="info_bookTitle2">${cmVO.ucm_title }</div>
				<div class="bookSubtitle2">${cmVO.ucm_sub_title }</div>
				<div class="authorName2">${cmVO.ucm_writer }</div>
				<div class="publisher2"><span class="txt_black">${cmVO.ucp_brand }</span> <img src="/images/ic-dot-gray.png">${cmVO.ucm_ebook_pubdate }</div>
				
				<c:if test="${not empty cmVO.uil_name and cmVO.uil_name ne ''}">
					<div class="recomendTitle">
						<div class="recomendBox">
							<span class="txt">${cmVO.uil_name}</span>
						</div>
					</div>
				</c:if>
				<div class="fileTypeWrap">
					<c:choose>
					<c:when test='${cmVO.ucm_file_type eq "EPUB" }'>
					<ul class="fileinfo01">
						<li><strong>파일정보 :</strong> ePUB <img src="/images/bar_filetype.png" alt="구분 바"></li>
						<li><strong>용량 :</strong> ${cmVO.ucm_filesize}<img src="/images/bar_filetype.png" alt="구분 바"></li>
						<li><strong>글자수 :</strong> 약 ${cmVO.ucm_text_count}자<img src="/images/bar_filetype.png"alt="구분 바"></li>
						<li><strong>듣기기능 :</strong><c:if test="${cmVO.ucm_support_tts eq 'Y' }">TTS 지원</c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> </li>
					</ul>

					</c:when>
					<c:when test='${cmVO.ucm_file_type eq "PDF" }'>
						<ul class="fileinfo01">
							<li><strong>파일정보 :</strong> PDF <img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>용량 :</strong> ${cmVO.ucm_filesize}<img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>페이지수 :</strong> ${ cmVO.ucm_paper_pages} <img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>듣기기능 :</strong><c:if test="${cmVO.ucm_support_tts eq 'Y' }">TTS 지원</c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> </li>
						</ul>

					</c:when>
					<c:when test='${cmVO.ucm_file_type eq "ZIP" or cmVO.ucm_file_type eq "COMIC"}'>
						<ul class="fileinfo01">
							<li><strong>파일정보 :</strong> COMIC <img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>용량 :</strong> ${cmVO.ucm_filesize}<img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>페이지수 :</strong> ${ cmVO.ucm_paper_pages} <img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>듣기기능 :</strong><c:if test="${cmVO.ucm_support_tts eq 'Y' }">TTS 지원</c:if><c:if test="${cmVO.ucm_support_tts eq 'N' }"><td>TTS 미지원</td></c:if> </li>
						</ul>

					</c:when>
					<c:otherwise>
						<ul class="fileinfo01">
							<li><strong>파일정보 :</strong> 오디오북 <img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>용량 :</strong> ${cmVO.ucm_filesize}<img src="/images/bar_filetype.png" alt="구분 바"></li>
							<li><strong>총 재생시간 :</strong> ${cmVO.ucm_total_playtime }</li>
							
						</ul>

					</c:otherwise>
					</c:choose>
				</div>
				
				<div class="notice_btnBoxs">
					<c:choose>
						<c:when test="${cmVO.uis_return_flag eq 'Y'}">
							<c:choose>
								<c:when test="${cmVO.uis_return_ui_flag eq 'Y'}">
									<c:choose>
										<c:when test="${cmVO.uis_copy_book_flag eq 'Y' and cmVO.ucm_copy_book_flag eq 'Y' and cmVO.copy_book_flag eq 1}">
											<c:choose>
												<c:when test="${cmVO.today_copy_count eq 0}">
													<div class="notice_limitedBook ">
													<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
													<div class="countNumBox"><strong>현재 열람 가능한 권수가 없습니다.</strong></div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="notice_limitedBook ">
													<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
													<div class="countNumBox">현재 <strong>${cmVO.today_copy_count}권 열람</strong>이 가능합니다.</div>
													</div>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${cmVO.today_copy_count eq 0}">
													<div class="notice_limitedBook ">
													<div class="countNumBox"><strong>현재 열람 가능한 권수가 없습니다.</strong></div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="notice_limitedBook ">
													<div class="countNumBox">현재 <strong>${cmVO.today_copy_count}권 열람</strong>이 가능합니다.</div>
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
													<div class="notice_limitedBook ">
													<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
													<div class="countNumBox"><strong>현재 열람 가능한 권수가 없습니다.</strong></div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="notice_limitedBook ">
													<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
													<div class="countNumBox">현재 <strong>${cmVO.today_copy_count}권 열람</strong>이 가능합니다.</div>
													</div>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:if test="${cmVO.uct_type eq 'E'}">
												<div class="readerNum2"><img src="/images/ic_readuser.svg"><span class="txt_number"><fmt:formatNumber value="${cmVO.ucm_read_count}" pattern="#,###"/></span>명이 읽고 있어요</div>
											</c:if>
											<c:if test="${cmVO.uct_type eq 'A'}">
												<div class="readerNum2"><img src="/images/ic_readuser.svg"><span class="txt_number"><fmt:formatNumber value="${cmVO.ucm_read_count}" pattern="#,###"/></span>명이 듣고 있어요</div>
											</c:if>
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
											<div class="notice_limitedBook ">
											<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
											<div class="countNumBox"><strong>현재 열람 가능한 권수가 없습니다.</strong></div>
											</div>
										</c:when>
										<c:otherwise>
											<div class="notice_limitedBook ">
											<div class="mark_limited"><img src="/images/img_limited.svg" alt="매일 선착순 알림 이미지"> <strong>매일 선착순</strong></div>
											<div class="countNumBox">현재 <strong>${cmVO.today_copy_count}권 열람</strong>이 가능합니다.</div>
											</div>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:if test="${cmVO.uct_type eq 'E'}">
										<div class="readerNum2"><img src="/images/ic_readuser.svg"><span class="txt_number"><fmt:formatNumber value="${cmVO.ucm_read_count}" pattern="#,###"/></span>명이 읽고 있어요</div>
									</c:if>
									<c:if test="${cmVO.uct_type eq 'A'}">
										<div class="readerNum2"><img src="/images/ic_readuser.svg"><span class="txt_number"><fmt:formatNumber value="${cmVO.ucm_read_count}" pattern="#,###"/></span>명이 듣고 있어요</div>
									</c:if>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>

					<!-- 독서토론하러가기 -->
					<div class="btn_debate" onclick="javascript:location.href='/front/lounge/discussionView.do?ucd_code=${cmVO.ucd_code}&ucm_code=${cmVO.ucm_code}'"><div class="debate_link">독서 토론 하러 가기</div></div>
				</div>
				<!-- 카운트 수 알림 or 책 읽고 있는 유저 수 and 독서 토론 이동 버튼 나오는 부분 끝 23y01.26 -->
				<c:if test="${cmVO.ucm_webdrm_yn eq 'N'}">
					<div class="NotsupportBox">
						<c:if test="${cmVO.uct_type eq 'E'}">
							<span class="txt_notsupport">해당 컨텐츠는 <strong>"바로읽기"</strong>를 지원하지 않습니다. 앱에서 이용해주세요!</span>
						</c:if>
						<c:if test="${cmVO.uct_type eq 'A'}">
							<span class="txt_notsupport">해당 컨텐츠는 <strong>"바로듣기"</strong>를 지원하지 않습니다. 앱에서 이용해주세요!</span>
						</c:if>
					</div>
				</c:if>
				<c:if test="${cmVO.uis_preview_flag eq 'Y'}">
					<div class="NotsupportBox">
						<span class="txt_notsupport">체험도서관에서는 미리보기만 가능 합니다.</span>
					</div>
				</c:if>
				<c:if test="${cmVO.uis_preview_flag eq 'N'}">
				<div style="clear:both;" class="bookDetail_btnGroup">
					

					
					
					
					
					
					
					<c:if test="${cmVO.ucm_webdrm_yn eq 'Y'}">
						<c:choose>
							<c:when test="${cmVO.ucm_copy_book_flag eq 'Y' and cmVO.uis_copy_book_flag eq 'Y' and cmVO.copy_book_flag eq 1}">
								<c:choose>
									<c:when test="${cmVO.copy_order_exist eq 0 and cmVO.today_copy_count eq 0}">
										<c:if test="${cmVO.uct_type eq 'E'}">
											<button type="button" class="detail_btn_nowRead" style="background-color: #ddd" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 읽기</button>
										</c:if>
										<c:if test="${cmVO.uct_type eq 'A'}">
											<button type="button" class="detail_btn_nowRead" style="background-color: #ddd" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 듣기</button>
										</c:if>
									</c:when>
									<c:otherwise>
										<c:if test="${cmVO.uct_type eq 'E'}">
											<button type="button" class="detail_btn_nowRead" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 읽기</button>
										</c:if>
										<c:if test="${cmVO.uct_type eq 'A'}">
											<button type="button" class="detail_btn_nowRead" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 듣기</button>
										</c:if>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:if test="${cmVO.uct_type eq 'E'}">
									<button type="button" class="detail_btn_nowRead" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 읽기</button>
								</c:if>
								<c:if test="${cmVO.uct_type eq 'A'}">
									<button type="button" class="detail_btn_nowRead" onclick="javascript:webviewer_Btn('${cmVO.ucm_code }', '${cmVO.ume_code}')">바로 듣기</button>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:if>
					<c:if test="${cmVO.ume_finishread_count ne '0' }">
					<button type="button" style="display:none" class="write_bookReport" onClick="fn_write_book_report('${cmVO.ume_finishread_count}', '${cmVO.ucm_code}', '${cmVO.ume_code }', '${cmVO.ubr_code }')">독서감상문 쓰기</button>
					</c:if>
					<!-- 22y1018 독서토론가기 큰 버튼 삭제 -->
					<!-- <button type="button" class="readingDebate" onClick="javascript:location.href='/front/lounge/discussionView.do?ucd_code=${cmVO.ucd_code}&ucm_code=${cmVO.ucm_code }'">독서 토론 가기</button> -->
					
					<div class="likeBox">
						<c:choose>
						<c:when test="${cmVO.uclc_type eq 'Y' }">
						<input type="hidden" id="uclc_code_${cmVO.ucm_code }" value="${cmVO.uclc_code }" />
						<div class="like_on" id="like_on_${cmVO.ucm_code }" style="display:inline-block;"><img src="/images/ic_favorite_on.svg" alt="" /></div>
						<div class="like_off" id="like_off_${cmVO.ucm_code }" style="display:none;"><img src="/images/ic_favorite_off.svg" alt="" /></div>
						</c:when>
						<c:otherwise>
						<input type="hidden" id="uclc_code_${cmVO.ucm_code }" value="${cmVO.uclc_code }"/>
						<div class="like_off" id="like_off_${cmVO.ucm_code }"><img src="/images/ic_favorite_off.svg" alt="" /></div>
						<div class="like_on" id="like_on_${cmVO.ucm_code }"><img src="/images/ic_favorite_on.svg" alt="" /></div>
						</c:otherwise>
						</c:choose>
						<span class="likeCount" id="count_${cmVO.ucm_code }"><fmt:formatNumber value="${cmVO.uclc_like }" pattern="#,###" /></span>
					</div>	
				</div>
				</c:if>	
			</div>
			<div style="clear:both;"></div>
			<!--  
			<c:if test="${not empty cmVO.ucm_ucs_code and cmVO.ucm_ucs_code ne ''}">
				<div class="bookDetail_Notice">
					<div class="title mT_10"><img class="mR_10" src="/images/icon_info.png" alt="" />안내</div>
					<div class="txt"></div>
				</div>
			</c:if>
			-->

			<c:if test="${not empty cmVO.ucm_intro and cmVO.ucm_intro ne ''}">
			<%
			pageContext.setAttribute("crcn", "\n"); 
		    pageContext.setAttribute("br", "</br>");
		    pageContext.setAttribute("space", "\u00A0");
		    pageContext.setAttribute("nbsp", " ");
			%>
			<div class="eachArea book_introduce">
				<div class="infoTitle">책 소개</div>
				<div class="infoTxt">
					<p>${fn:replace(fn:replace(cmVO.ucm_intro,crcn,br),space,nbsp) }</p>
				</div>
				<div class="Unfold">펼쳐보기</div>
			</div>
			
			</c:if>
			
			<c:if test="${not empty cmVO.ucm_intro_img_url and cmVO.ucm_intro_img_url ne ''}">
			<div class="eachArea book_cardnews">
			<div class="infoTitle">카드뉴스</div>
				<div class="WolfHaruSlider">
					<div class="WolfHaruSliderImgWrap">
						<div class="WolfHaruSliderImgBox">
							<div class="WolfHaruSliderImgContent">
								<ul class="WolfHaruSliderImgList">
									<c:forEach items="${introList }" var="item" varStatus="status">
									<li>
										<img src="https://files.bookers.life${item}"/>
									</li>
									
									</c:forEach>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${not empty cmVO.ucm_intro_movie_url and cmVO.ucm_intro_movie_url ne ''}">
			<div class="eachArea book_movie">
				<div class="infoTitle">소개 영상</div>
				<div class="info_movie_url">
					${cmVO.ucm_intro_movie_url}
				</div>
			</div>
			</c:if>
			
			<!-- 시리즈 정보 -->
			<c:if test="${not empty cmVO.ucm_ucs_code and cmVO.ucm_ucs_code ne ''}">
			<div class="eachArea book_series">
				<div class="infoTitle">이 책의 시리즈</div>
				<div class="cardList_thumbnail mT_30">
					<ul>
						<c:forEach items="${seriesList }" var="list" varStatus="status">
						<li>
							<div class="coverArea">
								<div class="book" id="${list.ucm_code }">
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
									
									<!-- 표지 이미지 -->
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
							<div class="bookTitle">${list.ucm_title }</div>
						</li>
						<c:if test="${(status.count % 6 ne 0)}">
						<li class="empty"></li>
						</c:if>
						</c:forEach>
					</ul>
				</div>
				<c:if test="${fn:length(seriesList) > 6 }">
				<div class="Unfold">펼쳐보기</div>
				</c:if>
				
			</div>
			</c:if>
			<c:if test="${not empty cmVO.ucm_toc and cmVO.ucm_toc ne ''}">
			<div class="eachArea book_navi">
				<div class="infoTitle">목차</div>
				<div class="infoTxt">
					<p>${fn:replace(fn:replace(cmVO.ucm_toc,crcn,br),space,nbsp) }</p>
				</div>
				<div class="Unfold">펼쳐보기</div>
			</div>
			</c:if>
			<c:if test="${not empty cmVO.ucm_review and cmVO.ucm_review ne ''}">
			<div class="eachArea book_author">
				<div class="infoTitle">저자 소개</div>
				<div class="infoTxt">
					<p>${fn:replace(cmVO.ucm_review,crcn,br) }</p>
				</div>
				<div class="Unfold">펼쳐보기</div>
			</div>
			</c:if>
			<c:if test="${not empty cmVO.ucm_publish_review and cmVO.ucm_publish_review ne ''}">
			<div class="eachArea book_publisherReview">
				<div class="infoTitle">출판사 리뷰</div>
				<div class="infoTxt">
					<p>${fn:replace(fn:replace(cmVO.ucm_publish_review,crcn,br),space,nbsp) }</p>
				</div>
				<div class="Unfold">펼쳐보기</div>
			</div>
			</c:if>

			<c:forEach items="${curation }" var="curationList">
			<div class="eachArea book_curation">
				<div class="infoTitle">
					<a href="/front/home/recommendList.do?uil_code=${curationList.uil_code }" class="cardList_detail"><span class="txtPart">${curationList.uil_name }</span>
					<img src="/images/icon_more_view.png" alt="" /></a>
				</div>
				<div class="cardList_wrap swiper-container" style="height:310px">
					<ul class="cardList_content swiper-wrapper">
						<c:forEach items="${curationList.bookList }" var="book">
						<li class="swiper-slide">
							<div class="coverArea">
								<div class="book" id="${book.ucm_code }" series="${book.ucm_ucs_code }">
									<!-- 19금 도서 노출 유무 -->
									<c:if test="${curationList.uis_use_adult_book eq 'Y' }">
										<c:if test="${book.ucm_limit_age eq 'R' }">
										<img class="badge_adult" src="/images/icon_adult.png" alt="" />
										</c:if>
									</c:if>
									<!-- 파일 형태 -->
									<c:choose>
									<c:when test='${book.ucm_file_type eq "PDF" }'>
									<img class="book_badge" src="/images/icon_pdf.png" alt="" />
									</c:when>
									<c:when test='${book.ucm_file_type eq "ZIP" or book.ucm_file_type eq "COMIC" }'>
									<img class="book_badge" src="/images/icon_comic.png" alt="" />
									</c:when>
									<c:when test='${book.ucm_file_type eq "AUDIO" }'>
									<img class="book_badge" src="/images/icon_audiobook.png" alt="" />
									</c:when>
									<c:otherwise>
									</c:otherwise>
									</c:choose>
									<!-- 표지 이미지 -->
									<c:choose>
									<c:when test="${empty book.ucm_cover_url }">
									<img class="cover" src="/images/img_coverNot.png" alt="" />
									</c:when>
									<c:otherwise>
									<img class="cover" src="https://files.bookers.life${book.ucm_cover_url }" alt="" />
									</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div class="bookTitle_recomand"><a href="#" onClick="fn_Detail('${book.ucm_ucs_code }','${book.ucm_code}');return false;">${book.ucm_title }</a></div>
							<div class="infoAuthorName2">${book.ucm_writer }</div>
						</li>
						</c:forEach>
					</ul>
					<c:if test="${curationList.book_count > 6 }">
					<div class="cardList_btn">
						<div class="btn1 swiper-button-next"><img src="/images/btn_slide_next.png" alt="다음 버튼" class="next"></div>
						<div class="btn2 swiper-button-prev"><img src="/images/btn_slide_prev.png" alt="이전 버튼" class="prev"></div>
					</div>
					</c:if>
				</div>
			</div>
			</c:forEach>
			<c:if test="${not empty popularList }">
			<div class="eachArea book_popular">
				<div class="infoTitle">이 분야의 인기도서</div>
				<div class="cardList_wrap swiper-container mT_30">
					<ul class="cardList_content swiper-wrapper">
						<c:forEach items="${popularList }" var="list">
						<li class="swiper-slide">
							<div class="coverArea">
								<div class="book" id="${list.ucm_code }">
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
									
									<!-- 표지 이미지 -->
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
							<div class="bookTitle_recomand">${list.ucm_title }</div>
						</li>
						</c:forEach>
					</ul>
					<c:if test="${fn:length(popularList) > 6 }">
					<div class="cardList_btn">
						<div class="btn1 swiper-button-next"><img src="/images/btn_slide_next.png" alt="다음 버튼" class="next"></div>
						<div class="btn2 swiper-button-prev"><img src="/images/btn_slide_prev.png" alt="이전 버튼" class="prev"></div>
					</div>
					</c:if>
				</div>
			</div>
			</c:if>
			<!--  div class="infoOffer_Box">
				<div class="itemArea">
					정보제공 : <img class="cover" src="/images/aladin_logo.png" alt="" />
				</div>
				<div class="linkArea">
					<button class="gobuy" onclick="javascript:alert('준비중 입니다.');">종이책 구매하기</button>
				</div>
			</div -->
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
