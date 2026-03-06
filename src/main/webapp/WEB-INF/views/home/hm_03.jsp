<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	const uct_type = '${searchVO.uct_type}';
	const uct_code = '${searchVO.uct_code}';
	const uct_sub_code = '${searchVO.uct_parent}'; // 상위 카테고리 
	
	const $menu = $('.bookMenuCategory');
	const $menuWrap = $('#bookMenuCategory');
	const $form = $('#frm');
    const $sortSelect = $('#selectSortField');
    const $hiddenSort = $('#sortField1');
	
    const stored = sessionStorage.getItem('bookMenuOpen_hm03');
    const isOpen = stored === null ? true : stored === 'Y'; // 아무 값이 없을 때는 true 
    const bookMenuOpen_hm03_stop = sessionStorage.getItem('bookMenuOpen_hm03_stop')
	
	/* =========================
     * 카테고리 열림 여부
     * ========================= */
    const hasMainCategory = !!(uct_type && uct_type.trim());

    if (bookMenuOpen_hm03_stop === 'Y' && hasMainCategory) { // 고정 시키는 서브밋 이면 true 열림 
    	$menu.toggleClass('open', isOpen);
    } else {
    	$menu.toggleClass('open', hasMainCategory);
    }
	
	/* =========================
     * 이북 / 오디오북 메뉴 노출
     * ========================= */
    if (uct_type === 'E' || uct_type === 'A') {
        $menuWrap.show();
    } else {
        $menuWrap.hide();
    }
	
    /* =========================
     * 정렬 방식 변경
     * ========================= */
    $sortSelect.on('change', function () {
        const oldAction = $form.attr('action');
        const selectedValue = $(this).val();

        $hiddenSort.val(selectedValue);
        sessionStorage.setItem('bookMenuOpen_hm03_stop', 'Y');
        $form.attr('action', oldAction);
        $form.submit();
    });
    
 	// 카테고리 펼침 상태값 
    $('#toggleButton').on('click', function () {
    	const $menu = $('.bookMenuCategory');

        $menu.toggleClass('open');

        if ($menu.hasClass('open')) {
        	sessionStorage.setItem('bookMenuOpen_hm03', "Y");
        } else {
        	sessionStorage.setItem('bookMenuOpen_hm03', "N");
        }
    });
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

