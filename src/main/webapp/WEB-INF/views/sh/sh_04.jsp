<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<!-- <link rel="stylesheet" href="/css/index.css"> -->
<link rel="stylesheet" href="/css/event_pc.css?v=<%= System.currentTimeMillis() %>"><!-- 251119 [고] : event css import -->
<script type="text/javascript">

$(document).ready(function() {
	/* var uct_type = '${searchVO.uct_type}';
	var uct_code = '${searchVO.uct_code}'; */
	const uct_type = '${searchVO.uct_type}';
	const uct_code = '${searchVO.uct_code}';
	
	const $menu = $('.bookMenuCategory');
	const $menuWrap = $('#bookMenuCategory');
	const $form = $('#frm');
    /* const $sortSelect = $('#selectSortField');
    const $hiddenSort = $('#sortField1'); */
	
	/* =========================
     * 카테고리 열림 여부
     * ========================= */
    const hasMainCategory = !!(uct_type && uct_type.trim());

    $menu.toggleClass('open', hasMainCategory);
	
	/* =========================
     * 이북 / 오디오북 메뉴 노출
     * ========================= */
    if (uct_type === 'E' || uct_type === 'A') {
        $menuWrap.show();
    } else {
        $menuWrap.hide();
    }

	oldAction = $("#frm").attr("action")
	
});

function fn_search(uct_type, uct_code){
	$("#uct_type").val(uct_type);
	$("#uct_code").val(uct_code);
	
	$("#frm").attr("action", oldAction)
	$("#frm").submit();
}

function setCookie(cookie_name, value, days) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + days);
	// 설정 일수만큼 현재시간에 만료값으로 지정

	var cookie_value = escape(value) + ((days == null) ? '' : ';    expires=' + exdate.toUTCString());
	document.cookie = cookie_name + '=' + cookie_value;
}
function getCookie(cookie_name) {
	var x, y;
	var val = document.cookie.split(';');

	for (var i = 0; i < val.length; i++) {
		x = val[i].substr(0, val[i].indexOf('='));
		y = val[i].substr(val[i].indexOf('=') + 1);
		x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
		if (x == cookie_name) {
			return unescape(y); // unescape로 디코딩 후 값 리턴
		}
	}
}
var deleteCookie = function(name) {
	document.cookie = name + '=; expires=0;';
}
$(document).ready(function() {
	
	
	var searchTerm = $("#searchName").val();
	console.log(searchTerm);
	var color = "red"; // 변경할 색상

	$(".infoBookTitle, .infoAuthorName, .infoPublisher").each(function() { // 검색할 요소를 식별
	  var text = $(this).text(); // 원본 텍스트
	  var regex = new RegExp('(' + searchTerm + ')', "gi"); // 검색어를 포함하는 정규식 생성
	  var modifiedText = text.replace(regex, function(match) {
	    return '<span class="t_sch">' + match + '</span>'; // 원래 매칭된 텍스트를 유지하며 강조
	  });
	  $(this).html(modifiedText); // 요소의 텍스트를 수정된 텍스트로 대체
	});

	// 현재 탭 설정
	if($("#status").val() == 'searchReport'){
		$(".searcBook").hide();
		$(".searchRead").hide();
		$(".searchReport").show();
		
		$("#searchReport").addClass("result_focus");
	}else if($("#status").val() == 'searchRead'){
		$(".searcBook").hide();
		$(".searchRead").show();
		$(".searchReport").hide();
		
		$("#searchRead").addClass("result_focus");
	}else{
		$(".searcBook").show();
		$(".searchRead").hide();
		$(".searchReport").hide();
		
		$("#searcBook").addClass("result_focus");
	}
	
	// 썸네일형 도서리스트 커버 영역 감싸고 상세 페이지 링크 연결
	$(".book img.cover").on("click", function() {
		
		var frm = $("#searchForm");
		
		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("id"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("id") +'">');
		}
		
		$("#searchForm").attr("action","/front/home/bookDetail.do");
		
		frm.submit();
	});
	
	
});

