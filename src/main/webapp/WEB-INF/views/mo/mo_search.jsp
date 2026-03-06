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
<title>부커스 모바일 웹:검색</title>
<link rel="stylesheet" href="/css/basic.css?v=<%= System.currentTimeMillis() %>">
<link rel="stylesheet" href="/css/screen.css?v=<%= System.currentTimeMillis() %>">
<script src="/js/jquery.min.js"></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="/js/jquery-ui.js"></script>
	
<script type="text/javascript">
$(document).ready(function(){
	oldAction = $("#frm").attr("action")
	if (document.querySelector('#selectBox')) {
		var selectBox1 = new selectBox('#selectBox', {
			change: function(value){
	
				$("#sortFieldLibrary").val(value);
				const $frm = $("#searchForm");
			 	// submit
			    $frm.submit();
			},
			init: function(){
				var sortFieldLibrary = '${searchVO.sortFieldLibrary}';
				document.querySelectorAll('#selectBox ul li').forEach(function(li){
					li.removeAttribute('data-selected');
					if(li.dataset.value == sortFieldLibrary) li.dataset.selected = true;
				})
			}
		});
	}
	
	function selectBox(trg, param){
		var t = this;

		function constructor(){
			t.target = document.querySelector(trg);
			t.value;
			t.title;
			t.setUI();
			t.bindEvent();

			if(param.init && typeof param.init == 'function'){
				param.init();
			}

			t.init();
		}

		t.setUI = function(){
			t.target.dataset.id = 'selectBox';
			var ulContent = t.target.innerHTML;

			t.target.innerHTML = '<input type="hidden" /><div data-type="selectbox" />';

			t.target.innerHTML += ulContent;

			t.selectbox = t.target.querySelector('[data-type="selectbox"]');
			t.hiddenInput = t.target.querySelector('input[type="hidden"]');
		}

		t.bindEvent = () => {
			t.target.querySelectorAll('li').forEach(li => {
				li.onclick = () => {
					var oldVal = t.value;
					t.value = li.dataset.value;
					t.title = li.innerText;
					if(param.change && typeof param.change == 'function'){
						if(oldVal !== t.value){
							param.change(t.value);
						}
					}
					t.update();
					t.target.classList.remove('active');
				}
			})

			var li1 = '';

			t.selectbox.onclick = function() {
				if(!t.target.classList.contains('active')) exSelectBoxArr.push(trg);
				t.target.classList.toggle('active');
			}
		}

		t.update = () => {
			var li2 = '';
			for(var ii = 0; ii < t.target.querySelectorAll('ul li').length; ii++){
				li2 = t.target.querySelectorAll('ul li')[ii];
				li2.removeAttribute('data-selected');
				if(li2.dataset.value === t.value && li2.innerText === t.title){
					li2.dataset.selected = true;
					t.selectbox.innerHTML = t.title;
					t.hiddenInput.value = t.value;
				}
			}
		}

		t.init = () => {
			var selectedLi1 = t.target.querySelector('li[data-selected]');
			if(selectedLi1){
				t.value = selectedLi1.dataset.value;
				t.title = selectedLi1.innerText;

				t.update();
			}
		}

		constructor(trg);
	}
	var exSelectBoxArr = [];
	
	function closeSelectBoxAll(){
	    document.querySelectorAll('[data-id="selectBox"]').forEach(sb => {
	        const exSelectBox = exSelectBoxArr.filter(x => x === '#' + sb.id);
	        if(!exSelectBox.length) sb.classList.remove('active');
	    })

	    exSelectBoxArr.length = 0;
	}
	
	
	// 이미지 상세 페이지 링크 연결
	$(".sch_book_cover img.cover").on("click", function() {
		var frm = $("#frm2");

		if($("#selectUcmCode").length > 0 ){
			$("#selectUcmCode").val($(this).parent().attr("id"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + $(this).parent().attr("id") +'">');
		}
		
		$("#frm2").attr("action","/front/mobile/bookDetail.do");
		
		frm.submit();
	});
	
	var searchTerm = $("#searchName").val();
	console.log(searchTerm);
	var color = "red"; // 변경할 색상

	$(".infoBookTitle").each(function() { // 검색할 요소를 식별
	  var text = $(this).text();
	  var modifiedText = text.replace(new RegExp(searchTerm, "gi"), '<span class="t_sch">' + searchTerm + '</span>'); // 검색어를 찾아 새 요소로 대체
	  $(this).html(modifiedText); // 요소의 텍스트를 수정된 텍스트로 대체
	});
});

var referrer = document.referrer;

function fn_go_search_page(){
	var str = $('#searchName').val();
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	if(str.trim() == ''){
		alert('내용을 입력하세요.');
		return false;
	}else{
		if(regExp.test(str)){
			var t = str.replace(regExp, "");
			if(t == ''){
				alert('특수문자만으로는 검색을 할 수 없습니다.');
				return false;
			}else{
				document.getElementById('searchForm').submit();
			}			
		} else if (str.length <= 1) {
			alert('두 글자 이상 검색해주세요.');
			return false;
		}else{
			document.getElementById('searchForm').submit();
		}
	}
}
var oldAction = ""
function page(pagenum) {
	var frm = $("#searchForm");
	console.log(pagenum);
	if($("#pagenum").length > 0 ){
		$("#pagenum").val(pagenum)
	}
	else {
		frm.append('<input type="hidden" id="pagenum" name="pagenum" value="' + pagenum +'">');
	}
	
	frm.submit();
}

function fn_back(preUrl){
	if (preUrl == "main") {
		location.href="/front/mobile/main.do"	
	} else if (preUrl == "library") {
		location.href="/front/mobile/main.do"	
	}else {
		history.go(-1);
	}
    
}
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
	
	$("#frm2").attr("action","/front/mobile/bookDetail.do");
	
	frm.submit();
}

