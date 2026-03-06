<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	
});

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

// 동적 로딩된 썸네일까지 모두 동작하도록 "위임 바인딩" 사용
// .book 래퍼(혹은 필요한 부모)에 data- 속성으로 코드를 실어두세요.
// 예) <div class="book" data-ucm-code="B123" data-ucs-code="S456"> <img class="cover" ...> </div>
$(document).on('click', '.book img.cover', function (e) {
  e.preventDefault();

  const $frm = $('#frm'); // 제출할 폼 스코프
  const $book = $(this).closest('.book');

  // 권장: data-ucm-code / data-ucs-code 사용
  // (레거시 대비: 부모 id/속성에서 백업으로 가져오도록 안전장치 포함)
  const ucmCode = $book.data('ucmCode') || $(this).parent().attr('id') || '';
  const ucsCode = $book.data('ucsCode') || $(this).parent().attr('ucm_ucs_code') || '';

  ensureHidden($frm, 'ucm_code', ucmCode);
  ensureHidden($frm, 'ucm_ucs_code', ucsCode);

  $frm.attr('action', DETAIL_URL).trigger('submit');
});

// 별도 상세 이동 함수(버튼/링크 등에서 호출)
function fn_Detail(ucm_ucs_code, ucm_code) {
  const $frm = $('#frm2');

  ensureHidden($frm, 'ucm_code', ucm_code || '');
  ensureHidden($frm, 'ucm_ucs_code', ucm_ucs_code || '');

  $frm.attr('action', DETAIL_URL).trigger('submit');
}

function fn_view_mode(mode){
	$("#viewMode").val(mode);

	$("#frm").attr("action", oldAction)
	$("#frm").submit();

}

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

$(document).on('click', '.bt-func-library', function () {
	// ajax 내 서재 추가 or 삭제
	uis_return_ui_flag = '${sessionScope.UIS_RETURN_UI_FLAG}';
	
	const $btn = $(this);
    const $item = $btn.closest('.book-item');

    const ume_ucm_code = $item.data('ucm-code');
    const ume_code = $item.data('ume-code');		// 있으면 삭제, 없으면 추가
    var ume_codes = $item.data('ume_codes');
    
    if(ume_codes == null || ume_codes == ''){
		ume_codes = new Array();
		ume_codes[0] = null;
	}

    const isAdded = $btn.hasClass('is-added');
    
   /*  console.log("ume_ucm_code,", ume_ucm_code);
    console.log("ume_code,", ume_code); */
    
    $.ajax( {
	    url: '/front/home/readBookService.json',
	    data: {
	    	ume_code: isAdded ? ume_code : '', 
	    	ume_ucm_code: ume_ucm_code, 
	    	ume_codes: ume_codes },
		dataType: 'json',
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		success: function( data ) {
			if(data.count > 0 ){
				if (!isAdded) {
					alert("내 서재에 추가되었습니다.");
					var resultData = data.resultMsg
					
					// 추가/대출
	                $btn.addClass('is-added')
	                    .text(uis_return_ui_flag === 'Y' ? '- 반납' : '- 내서재에서 삭제');
	                $item.data('ume-code', resultData);
	                $item.attr('data-ume-code', resultData);
				} else {
					alert("내 서재에 삭제되었습니다.");
	
					// 삭제/반납
	                $btn.removeClass('is-added')
	                    .text(uis_return_ui_flag === 'Y' ? '+ 대출' : '+ 내서재에 추가');
	                $item.attr('data-ume-code', '');
	                $item.removeData('ume-code');
				}
			} else {
				alert(data.resultMsg);
			}
		},
		error: function() {
			alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
		}
    }); 
});

$(document).on('click', '.bt-func-read', function () {
	// ajax 내 서재 추가 or 삭제
	uis_return_ui_flag = '${sessionScope.UIS_RETURN_UI_FLAG}';
	
	const $btn = $(this);
    const $item = $btn.closest('.book-item');
    const $libBtn  = $item.find('.bt-func-library');		// 같은 도서의 library 버튼

    const ucm_code = $item.data('ucm-code');
    const ume_code = $item.data('ume-code'); 				// 있으면 삭제, 없으면 추가
    
    /* console.log("ucm_code,", ucm_code);
    console.log("ume_code,", ume_code); */
     
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
				var url = '/login.do';
				location.replace(url);
			} else if (data.count == -21){
				alert(data.resultMsg);
			} else {
				 window.open(data.resultMsg,"content");
				
				// 이미 내서재/대출 상태면 아무 것도 안 함
			    if ($libBtn.hasClass('is-added')) {
			        return;
			    }
				// 추가/대출
                $libBtn.addClass('is-added')
                    .text(uis_return_ui_flag === 'Y' ? '- 반납' : '- 내서재에서 삭제');
                $item.data('ume-code', data.umeCode);
			}
		},
		error: function(resultMsg) {
			alert(resultMsg);
		}
	});
    
});
</script>
<style>