$(document).ready(function() {
	
	oldAction = $("#searchForm").attr("action")
	
	// 썸네일형 도서리스트 커버 영역 감싸고 상세 페이지 링크 연결
	$(".book2 img.cover").on("click", function() {
		
		var frm = $("#searchForm");
		
		if($("#selectUbrCode").length > 0 ){
			$("#selectUbrCode").val($(this).parent().attr("id"))
		}
		else {
			frm.append('<input type="hidden" id="selectUbrCode" name="ubr_code" value="' + $(this).parent().attr("id") +'">');
		}
		
		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("ucm_code"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("ucm_code") +'">');
		}
		
		$("#searchForm").attr("action","/front/lounge/view.do");
		
		frm.submit();
	});

	// 정렬 방식 변경 시
	$("#selectSortField").on('change', function() {
		oldAction = $("#frm4").attr("action")

		var frm = $("#frm4");
		let selectValue = $("#selectSortField").val()
		$("#sortField").val(selectValue);
		$("#searchName").val($("#searchName").val());
		$("#frm4").attr("action", oldAction)
		frm.append('<input type="hidden" id="sortField" name="sortField" value="' + selectValue +'">');
		frm.submit();
	});
	
	// 정렬 인기순, 최신일, 출간일순
	$(document).on('click', '.sort-align-option button', function (e) {
		const sortValue = $(this).data('sort');

	    // 정렬 값 세팅
	    $('#sortFieldLibrary').val(sortValue);
	    $('#frm').submit();
	});
});

var oldAction = $("#frm2").attr("action")
function fn_Detail(ucm_ucs_code, ucm_code){
	
	var frm = $("#frm2");
	
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
	
	$("#frm2").attr("action","/front/home/bookDetail.do");
	
	
	frm.submit();
}