// 이벤트 클릭 
function fn_eventDetail(uem_code, uem_url) {
	const $frm = $("#frm2");
	
	// hidden input 없으면 생성
    if (!$frm.find("#selectUemCode").length) {
        $frm.append('<input type="hidden" id="selectUemCode" name="uem_code">');
        $frm.append('<input type="hidden" id="selectUemUrl" name="uem_url">');
    }
	
 	// 값 세팅 (항상 실행)
    $("#selectUemCode").val(uem_code);
    $("#selectUemUrl").val(uem_url);
	
 	// action 지정 후 submit
    $frm.attr("action", "/front/home/eventDetail.do").submit();
}


$(document).on('click', '.bt-func-read', function () {
	// ajax 내 서재 추가 or 삭제
	uis_return_ui_flag = '${sessionScope.UIS_RETURN_UI_FLAG}';
	
	const $btn = $(this);
    const $item = $btn.closest('.sch_result_item'); // 모바일웹은 sch_result_item 
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
	<header class="m_head">
		<div class="mainTop line_black">
			<div class="btn_prevArea">
				<button class="btn_Prev" onclick="javascript:fn_back('${searchVO.searchName4 }');"><span class="blind">이전페이지 이동</span></button>
			</div>
			<div class="sch_input_Wrap">
				<form class="sch_form" name="searchForm" id="searchForm" action="/front/mobile/searchList.do" method="post" accept-charset="UTF-8">
					<input type="hidden" id="preUrl" name="preUrl" value="${searchVO.searchName4 }" />
					<input type="hidden" id="status" name="status" value="${searchVO.status }" />
					<input type="hidden" id="sortFieldLibrary" name="sortFieldLibrary" value="${searchVO.sortFieldLibrary }" />
					<input class="sch_input" onKeyDown="javascript:if(event.keyCode == 13){fn_go_search_page(); return false;}" class="searchWord" id="searchName" name="searchName" value="${searchVO.searchName }" placeholder="제목, 저자 , 출판사 검색" title="도서 검색" maxlength="250">
					<button type="button" class="btn_search" onClick="javascript:fn_go_search_page();return false;"><span class="blind">검색버튼 </span></button>
				</form>
				<form name="frm2" id="frm2" action="/front/mobile/bookDetail.do" method="post">
				</form>
			</div>	
		</div>
	</header>
	<main class="max_main">
		<div class="clear m_wrap_sub">
			<c:choose>
			<c:when test="${empty searchVO.searchName}">
				<!--  검색 첫화면 -->
				<div class="sch_infoArea t_gray">
					검색어를 입력해주세요. 
				</div>
			</c:when>
			<c:when test="${not empty searchVO.searchName and empty BookList}">
				<!--  찾는 검색결과가 없는 경우 -->
				<!-- 251119 [고] : 검색 결과 없음 start// -->
				<div class="searchResultEmpty"><!-- 251119 [고] : class 변경 -->
					<p class="msg">'${searchVO.searchName }'으(로) 검색한 결과가 없습니다.</p>
					<!-- <div class="btnWrap">
						<button type="button" class="bt-func-request round">희망도서 신청하기</button>
					</div> -->
				</div>
				<!-- //251119 [고] : 검색 결과 없음 end -->
				<div class="cardListLineTitle"><!-- 251119 [고] : 리스트 타이틀 추가 -->
					<h3>실시간 인기 도서</h3><!-- 1 ~ 6 -->
				</div>
				<ul class="sch_result listFlex"><!-- 251119 [고] : listFlex class 추가 -->
				<c:forEach items="${searchPopularList }" var="list" >	
					<li class="sch_result_item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
						<div class="sch_book_cover" id="${list.ucm_code}">
							<!-- 파일 형태 -->
							<c:choose>
								<c:when test='${list.ucm_file_type eq "PDF" }'>
									<div class="mark m_pdf">
										<span class="blind">pdf</span>
									</div>
								</c:when>
								<c:when test='${list.ucm_file_type eq "ZIP" or list.ucm_file_type eq "COMIC" }'>
									<div class="mark m_comic">
										<span class="blind">comic</span>
									</div>
								</c:when>
								<c:when test='${list.ucm_file_type eq "AUDIO" }'>
									<div class="mark m_audio">
										<span class="blind">audio</span>
									</div>
								</c:when>
							</c:choose>
							<c:choose>
							<c:when test="${empty list.ucm_cover_url }">
							<img class="cover" src="/images/img_coverNot.png" alt="" />
							</c:when>
							<c:otherwise>
							<img class="cover" src="<%=filePath %>${list.ucm_cover_url }">
							</c:otherwise>
							</c:choose>
						</div>
						<!-- 251119 [고] : 리스트 컨텐츠 영역 수정 start// -->
						<div class="sch_book_infoWrap">
							<div class="InfoArea">
								<div class="infoBookTitle">${list.ucm_title }</div>
								<div class="infoAuthorName">${list.ucm_writer }</div>
								<div class="infoPublisher">${list.ucp_brand }</div>
							</div>
							<div class="listBtnArea">
								<div class="status">
									<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
								</div>
								<div class="btnWrap">
									<c:if test="${list.ucm_webdrm_yn eq 'Y'}">
									<button type="button" class="bt-func-read">바로읽기</button>
									</c:if>
								</div>
							</div>
						</div>
						<!-- //251119 [고] : 리스트 컨텐츠 영역 수정 end -->
					</li>
				</c:forEach>
				</ul>
				
				<div class="galleryList_Wrap" style="margin-top:50px"><!-- 251119 [고] : 이벤트 리스트 추가 -->
					<div class="galleryList_inner">
						<c:forEach items="${validEventList }" var="list" >	  
						<div class="list-item">
							<a href="#" onClick="fn_eventDetail('${list.uem_code }','${list.uem_url}'); return false;">
								<img src="<%=filePath %>${list.uem_thumbnail_image }" alt="event img" >
							</a>
							<div class="list_infoArea">
								<p class="event_title">${list.uem_title }</p>
								<span class="event_date">${list.uem_display_startdate } ~ ${list.uem_display_enddate}</span>
								<span class="event_Dday">${list.date_diff }일 남음</span>
							</div>
						</div>
						</c:forEach>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<!-- 251119 [고] : 검색 결과 필터 영역 추가 start// -->
				<div class="searchHeadBar">
					<div class="leftSide">
						<div class="countWrap">
							검색결과 <span class="t_point">${BookPaging.totalCount}</span>
						</div>
					</div>
					<div class="rightSide">
						<!-- <div id="selectBox" class="select-box" data-id="selectBox"> -->
						<div id="selectBox" class="select-box bookArray_default"><!-- 251119 [고] : 주제별 리스트에 있는 select 코드 그대로 사용 & bookArray_default class 추가 -->
							<ul>
								<li data-value="" data-selected="true">인기순</li>
								<li data-value="ucm_regdate">최신순</li>
								<li data-value="ucm_ebook_pubdate">등록일순</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //251119 [고] : 검색 결과 필터 영역 추가 end -->
				<%-- <div class="countWrap"><!--검색결과 총 결과 수-->
					검색결과 <span class="t_point"><fmt:formatNumber value="${BookPaging.totalCount}" pattern="#,###"/></span>
				</div> --%>
				<ul class="sch_result listFlex"><!--검색결과 리스트 나오는 부분-->
				<c:forEach items="${BookList }" var="list">
				<li class="sch_result_item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
					<div class="sch_book_cover" id="${list.ucm_code }">
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
						<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" />
					</div>
					<!-- 251119 [고] : 리스트 컨텐츠 영역 수정 start// -->
					<div class="sch_book_infoWrap">
						<div class="InfoArea">
							<div class="infoBookTitle" onClick="javascript:fn_Detail('${list.ucm_ucs_code }','${list.ucm_code }');"><span class="t_sch">${list.ucm_title }</span></div>
							<div class="infoAuthorName">${list.ucm_writer }</div>
							<div class="infoPublisher">${list.ucp_brand }</div>
						</div>
						<div class="listBtnArea">
							<div class="status">
								<p class="count"><em>${list.ucm_read_count }</em>명이 읽고 있어요</p>
							</div>
							<div class="btnWrap">
								<c:if test="${list.ucm_webdrm_yn eq 'Y'}">
								<button type="button" class="bt-func-read">바로읽기</button>
								</c:if>
							</div>
						</div>
					</div>
					<!-- //251119 [고] : 리스트 컨텐츠 영역 수정 end -->
				</li>
				</c:forEach>
				</ul>
			</c:otherwise>
			</c:choose>
			<!-- 페이징 처리 -->
			<div class="page_pn">
				<ul>
					<c:if test="${not empty searchVO.searchName and not empty BookList }">
						<c:if test="${BookPaging.prev}">
							<li><a href="javascript:page(1);"><img src="/images/icon_page_first.png" alt="첫페이지" /></a></li>
							<li><a href="javascript:page(${BookPaging.getStartPage()-5});"><img src="/images/icon_page_prev.png" alt="이전페이지" /></a></li>
						</c:if>
							<c:forEach begin="${BookPaging.getStartPage()}" end="${BookPaging.getEndPage()}" var="idx">
							<li class="n"><a class="<c:if test='${BookPaging.pagenum eq idx}'> t_black_b</c:if>" href="javascript:page(${idx});">${idx}</a></li>
						</c:forEach>
						<c:if test="${BookPaging.next}">
							<li><a href="javascript:page(${BookPaging.getEndPage()+1});"><img src="/images/icon_page_next.png" alt="다음페이지" /></a></li>
							<li><a href="javascript:page(${BookPaging.getTotalPage() });"><img src="/images/icon_page_end.png" alt="마지막페이지" /></a></li>
						</c:if>
					</c:if>
				</ul>
			</div>
		</div>
		
	</main>
	
	<footer class="m_footer"><!--하단-->
		<img src="/images/mobile/logo_footer.svg" alt="bookers logo">
		<p class="footer_infoArea">
			<b>대표 전화 : 02 - 2038 - 2696</b><br>
			Copyright bookers. All right reserved.
		</p>
	</footer>
</body>
</html>