/* 표지 이미지 영역 */
.coverArea {
  width: 100%;
  height: 180px;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

/* 이미지 감싸는 book 박스 */
.book {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

/* 표지 이미지 스타일 */
.book img.cover {
  height: 100%;
  width: auto;
  object-fit: contain;
  display: block;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}

</style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/gtmbody.jsp" %>
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
		<div class="reportDetail">
			<a href="/front/home/main.do"><img src="/images/icon_back.png" alt="" /></a>
			<span>${groupName}</span>
		</div>
		<hr/>
	</div>
	<div id="container">
		<div class="content">
			<form name="frm" id="frm" action="/front/home/recommendList.do" method="post">
				<input type="hidden" id="uil_code" name="uil_code" value="${frontCmVO.uil_code}" />
				<input type="hidden" id="viewMode" name="viewMode" value="${searchVO.viewMode }" />
			</form>
			<form name="frm2" id="frm2" action="/front/home/bookDetail.do" method="post">
			</form>
			<div class="viewSetting">
				<div class="viewTypeArea">
					<div class="view_thumbnail" onClick="javascript:fn_view_mode('S')">
						<c:choose>
						<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
							<img src="/images/v2/icon/icon_thumbnail_view_on.png" alt="" />
						</c:when>
						<c:otherwise>
							<img src="/images/v2/icon/icon_thumbnail_view_off.png" alt="" />
						</c:otherwise>
						</c:choose>
					</div>
					<div class="view_list" onClick="javascript:fn_view_mode('L')">
						<c:choose>
						<c:when test="${searchVO.viewMode eq 'L'}">
							<img src="/images/v2/icon/icon_listview_on.png" alt="" />
						</c:when>
						<c:otherwise>
							<img src="/images/v2/icon/icon_listview_off.png" alt="" />
						</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
			<!-- 섬네일 뷰 or 리스트 뷰 div class 설정 -->
			<div
			<c:choose>
			<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
			class="cardList_thumbnail"
			</c:when>
			<c:otherwise>
			class="cardList_listType listFlex"
			</c:otherwise>
			</c:choose>>
				<ul>
				<c:choose>
				<c:when test="${empty chooseCmList }">
					<li style="width:800px;text-align:center;">
						해당 도서가 존재하지 않습니다.
					</li>
				</c:when>
				<c:otherwise>
				<c:forEach items="${chooseCmList }" var="list" varStatus="status">
					<!-- 섬네일 모드 -->
					<c:choose>
					<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
					<li>
						<div class="coverArea">
							<div class="book" id="${list.ucm_code }">
								<!-- 19금 도서 노출 유무 -->
								<c:if test="${mainList.uis_use_adult_book eq 'Y' }">
									<c:if test="${list.ucm_limit_age eq 'R' }">
									<img class="badge_adult" src="/images/icon_adult.png" alt="" />
									</c:if>
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
						
						<div class="bookTitle" title="${list.ucm_title }">${list.ucm_title } </div>
						<div class="infoAuthorName">${list.ucm_writer }</div>
						<div class="viewStatus">
							<p class="count"><em>${list.ucm_read_count}</em>명이 읽고 있어요</p>
						</div>
					</li>
					<c:if test="${(status.count % 6 ne 0)}">
					<li class="empty"></li>
					</c:if>
					</c:when>
					<c:otherwise>
					<!-- 리스트 모드 -->
					<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume-codes="">
						<div class="coverArea">
							<div class="book" id="${list.ucm_code }" series="${list.ucm_ucs_code }">
								<!-- 19금 도서 노출 유무 -->
								<c:if test="${mainList.uis_use_adult_book eq 'Y' }">
									<c:if test="${list.ucm_limit_age eq 'R' }">
									<img class="badge_adult" src="/images/icon_adult.png" alt="" />
									</c:if>
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
						<div class="InfoArea">
							<div class="infoBookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
							<div class="infoAuthorName">${list.ucm_writer }</div>
							<div class="infoPublisher">${list.ucp_brand }</div>
							<div class="infoBookSummary">${list.ucm_intro }</div>
						</div>
						<div class="listBtnArea">
							<c:if test="${sessionScope.UIS_RETURN_FLAG eq 'N'}">
							<div class="status">
								<p class="count"><em>${list.ucm_read_count}</em>명이 읽고 있어요</p>
							</div>
							</c:if>
							<div class="btnWrap">
						        <button type="button" style="display:none" class="bt-func-library ${not empty list.ume_code ? 'is-added' : ''}">
						        <c:choose>
							        <c:when test="${sessionScope.UIS_RETURN_UI_FLAG eq 'Y'}">
							            ${not empty list.ume_code ? '- 반납' : '+ 대출'}
							        </c:when>
							        <c:otherwise>
							            ${not empty list.ume_code ? '- 내서재에서 삭제' : '+ 내서재에 추가'}
							        </c:otherwise>
							    </c:choose>
						        </button>
								<c:if test="${list.ucm_webdrm_yn eq 'Y'}">
								<button type="button" class="bt-func-read">바로읽기</button>
								</c:if>
							</div>
						</div>
					</li>
					</c:otherwise>
					</c:choose>
				</c:forEach>
				</c:otherwise>
				</c:choose>
				</ul>
			</div>
			<div class="page_pn">
				<ul>
					<c:if test="${not empty chooseCmList }">
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
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