function fn_search(uct_type, uct_code, uct_parent){
	$("#uct_type").val(uct_type);
	$("#uct_code").val(uct_code);
	$("#uct_parent").val(uct_parent);

	sessionStorage.setItem('bookMenuOpen_hm03_stop', 'N');
	$("#frm").attr("action", oldAction)
	$("#frm").submit();
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

	$(document).on('click', '.make_select .select-items div', function () {
		const text = $(this).text().trim();
	    let val = '';

	    if (text === '일간') val = 'D';
	    else if (text === '주간') val = 'W';
	    else if (text === '월간') val = 'M';

	    // 실제 select 값 변경 + change 트리거 1
	    $('#searchName2').val(val).trigger('change');
	});
	
	$(document).on('change', '#searchName2', function () {
		const val = this.value; // D / W / M
		sessionStorage.setItem('bookMenuOpen_hm03_stop', 'Y');
		$('#frm').trigger('submit');
	});
	
	$(document).on('click', '#btnAllOrg', function () {
	    $('#searchName3').val('ALL');   // 전체 기관
	    $('#frm').trigger('submit');
	});

	$(document).on('click', '#btnOrg', function () {
	    $('#searchName3').val('MY');    // 내 기관
	    $('#frm').trigger('submit');
	});
	
	$(document).on('submit', '#frm', function (e) {
		/* e.preventDefault();
		console.log('검증만 함'); */
	});

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
					<a href="/front/home/main.do">추천</a>
				</li>
				<li>
					<a href="/front/home/newBookList.do">최신 업데이트</a>
				</li>
				<li>
					<a href="/front/home/popularList.do" class="nav_focus">인기</a>
				</li>
				<li>
					<a href="/front/home/categoryList.do">주제별</a>
					<c:if test="${hasEbook or hasAudio}">
					<div class="depth-sub">
						<c:if test="${hasEbook}">
						<a href="/front/home/categoryList.do?uct_type=E" class="<c:if test="${searchVO.uct_type eq 'E'}">on</c:if>">eBook</a>
						</c:if>
						<c:if test="${hasAudio}">
						<a href="/front/home/categoryList.do?uct_type=A" class="<c:if test="${searchVO.uct_type eq 'A'}">on</c:if>">오디오북</a>
						</c:if>
					</div>
					</c:if>
				</li>
			</ul>
		</nav>
		<hr/>
	</div>
	<div id="container">
		<div class="content">
			<form name="frm" id="frm" action="/front/home/popularList.do" method="post">
				<input type="hidden" id="viewMode" name="viewMode" value="${searchVO.viewMode }" />
				<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
				<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
				<input type="hidden" id="uct_parent" name="uct_parent" value="${searchVO.uct_parent }" />
				<input type="hidden" id="searchName2" name="searchName2" value="${searchVO.searchName2 }" />
				<input type="hidden" id="searchName3" name="searchName3" value="${searchVO.searchName3 }" />
			</form>
			<form name="frm2" id="frm2" action="/front/home/bookDetail.do" method="post">
			</form>
			<div class="viewSetting lineType"><!-- 251119 [고] : lineType class명 추가 -->
				<div class="bookTypeArea">
					<c:if test="${hasAll}">
					<div class="bookAll <c:if test="${searchVO.uct_type eq ''}">bookType_focus</c:if>" onClick="javascript:fn_search('','');">전체</div>
					</c:if>
					<c:if test="${hasEbook}">
					<!-- ebook 탭 -->
					<div class="book_ebook <c:if test="${searchVO.uct_type eq 'E'}">bookType_focus</c:if>" onClick="javascript:fn_search('E','');">eBook</div>
					</c:if>
					<c:if test="${hasAudio}">
					 <!-- 오디오북 탭 -->
					<div class="book_audiobook <c:if test="${searchVO.uct_type eq 'A'}">bookType_focus</c:if>" onClick="javascript:fn_search('A','');">오디오북</div>
					</c:if>
				</div>
				<c:if test="${sessionScope.UIS_RETURN_FLAG eq 'N'}"> 
				<div class="instTypeArea"><!-- 251119 [고] : instTypeArea 탭 추가 -->
					<button type="button" class="${searchVO.searchName3 eq 'ALL' ? 'on' : ''}" id="btnAllOrg">전체 기관</button>
					<button type="button" class="${searchVO.searchName3 eq 'MY' ? 'on' : ''}" id="btnOrg">내 기관</button>
				</div>
				</c:if>
				<!-- 251119 [고] : 카테고리 메뉴  -->
				<div class="bookMenuCategory" id="bookMenuCategory">
					<div class="cateGroup">
					<c:forEach items="${categoryMainList }" var="list" varStatus="status">
						<!-- 8개 묶음 시작 -->
						<c:if test="${status.index % 8 == 0}">
						<div class="cateRow" data-row="${status.index / 8}">
							<div class="cateDepth depth1">
								<ul>
						</c:if>
									<li>
										<a href="#" 
										onclick="javascript:fn_search('${list.uct_type }','${list.uct_code }','${list.uct_code }');" class="item 
										<c:if test="${not empty searchVO.uct_code and searchVO.uct_code eq list.uct_code and list.uct_code ne '' }">selected</c:if>
										<c:if test="${not empty searchVO.uct_parent and searchVO.uct_parent eq list.uct_code and searchVO.uct_code ne searchVO.uct_parent}">selected</c:if>
										<c:if test="${empty searchVO.uct_code and empty list.uct_code }">selected-all</c:if>
									">
									${list.uct_name }</a>
									</li>
						<!-- 8개 묶음 종료 -->
				    <c:if test="${status.index % 8 == 7 || status.last}">
				                </ul>
				            </div>
				            <!-- Depth2는 row 단위로 하나만 -->
							<c:set var="rowIndex" value="${(status.index - (status.index mod 8)) div 8}" />
							<div class="cateDepth depth2" style="${rowIndex.intValue() == selectedRowIndex ? '' : 'display:none'}">
								<c:if test="${rowIndex.intValue() == selectedRowIndex}">
								<ul>
								<c:forEach items="${categorySubList }" var="subList" varStatus="subStatus">
									<li><a href="#" 
										onclick="javascript:fn_search('${subList.uct_type }','${subList.uct_code }','${subList.uct_parent }');" class="item 
										<c:if test="${not empty subList.uct_code and searchVO.uct_code eq subList.uct_code}">selected</c:if>
										<c:if test="${empty subList.uct_code and searchVO.uct_code eq subList.uct_parent}">selected-all</c:if>
										">
										${subList.uct_name }</a>
									</li>
								</c:forEach>
								</ul>
								</c:if>
							</div>
						</div>
				    </c:if>
					</c:forEach>
					</div>
					<div class="bookMenuToggleArea">
						<!-- <button type="button" id="toggleButton" aria-label="카테고리 메뉴 토글" onclick="$('.bookMenuCategory').toggleClass('open')"></button> -->
						<button type="button" id="toggleButton" aria-label="카테고리 메뉴 토글"></button>
					</div>
				</div>
			</div>
			
			<!-- 251119 [고] : 리스트 필터 영역 수정 start// -->
			<div class="searchHeadBar noBG">
				<div class="leftSide">
				</div>
				<div class="rightSide">
					<c:if test="${sessionScope.UIS_RETURN_FLAG eq 'N'}"> 
					<div class="make_select bookArray_period">
						<select id="searchName2" name="searchName2">
							<option value="D" ${searchVO.searchName2 eq 'D' ? 'selected' : ''}>일간</option>
							<option value="W" ${searchVO.searchName2 eq 'W' ? 'selected' : ''}>주간</option>
							<option value="M" ${searchVO.searchName2 eq 'M' ? 'selected' : ''}>월간</option>
						</select>
					</div>
					</c:if>
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
			</div>
			<!-- 섬네일 뷰 or 리스트 뷰 div class 설정 -->
			<c:choose>
			<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
			<div class="cardPopular_thumb rankingList">
			<div class="best3_Box">
			</c:when>
			<c:otherwise>
			<div class="cardList_listType rankingList">
			</c:otherwise>
			</c:choose>
				<c:choose>
				<c:when test="${empty chooseCmList }">
				<ul><!-- 등록된 도서가 없을 때 -->
					<li>
						<div class="contentsNot" style="display:block;">
							<img src="/images/img_nodata.png" alt=""  style="margin-top: 50px;"/>
							<div>아직 등록된 도서가 없어요.</div>
						</div>
					</li>
				</c:when>
				<c:otherwise>
				<c:forEach items="${bestCmList }" var="list" varStatus="status">
					<c:choose>
						<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
							<c:if test="${status.count eq 1 }">
									<div class="best1_Box">
										<div class="best1_cover ">
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
										<div class="best1_info">
											<div class="mark_crown01">
												<span class="txt_best1">${status.count }</span>
											</div>
											<div class="bookTitle"><a href="#" onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a></div>
											<div class="txt_size20 infoAuthorName" >${list.ucm_writer }</div>
											<div class="viewStatus">
												<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
											</div>
										</div>
									</div>
									<div class="best_bar"> </div>
							</c:if>
							<c:choose>
								<c:when test="${status.count eq 2 }">
								<ul class="best23_Box">
									<li class="list_book">
									<!-- 2위 -->
									<div class="best23_cover ">
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
									<div class="best23_info">
										<div class="mark_crown02">
											<span class="txt_best2">${status.count }</span>
										</div>
										<div class="bookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a></div>
										<div class="txt_size20 infoAuthorName" >${list.ucm_writer }</div>
										<div class="viewStatus">
											<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
										</div>
									</div>
									</li> 
									<c:if test="${fn:length(bestCmList) eq 2 }">
										<li class="list_book"></li>
									</ul>
									</c:if>
								</c:when>
								 <c:when test="${status.count eq 3 }">
									<li class="list_book">
									<!-- 3위 -->
									<div class="best23_cover ">
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
									<div class="best23_info">
										<div class="mark_crown02">
											<span class="txt_best2">${status.count }</span>
										</div>
										<div class="bookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a></div>
										<div class="txt_size20 infoAuthorName" >${list.ucm_writer }</div>
										<div class="viewStatus">
											<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
										</div>
									</div>
									</li>
								</ul>
								</c:when>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:if test="${status.count eq 1 }">
							<div class="ranking_listType listFlex">
								<div class="best3_list_Box">
									<ul>
										<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
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
											<div class="ranking mark_crown01_list"><span class="txt_best1_list">${status.count }</span></div>
											<div class="InfoArea">
												<div class="infoBookTitle_best1"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
												<div class="infoAuthorName_best1">${list.ucm_writer }</div>
												<div class="infoPublisher_best1">${list.ucp_brand }</div>
												<div class="infoBookSummary">${list.ucm_intro }</div>
											</div>
											<div class="listBtnArea">
												<div class="status">
													<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
												</div>
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
								
							</c:if>
							<c:if test="${status.count eq 2 }">
										<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
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
											<div class="ranking mark_crown023_list"><span class="txt_best23_list">2</span></div>
											<div class="InfoArea">
												<div class="infoBookTitle_best23"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
												<div class="infoAuthorName">${list.ucm_writer }</div>
												<div class="infoPublisher">${list.ucp_brand }</div>
												<div class="infoBookSummary">${list.ucm_intro}</div>
											</div>
											<div class="listBtnArea">
												<div class="status">
													<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
												</div>
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
							</c:if>
							<c:if test="${status.count eq 3 }">
									<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
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
										<div class="ranking mark_crown023_list"><span class="txt_best23_list">3</span></div>
										<div class="InfoArea">
											<div class="infoBookTitle_best23"><a href="#" onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
											<div class="infoAuthorName">${list.ucm_writer }</div>
											<div class="infoPublisher">${list.ucp_brand }</div>
											<div class="infoBookSummary">${list.ucm_intro}</div>
										</div>
										<div class="listBtnArea">
											<div class="status">
												<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
											</div>
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
								
								</ul>
								</div>
								</div>
							</c:if>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				</div>
				
				<c:choose>
				<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
				<ul>
				</c:when>
				</c:choose>
				
				<c:forEach items="${chooseCmList }" var="list" varStatus="status" begin="3">
					<!-- 섬네일 모드 -->
					<c:choose>
					<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
					<li>
						<div class="ranking">${status.count + 3 }</div>
						<div class="ranking_coverArea">
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
						
						<div class="bookTitle"><a href="" onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}'); return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
						<div class="infoAuthorName">${list.ucm_writer }</div>
						<div class="viewStatus">
							<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
						</div>
					</li>
					<c:if test="${(status.count % 5 ne 0)}">
					<li class="rank_empty"></li>
					</c:if>
					</c:when>
					<c:otherwise>
					<!-- 리스트 모드 -->
					<div class="ranking_listType listFlex">
						<ul>
							<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
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
								<div class="ranking">${status.count + 3 }</div>
								<div class="InfoArea">
									<div class="txt_size18 infoBookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
									<div class="infoAuthorName">${list.ucm_writer }</div>
									<div class="infoPublisher">${list.ucp_brand }</div>
									<div class="infoBookSummary">${list.ucm_intro}</div>
								</div>
								<!-- 251119 [고] : 검색 결과 버튼 추가 start// -->
								<div class="listBtnArea">
									<div class="status">
										<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
									</div>
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
								<!-- //251119 [고] : 검색 결과 버튼 추가 end -->
							</li>
						</ul>
					</div>
					</c:otherwise>
					</c:choose>
				</c:forEach>
				</c:otherwise>
				</c:choose>
				
				<c:choose>
				<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
				</ul>
				</c:when>
				</c:choose>
			</div>
		</div>
	</div>
	<hr/>
	
</div>
<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</body>
</html>
