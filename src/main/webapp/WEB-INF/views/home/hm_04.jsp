<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
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
    
    const stored = sessionStorage.getItem('bookMenuOpen_hm04');
    const isOpen = stored === null ? true : stored === 'Y'; // 아무 값이 없을 때는 true 
    const bookMenuOpen_hm04_stop = sessionStorage.getItem('bookMenuOpen_hm04_stop')
	
	/* =========================
     * 카테고리 열림 여부
     * ========================= */
    const hasMainCategory = !!(uct_type && uct_type.trim());

    if (bookMenuOpen_hm04_stop === 'Y' && hasMainCategory) { // 고정 시키는 서브밋 이면 true 열림 
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
        sessionStorage.setItem('bookMenuOpen_hm04_stop', 'Y');
        $form.attr('action', oldAction);
        $form.submit();
    });

 	// 카테고리 펼침 상태값 
    $('#toggleButton').on('click', function () {
    	const $menu = $('.bookMenuCategory');

        $menu.toggleClass('open');

        if ($menu.hasClass('open')) {
        	sessionStorage.setItem('bookMenuOpen_hm04', "Y");
        } else {
        	sessionStorage.setItem('bookMenuOpen_hm04', "N");
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
	  /* const ucmCode = $book.data('ucmCode') || $(this).parent().attr('id') || '';
	  const ucsCode = $book.data('ucsCode') || $(this).parent().attr('ucm_ucs_code') || ''; */
	  const ucmCode = $book.data('ucmCode') || $book.attr('id') || '';
	  const ucsCode = $book.data('ucsCode') || $book.attr('series') || '';

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

		sessionStorage.setItem('bookMenuOpen_hm04_stop', 'N');
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
	
	sessionStorage.setItem('bookMenuOpen_hm04_stop', 'Y');
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
    
    /* console.log("ume_ucm_code,", ume_ucm_code);
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
					<a href="/front/home/popularList.do">인기</a>
				</li>
				<li>
					<a href="/front/home/categoryList.do" class="nav_focus">주제별</a>
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
			<form name="frm" id="frm" action="/front/home/categoryList.do" method="post">
				<input type="hidden" id="viewMode" name="viewMode" value="${searchVO.viewMode }" />
				<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
				<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
				<input type="hidden" id="uct_parent" name="uct_parent" value="${searchVO.uct_parent }" />
				<input type="hidden" id="sortField1" name="sortField1" value="${searchVO.sortField1 }"/>
			</form>
			<form name="frm2" id="frm2" action="/front/home/bookDetail.do" method="post">
			</form>
			<div class="viewSetting lineType">
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
			<!-- 12.14 : 총 권수 표기 & 문구  -->
			<div class="total_number_Box">
				<c:choose>
				<c:when test="${sessionScope.UM_UIS_CODE eq 'UIS0000000487'}">
				<p class="txt_total_number">X-book에는
					</c:when>
					<c:otherwise>
				<p class="txt_total_number">부커스에는
					</c:otherwise>
					</c:choose>
					<b class="point_color"><fmt:formatNumber value="${paging.totalCount }" pattern="#,###" /></b>
					권의 책이 있어요. 지금 어떤 책을 읽어볼 지 확인해보세요.
				</p>
			</div></br>
			
			<!-- 251119 [고] : 리스트 필터 영역 수정 start// -->
			<div class="searchHeadBar noBG">
				<div class="leftSide">
					<div class="cateTitleArea">
						<div class="cateTitle">
							<c:if test="${not empty categoryText}">
							    <span>${categoryText}</span>
							</c:if>
							
							<c:if test="${not empty selectedMainCategroy}">
							    <span>${selectedMainCategroy}</span>
							</c:if>
							
							<c:if test="${not empty selectedSubCategroy}">
							    <span class="current">${selectedSubCategroy}</span>
							</c:if>
						</div>
					</div>
				</div>
				<div class="rightSide">
					<div class="menuSelect_area">
						<div class="make_select bookArray_default">
							<select title="도서 정렬 순서" id="selectSortField">
								<option value="ucm_ebook_pubdate" ${searchVO.sortField1 eq 'ucm_ebook_pubdate' ? 'selected' : ''}>출간일 순</option>
								<option value="ucm_regdate" ${searchVO.sortField1 eq 'ucm_regdate' ? 'selected' : ''}>업데이트 순</option>
								<option value="ucm_download_count" ${searchVO.sortField1 eq 'ucm_download_count' ? 'selected' : ''}>인기 순</option>
								<option value="ucm_title" ${searchVO.sortField1 eq 'ucm_title' ? 'selected' : ''}>제목 순</option>
							</select>
						</div>
					</div>
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
			<!-- //251119 [고] : 리스트 필터 영역 수정 end -->
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
							<li>
								<div class="contentsNot" style="display:block;">
									<img src="/images/img_nodata.png" alt="" style="margin-top: 50px;" />
									<div>아직 등록된 도서가 없어요.</div>
								</div>
							</li>
						</c:when>
						<c:otherwise>
							<c:forEach items="${chooseCmList }" var="list" varStatus="status">
								<!-- 섬네일 모드 -->
								<c:choose>
									<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
										<li>
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
															<div class="bookBG">
                        									<span class="back"></span><!-- 251119 [고] : back 추가 -->
															<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
															</div>
														</c:otherwise>
													</c:choose>
												</div>
											</div>

											<div class="bookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;" title="${list.ucm_title }">${list.ucm_title }</a> </div>
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