var oldAction = $("#frm2").attr("action")
function fn_Detail2(ubr_code, ucm_code){
	
	var frm = $("#frm2");
	
	if($("#selectUbrCode").length > 0 ){
		$("#selectUbrCode").val(ubr_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUbrCode" name="ubr_code" value="' + ubr_code +'">');
	}
	
	if($("#selectUcmCode").length > 0 ){
		$("#selectUcmCode").val(ucm_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + ucm_code +'">');
	}
	
	$("#frm2").attr("action","/front/lounge/view.do");
	
	
	frm.submit();
}

/*한페이지당 게시물 */
function page(pagenum) {
	var frm = $("#frm3");
	let selectValue = $("#selectSortField").val()
	$("#sortField").val(selectValue);

	if($("#pagenum").length > 0 ){
		$("#pagenum").val(pagenum)
	}
	else {
		frm.append('<input type="hidden" id="pagenum" name="pagenum" value="' + pagenum +'">');
		frm.append('<input type="hidden" id="sortField" name="sortField" value="' + selectValue +'">');
	}
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
					<input type="hidden" id="status" name="status" value="${searchVO.status }" />
					<input type="text" onKeyDown="javascript:if(event.keyCode == 13){fn_go_search_page(); return false;}" class="searchWord" id="searchName" name="searchName" value="${searchVO.searchName }" placeholder="제목, 저자 , 출판사 검색" title="도서 검색">
					<button type="button" class="search" onClick="javascript:fn_go_search_page();return false;"><img src="/images/v2/icon/icon_search_black.svg" alt="" /></button>
				</form>
				<form name="frm2" id="frm2" action="/front/home/bookDetail.do" method="post">
				</form>
				<form name="frm" id="frm" action="/front/home/searchList.do" method="post">
					<input type="hidden" id="status" name="status" value="${searchVO.status }" />
					<input type="hidden" id="sortField" name="sortField" value="${searchVO.sortField }"/>
					<input type="hidden" id="sortFieldLibrary" name="sortFieldLibrary" value="${searchVO.sortFieldLibrary }"/>
					<input type="hidden" id="searchName" name="searchName" value="${searchVO.searchName }" />
					<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
					<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
				</form>
				<form name="frm3" id="frm3" action="/front/home/searchList.do" method="post">
					<input type="hidden" id="status" name="status" value="${searchVO.status }" />
					<input type="hidden" id="searchName" name="searchName" value="${searchVO.searchName }" />
					<input type="hidden" id="sortFieldLibrary" name="sortFieldLibrary" value="${searchVO.sortFieldLibrary }"/>
					<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
					<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
				</form>
				<form name="frm4" id="frm4" action="/front/home/searchList.do" method="post">
					<input type="hidden" id="status" name="status" value="${searchVO.status }" />
					<input type="hidden" id="searchName" name="searchName" value="${searchVO.searchName }" />
				</form>
			</div>
			<script>
				$(document).ready(function () {
					// 검색 결과 탭 메뉴(책, 읽고싶은책, 독서감상문) 클릭시
					$(".searchBook_list li").on("click", function (){
						$(this).addClass("result_focus");
						$(".searchBook_list li").not($(this)).removeClass("result_focus");
						
						if($(this).attr("id") == 'searcBook'){
							$(".searcBook").show();
							$(".searchRead").hide();
							$(".searchReport").hide();
							
							$("#status").val("searcBook");
						}else if($(this).attr("id") == 'searchRead'){
							$(".searcBook").hide();
							$(".searchRead").show();
							$(".searchReport").hide();
							
							$("#status").val("searchRead");
						}else{
							$(".searcBook").hide();
							$(".searchRead").hide();
							$(".searchReport").show();
							
							$("#status").val("searchReport");
							
						}
					});
					
					if(true){
						$(".top").append(
							 "<div class='searchingField'>"+
								"<div class='recent_searchResult'>"+
									"<div class='recent_searchWord'>최근 검색어</div>"+
									"<div class='recent_searchNot' style='display:block;'>최근 검색한 기록이 없습니다.</div>"+
								"</div>"+
							"</div>"
						);
					}else{
						$(".top").append(
								 "<div class='searchingField'>"+
									"<div class='recent_searchResult'>"+
										"<div class='recent_searchWord'>최근 검색어</div>"+
										"<div class='recent_wordList'>"+
											"<ul>"+
												"<li>"+
													"<div>가장 최근 검색어1</div>"+
													"<button type='button' class='recent_wordDelete'>"+
														"<img src='/images/icon_search_delete_bk.png' alt='' />"+
													"</button>"+
												"</li>"+
												"<li>"+
													"<div>가장 최근 검색어2</div>"+
													"<button type='button' class='recent_wordDelete'>"+
														"<img src='/images/icon_search_delete_bk.png' alt='' />"+
													"</button>"+
												"</li>"+
												"<li>"+
													"<div>가장 최근 검색어3</div>"+
													"<button type='button' class='recent_wordDelete'>"+
														"<img src='/images/icon_search_delete_bk.png' alt='' />"+
													"</button>"+
												"</li>"+
												"<li>"+
													"<div>가장 최근 검색어4</div>"+
													"<button type='button' class='recent_wordDelete'>"+
														"<img src='/images/icon_search_delete_bk.png' alt='' />"+
													"</button>"+
												"</li>"+
												"<li>"+
													"<div>가장 최근 검색어 가장 최근 검색어 가장 최근 검색어 가장 최근 검색어 가장 최근 검색어 가장 최근 검색어</div>"+
													"<button type='button' class='recent_wordDelete'>"+
														"<img src='/images/icon_search_delete_bk.png' alt='' />"+
													"</button>"+
												"</li>"+
											"</ul>"+
											"<div class='word_allDelete'>전체 삭제</div>"+
										"</div>"+
									"</div>"+
								"</div>"
							);
					}
					
					// 상단 검색창 포커스
					$(".searchWord").on("click", function (){
						$(".recent_searchResult").show();//최근 검색어 리스트 보이기
					});
					$(document).mouseup(function(e) {
						if ($(".recent_searchResult").has(e.target).length===0){//최근 검색어리스트 바깥 클릭시
							$(".recent_searchResult").hide();
						}
					});
					
					// 최근 검색어 삭제
					$(".recent_wordDelete").on("click", function (){
						$(this).parent().remove();
					});
					
					// 최근 검색어 전체 삭제
					$(".word_allDelete").on("click", function (){
						$(this).prev().find("li").remove();
					});
					
					
					// 검색어 입력시
					$(".searchWord").keyup(function (){
						$(".input_delete").show();
						$(".recent_searchResult").hide();
						$(".input_delete").on("click", function (){
							$(this).prev().val("");//입력한 값 지우기
						});
						setTimeout(function (){
							$(".searchWord_view").show();
						},500);						
					});
				});
			</script>
			<div class="myInfo">
				<a href="/front/mypage/faqList.do"><img src="/images/v2/icon/icon_faq.svg" alt=""/></a>
			</div>
			</div>
		</div>
		<hr/>
	</div>
	<div id="container">
		<div class="content">
			<c:choose>
			<c:when test="${empty BookList }">
			</c:when>
			<c:otherwise>
			<div class="viewSetting lineType">
				<div class="bookTypeArea">
					<c:choose>
					<c:when test="${cmVO.type_result eq 'TYPEALL' }">
					<div class="bookAll <c:if test="${searchVO.uct_type eq ''}">bookType_focus</c:if>" onClick="javascript:fn_search('','');">전체</div>
					<div class="book_ebook <c:if test="${searchVO.uct_type eq 'E'}">bookType_focus</c:if>" onClick="javascript:fn_search('E','');">eBook</div>
					<div class="book_audiobook <c:if test="${searchVO.uct_type eq 'A'}">bookType_focus</c:if>" onClick="javascript:fn_search('A','');">오디오북</div>
					</c:when>
					<c:when test="${cmVO.type_result eq 'TYPEE' }">
					<div class="bookAll <c:if test="${searchVO.uct_type eq ''}">bookType_focus</c:if>" onClick="javascript:fn_search('','');">전체</div>
					<div class="book_ebook <c:if test="${searchVO.uct_type eq 'E'}">bookType_focus</c:if>" onClick="javascript:fn_search('E','');">eBook</div>
					</c:when>
					<c:when test="${cmVO.type_result eq 'TYPEA' }">
					<div class="bookAll <c:if test="${searchVO.uct_type eq ''}">bookType_focus</c:if>" onClick="javascript:fn_search('','');">전체</div>
					<div class="book_audiobook <c:if test="${searchVO.uct_type eq 'A'}">bookType_focus</c:if>" onClick="javascript:fn_search('A','');">오디오북</div>
					</c:when>
					<c:otherwise>
					
					</c:otherwise>
					</c:choose>
				</div>
				<div class="bookMenuCategory" id="bookMenuCategory">
					<div class="cateGroup">
					<c:set var="eIndex" value="0" />

					<!-- ===== 전자책 전체 ===== -->
					<c:if test="${eIndex % 8 == 0}">
					<div class="cateRow">
					    <div class="cateDepth depth1">
					        <ul>
					</c:if>
					
					<li>
					    <a href="#"
					       onclick="fn_search('${searchVO.uct_type }','');"
					       class="item
					       <c:if test="${empty searchVO.uct_code}">selected-all</c:if>">
					        전체
					    </a>
					</li>
					
					<c:set var="eIndex" value="${eIndex + 1}" />
					
					<c:forEach items="${categoryList }" var="list" varStatus="status">
						<c:if test="${empty searchVO.uct_type or list.uct_type eq searchVO.uct_type}">
						<!-- 8개 묶음 시작 -->
						<c:if test="${eIndex % 8 == 0}">
				        <div class="cateRow">
				            <div class="cateDepth depth1">
				                <ul>
				        </c:if>
								<li>
									<a href="#" 
									onclick="javascript:fn_search('${list.uct_type }','${list.uct_code }');" class="item 
									<c:if test="${not empty searchVO.uct_code and searchVO.uct_code eq list.uct_code and list.uct_code ne '' }">selected-all</c:if>
								">
								${list.uct_name }(${list.content_count })</a>
								</li>
				            <!-- 8개 묶음 종료 -->
					        <c:if test="${eIndex % 8 == 7}">
					                </ul>
					            </div>
					        </div>
					        </c:if>
      					<c:set var="eIndex" value="${eIndex + 1}" />
				        </c:if>
					</c:forEach>
					<!-- 마지막 묶음 보정 -->
					<c:if test="${eIndex % 8 != 0}">
					        </ul>
					    </div>
					</div>
					</c:if>
					</div>
					<div class="bookMenuToggleArea">
						<button type="button" id="toggleButton" aria-label="카테고리 메뉴 토글" onclick="$('.bookMenuCategory').toggleClass('open')"></button>
					</div>
				</div>
			</div>
			</c:otherwise>
			</c:choose>
			<c:choose>
			<c:when test="${empty BookList }">
			<div class="contentsYes">
				<div class="resultTitle">
				<c:choose>
					<c:when test='${searchVO.sortField eq "all" or searchVO.sortField eq "" }'>
						도서명,저자명,출판사명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "title" }'>
						도서명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "writer" }'>
						저자명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "publisher" }'>
						출판사명에서 
					</c:when>
					<c:otherwise>
					</c:otherwise>
				</c:choose>
				'${searchVO.searchName }' 으로 검색한 결과 (<b><fmt:formatNumber value="${BookPaging.totalCount}" pattern="#,###"/></b>)건 입니다.
				</div>
				<div class="cardList_listType searcBook listFlex">
					<!-- 251119 [고] : 검색 결과 없음 start// -->
					<div class="searchResultEmpty"><!-- 251119 [고] : class 변경 -->
						<p class="msg">
				<c:choose>
					<c:when test='${searchVO.sortField eq "all" or searchVO.sortField eq "" }'>
						도서명,저자명,출판사명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "title" }'>
						도서명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "writer" }'>
						저자명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "publisher" }'>
						출판사명에서 
					</c:when>
					<c:otherwise>
					</c:otherwise>
				</c:choose>	
					'${searchVO.searchName }'으(로) 검색한 결과가 없습니다.</p>
						<div class="btnWrap">
						</div>
					</div>
					<!-- //251119 [고] : 검색 결과 없음 end -->
					<div class="cardListLineTitle"><!-- 251119 [고] : 리스트 타이틀 추가 -->
						<h3>실시간 인기 도서</h3>
					</div>
					<ul>
						<c:forEach items="${searchPopularList }" var="list" >	
						<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
							<div class="coverArea">
								<div class="book" id="${list.ucm_code }">
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
								<div class="infoBookTitle">${list.ucm_title }</div>
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
						</c:forEach>
					</ul>
				</div>
	        </div>
			</c:when>
			<c:otherwise>
			<div class="contentsYes">
				<div class="resultTitle">
				<c:choose>
					<c:when test='${searchVO.sortField eq "all" or searchVO.sortField eq "" }'>
						도서명,저자명,출판사명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "title" }'>
						도서명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "writer" }'>
						저자명에서 
					</c:when>
					<c:when test='${searchVO.sortField eq "publisher" }'>
						출판사명에서 
					</c:when>
					<c:otherwise>
					</c:otherwise>
				</c:choose>
				'${searchVO.searchName }' 으로 검색한 결과 (<b><fmt:formatNumber value="${BookPaging.totalCount}" pattern="#,###"/></b>)건 입니다.
				</div>
				<!-- <div class="searchFilter"> -->
				<!-- 251119 [고] : 검색 결과 필터 영역 수정 start// -->
				<div class="searchHeadBar"><!-- 251119 [고] : class 변경 -->
					<div class="leftSide"><!-- 251119 [고] : leftSide 이하 추가 -->
						<div class="sort-align-option">
							<button type="button" data-sort="ucm_readbook_count" class="<c:if test="${empty searchVO.sortFieldLibrary or searchVO.sortFieldLibrary eq 'ucm_readbook_count'}">on</c:if>">인기순</button><!-- 251119 [고] case : 활성화 class="on" -->
							<button type="button" data-sort="ucm_regdate" class="<c:if test="${searchVO.sortFieldLibrary eq 'ucm_regdate'}">on</c:if>">최신순</button>
							<button type="button" data-sort="ucm_ebook_pubdate" class="<c:if test="${searchVO.sortFieldLibrary eq 'ucm_ebook_pubdate'}">on</c:if>">출간일순</button>
						</div>
					</div>
					<div class="rightSide"><!-- 251119 [고] : rightSide 그룹핑 추가 (내부 select은 기존과 동일) -->
					<div class="make_select bookArray_sequence">
						<select title="도서 검색 조건" id="selectSortField">
							<option value="all">전체</option>
							<option value="all" <c:if test="${searchVO.sortField eq 'all'}"> selected</c:if>>전체</option>
							<option value="title" <c:if test="${searchVO.sortField eq 'title'}"> selected</c:if>>도서명</option>
							<option value="writer" <c:if test="${searchVO.sortField eq 'writer'}"> selected</c:if>>저자명</option>
							<option value="publisher" <c:if test="${searchVO.sortField eq 'publisher'}"> selected</c:if>>출판사명</option>
						</select>
					</div>
					</div>
				</div>
				<!--  북 start -->
				<div class="cardList_listType searcBook listFlex"><!-- 251119 [고] : listFlex class 추가 -->
					<ul>
						<c:forEach items="${BookList }" var="list">
						<li class="book-item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume-codes="">
							<div class="coverArea">
								<div class="book" id="${list.ucm_code }">
									<!-- 19금 도서 노출 유무 -->
									<c:if test="${cmVO.ucm_limit_age eq 'R' }">
									<img class="badge_adult" src="/images/icon_adult.png" alt="" />
									</c:if>
									<!-- 파일 형태 -->
									<c:choose>
									<c:when test='${list.ucm_file_type eq "PDF" }'>
									<img class="book_badge" src="/images/icon_pdf_s.png" alt="" />
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
								<%
							    pageContext.setAttribute("space", "\u00A0");
							    pageContext.setAttribute("nbsp", " ");
								%>
								<div class="infoBookTitle"><a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');">
								<c:choose>
								<c:when test='${list.ucm_file_type eq "PDF" or list.ucm_file_type eq "EPUB" }'>
								</c:when>
								<c:when test='${list.ucm_file_type eq "AUDIO" }'>
								<b>[오디오북]</b>	
								</c:when>
								<c:otherwise>
								</c:otherwise>
								</c:choose>
								${fn:replace(list.ucm_title,space,nbsp) }</a> </div>
								<div class="infoAuthorName">${fn:replace(list.ucm_writer,space,nbsp) }</div>
								<div class="infoPublisher">${list.ucp_brand }</div>
								<div class="infoBookSummary">${list.ucm_intro }</div>
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
						</li>
						</c:forEach>
					</ul>
				</div>
				<div class="page_pn searcBook">
					<ul>
						<c:if test="${not empty BookList }">
							<c:if test="${BookPaging.prev}">
								<li><a href="javascript:page(1);"><img src="/images/icon_page_first.png" alt="첫페이지" /></a></li>
								<li><a href="javascript:page(${BookPaging.getStartPage()-10});"><img src="/images/icon_page_prev.png" alt="이전페이지" /></a></li>
							</c:if>
							<c:forEach begin="${BookPaging.getStartPage()}" end="${BookPaging.getEndPage()}" var="idx">
								<li class="n <c:if test='${BookPaging.pagenum eq idx}'>LNB_focus</c:if>"><a href="javascript:page(${idx});">${idx}</a></li>
							</c:forEach>
							<c:if test="${BookPaging.next}">
								<li><a href="javascript:page(${BookPaging.getEndPage()+1});"><img src="/images/icon_page_next.png" alt="다음페이지" /></a></li>
								<li><a href="javascript:page(${BookPaging.getTotalPage() });"><img src="/images/icon_page_end.png" alt="마지막페이지" /></a></li>
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
