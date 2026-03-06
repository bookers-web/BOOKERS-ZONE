<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%
	String filePath = "https://files.bookers.life";
%>
<!DOCTYPE html>
<html lang="ko">
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
	$(function(){
		var uct_type = '${searchVO.uct_type}';
		var uct_code = '${searchVO.uct_code}';
		var uct_parent = '${searchVO.uct_parent}';
		
	    const stored = sessionStorage.getItem('bookMenuOpen_mo04_stop') // paging 일 경우 Y
	    const isOpen = stored === null ? true : stored === 'Y'; // 아무 값이 없을 때는 true 
	    
	    console.log("uct_code: ", uct_code );
	    console.log("uct_parent: ", uct_parent );
	    console.log("isOpen: ", isOpen );
	    
		// 시작 시 있으면 숨긴다. 동일하지 않으면 중분류 
		if (uct_code !== "" && uct_code !== uct_parent){
			const $depth2 = $('.cateDepth.depth2');
		   	if ($depth2.hasClass('active')) $depth2.removeClass('active');
		} else if (isOpen){ // submit > 2depth or paging true 숨김 
			const $depth2 = $('.cateDepth.depth2');
		   	if ($depth2.hasClass('active')) $depth2.removeClass('active'); 
		}

	    var selectBox1 = new selectBox('#selectBox', {
			change: function(value){
				// var sortField = document.getElementById("sortField").value;
				// sortField = value;
				$("#sortField1").val(value);
				var uct_type = '${searchVO.uct_type}';
				var uct_code = '${searchVO.uct_code}';
				//console.log(value);

				$("#uct_type").val(uct_type);
				$("#uct_code").val(uct_code);
				sessionStorage.setItem('bookMenuOpen_mo04_stop', 'Y'); //depth2 일 경우 서브밋 할 때 숨김 

				var frm = $("#frm");
				$("#frm").attr("action", oldAction)
				frm.submit();
			},
			init: function(){
				var sortField = '${searchVO.sortField1}';
				
				//console.log("sortField:::", sortField);
				document.querySelectorAll('#selectBox ul li').forEach(function(li){
					li.removeAttribute('data-selected');
					if(li.dataset.value == sortField) li.dataset.selected = true;
				})
			}
		});

	    //console.log(typeof selectBox1);

		/* 책옵션탭*/
		/* if(uct_type == "E"){

			$("#audiobook_cate").hide();
			$("#ebook_cate").show();

		}else if(uct_type == "A"){
			$("#audiobook_cate").show();
			$("#ebook_cate").hide();

		} else {
			$("#audiobook_cate").hide();
			$("#ebook_cate").hide();
			$(".btn_cate_more").css("display","none");
		} */

		// 이미지 상세 페이지 링크 연결
		$(".p_Bookcover img.cover").on("click", function() {

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
	})
	window.onclick = closeSelectBoxAll;

	function closeSelectBoxAll(){
	    document.querySelectorAll('[data-id="selectBox"]').forEach(sb => {
	        const exSelectBox = exSelectBoxArr.filter(x => x === '#' + sb.id);
	        if(!exSelectBox.length) sb.classList.remove('active');
	    })

	    exSelectBoxArr.length = 0;
	}

	function toggleCategoryStep2(viewType){
		console.log(viewType);
		var trg = document.querySelector('#category_step02');
		var cate2;
		if(viewType === 'E'){
			cate2 = trg.querySelector('#ebook_cate');
		}else if(viewType === 'A'){
			cate2 = trg.querySelector('#audiobook_cate');
		}

		var cateLength = cate2.querySelectorAll('ul li').length;

		cate2.querySelector('ul').style.height = (Math.ceil(cateLength / 3) * 37) + 'px';

		if(trg.classList.contains('more')) cate2.querySelector('ul').removeAttribute('style');
		trg.classList.toggle('more');

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
			// for(var ii = 0; ii < t.target.querySelectorAll('li').lenth; ii++){
			//     li1 = t.target.querySelectorAll('li')[ii];
			//     li.onclick = function () {
			//         t.value = li.dataset.value;
			//         t.title = li.innerText;
			//         t.update();
			//         t.target.classList.remove('active');
			//     }
			// }

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
			// t.target.querySelectorAll('ul li').forEach((li) => {
			//     li.removeAttribute('data-selected');
			//     if(li.dataset.value === t.value && li.innerText === t.title){
			//         li.dataset.selected = true;
			//         t.selectbox.innerHTML = t.title;
			//         t.hiddenInput.value = t.value;
			//     }
			// });
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

	//------ custom
	function fn_go_search() {
		var frm = $("#frm3");
		frm.submit();
	}
	var oldAction = ""

	function fn_search(uct_type, uct_code, uct_parent, depth){
		
		const $depth2 = $('.cateDepth.depth2');
		const s_uct_type = '${searchVO.uct_type}';
		const s_uct_code = '${searchVO.uct_code}';
		const s_uct_sub_code = '${searchVO.uct_parent}'; // 상위 카테고리 

		// 선택한 대분류에 다른 중분류를 선택 시 서브밋이 아닌 이전 중분류 노출 
		/* console.log("s_uct_code:", s_uct_code);
		console.log("uct_code:", uct_code); */
		if (depth === 'depth1' && uct_parent.trim() === s_uct_sub_code.trim()){ // 대분류가 동일 할 경우 
	    	if ($depth2.hasClass('active')) {
		        $depth2.removeClass('active');
		    } else {
		    	if (uct_code === "" && uct_parent === "") {
		    		return false;
		    	} else {
		    		$depth2.addClass('active');
		    	}
		    }
	    	return false;
	    }
		else if (depth === 'depth2' && uct_code.trim() === s_uct_code.trim() && uct_parent.trim() === s_uct_sub_code.trim()){ // 중분류가 동일 할 경우 
			if ($depth2.hasClass('active')) {
		        $depth2.removeClass('active');
		    } else {
		        $depth2.addClass('active');
		    }
	    	return false;
		}
		$("#uct_type").val(uct_type);
		$("#uct_code").val(uct_code);
		$("#uct_parent").val(uct_parent);

		if (depth === 'depth2') {
			sessionStorage.setItem('bookMenuOpen_mo04_stop', 'Y'); //depth2 일 경우 서브밋 할 때 숨김 
		} else {
			sessionStorage.setItem('bookMenuOpen_mo04_stop', 'N');
		}
		$("#frm").attr("action", oldAction)
		$("#frm").submit();
	}

	/*한페이지당 게시물 */
	function page(pagenum) {
		var frm = $("#frm");

		if($("#pagenum").length > 0 ){
			$("#pagenum").val(pagenum)
		}
		else {
			frm.append('<input type="hidden" id="pagenum" name="pagenum" value="' + pagenum +'">');
		}

		sessionStorage.setItem('bookMenuOpen_mo04_stop', 'Y');
		$("#frm").attr("action", oldAction)
		frm.submit();
	}
	function fn_view_mode(mode){
		$("#viewMode").val(mode);
		sessionStorage.setItem('bookMenuOpen_mo04_stop', 'Y');
		$("#frm").attr("action", oldAction)
		$("#frm").submit();

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
	
	// 바탕 클릭 시 
	$(document).on('click', function (e) {

		const $depth2 = $('.cateDepth.depth2');

	    if (!$depth2.hasClass('active')) return;

	    const $depth1 = $('.cateDepth.depth1');

	    const clickInside =
	        $(e.target).closest('.cateDepth.depth1').length ||
	        $(e.target).closest('.cateDepth.depth2').length;

	    if (!clickInside) {
	        $depth2.removeClass('active');
	    }
	});
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
				<button class="btn_search" onClick="fn_go_search();"><span class="blind">검색하기</span></button>
			</div>
			<div class="GNBpart">
				<ul class="GNB"><!-- GNB -->
					<li class=""><a href="/front/mobile/main.do">추천</a></li>
					<li class="on">
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
		<!--전체검색 부분 form-->
		<form name="frm" id="frm" action="/front/home/categoryList.do" method="post">
			<input type="hidden" id="viewMode" name="viewMode" value="${searchVO.viewMode }" />
			<input type="hidden" id="uct_code" name="uct_code" value="${searchVO.uct_code }" />
			<input type="hidden" id="uct_type" name="uct_type" value="${searchVO.uct_type }" />
			<input type="hidden" id="uct_parent" name="uct_parent" value="${searchVO.uct_parent }" />
			<input type="hidden" id="sortField1" name="sortField1" value="">
			<input type="hidden" name="searchMobileYn" value="Y" />
		</form>
		<form name="frm2" id="frm2" action="/front/mobile/bookDetail.do" method="post">
		</form>
		<form name="frm3" id="frm3" action="/front/mobile/searchList.do" method="post">
			<input type="hidden" id="preUrl" name="preUrl" value="library">
		</form>
		<div class="clear m_wrap_sub">
			<!-- 251119 [고] : 카테고리 메뉴 (마크업 신규 작업 되었습니다.) start// -->
			<div class="bookMenuCategory">
				<div class="cateNav">
					<select name="uct_type" id="uct_type" onchange="fn_search(this.value, '');">
			        	<option value="">전체</option>
			            <option value="E" <c:if test="${searchVO.uct_type eq 'E'}">selected</c:if>>eBook</option>
			            <option value="A" <c:if test="${searchVO.uct_type eq 'A'}">selected</c:if>>오디오북</option>
			        </select>
				</div>
				<div class="cateGroup"><!-- case : 전체 보기의 경우 cateGroup display:none -->
					<div class="cateRow">
						<div class="cateDepth depth1">
							<ul>
								<c:forEach items="${categoryMainList }" var="list" varStatus="status">	
								<li>
									<a href="#" 
										onclick="javascript:fn_search('${list.uct_type }','${list.uct_code }','${list.uct_code }', 'depth1'); return false;" 
										class="item 
											<c:if test="${searchVO.uct_code eq list.uct_code}">selected</c:if>
											<c:if test="${searchVO.uct_parent eq list.uct_code}">selected</c:if>
										">${list.uct_name }</a>
								</li>
								</c:forEach>
							</ul>
						</div>
						<div class="cateDepth depth2 <c:if test="${not empty searchVO.uct_code }">active</c:if>">
							<ul>
								<c:forEach items="${categorySubList }" var="subList" varStatus="status">	
								<li>
									<a href="#" 
										onclick="javascript:fn_search('${subList.uct_type }','${subList.uct_code }','${subList.uct_parent }', 'depth2'); return false;" 
										class="item <c:if test="${searchVO.uct_code eq subList.uct_code}">selected</c:if>
										">${subList.uct_name }</a>
								</li><!-- case : selected -->
								</c:forEach>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!-- //251119 [고] : 카테고리 메뉴 (마크업 신규 작업 되었습니다.) end -->
			<!-- 부커스 총종수 표시 -->
			<div class="total_number_Box">
				<p class="txt_total_number">
					부커스에는 <b class="t_point"><fmt:formatNumber value="${paging.totalCount }" pattern="#,###" />
					</b> 권의 책이 있어요. 지금 어떤 책을 읽어볼 지 확인해보세요.
				</p>
			</div>
			<!-- 251119 [고] : 리스트 타이틀 추가 start// -->
			<div class="cateTitleArea">
			  <h2 class="cateTitle"><span>${selectedMainCategroy}</span></h2>
			</div>
			<!-- //251119 [고] : 리스트 타이틀 추가 end -->
			<!-- 251119 [고] : 리스트 필터 영역 수정 start// -->
			<div class="searchHeadBar noLine">
			  <div class="leftSide">
			    <h2 class="cateTitle"><span class="current">${selectedSubCategroy}</span></h2>
			  </div>
			  <div class="rightSide">
			    <div id="selectBox" class="select-box bookArray_default"><!-- 251119 [고] : 주제별 리스트에 있는 select 코드 그대로 사용 & bookArray_default class 추가 -->
			      	<ul>
						<li data-value="" data-selected="true">출간일 순</li>
						<li data-value="ucm_regdate">업데이트 순</li>
						<li data-value="ucm_download_count">인기 순</li>
						<!-- <li data-value="">좋아요 순</li> -->
						<li data-value="ucm_title">제목 순</li>
					</ul>
			    </div>
			    <div class="listViewType">
			      <c:if test="${searchVO.viewMode eq 'L'}">
			      <button aria-label="카드형" onClick="fn_view_mode('S')"><img src="/images/v2/icon/ico_listViewType_card.svg" alt=""></button>
			      </c:if>
			      <c:if test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
			      <button aria-label="리스트형" onClick="fn_view_mode('L')"><img src="/images/v2/icon/ico_listViewType_list.svg" alt=""></button>
			      </c:if>
			    </div>
			  </div>
			</div>
			<div class="list-top">
							
			</div>
			<c:if test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
			<ul class="listTypeGrid">
			</c:if>
			<c:if test="${searchVO.viewMode eq 'L'}">
			<ul class="sch_result listFlex">
			</c:if>
				<c:choose>
					<c:when test="${empty chooseCmList }">
						<li>
							<div class="contentsNot" style="display:block; text-align: center;">
								<img src="/images/img_nodata.png" alt="" style="margin: 50px 0 20px;" width="80"/>
								<div>아직 등록된 도서가 없어요.</div>
							</div>
						</li>
					</c:when>
					<c:otherwise>
						<c:forEach items="${chooseCmList }" var="list" varStatus="status">
							<!-- 섬네일 모드 -->
							<c:choose>
								<c:when test="${empty searchVO.viewMode or searchVO.viewMode eq 'S'}">
									<li class="p_Book_item">
										<div class="p_Bookcover" id="${list.ucm_code }" series="${list.ucm_ucs_code }">
											<!-- 19금 도서 노출 유무 -->
											<c:if test="${mainList.uis_use_adult_book eq 'Y' }">
												<c:if test="${list.ucm_limit_age eq 'R' }">
													<img class="badge_adult" src="/images/icon_adult.png" alt="" />
												</c:if>
											</c:if>
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
													<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
												</c:otherwise>
											</c:choose>
										</div>
										<div class="p_book_titleArea">
											<!--책제목 나오는 부분-->
											<a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;">
												<span class="p_book_tit">${list.ucm_title }</span>
											</a>
											<div class="infoAuthorName">${list.ucm_writer }</div><!-- 251119 [고] : 저자명 추가 -->
											<div class="viewStatus"><!-- 251119 [고] : 읽고 있는 사람 수 노출 -->
												<p class="count"><em>${list.ucm_read_count }</em></p>
											</div>
										</div>
									</li>
								</c:when>
								<c:otherwise>
									<ul class="sch_result">
										<li class="sch_result_item" data-ucm-code="${list.ucm_code}" data-ume-code="${list.ume_code}" data-ume_codes="">
											<div class="sch_book_cover" id="${list.ucm_code }" series="${list.ucm_ucs_code }" style="margin-right: 15px;">
												<!-- 19금 도서 노출 유무 -->
												<c:if test="${mainList.uis_use_adult_book eq 'Y' }">
													<c:if test="${list.ucm_limit_age eq 'R' }">
														<img class="badge_adult" src="/images/icon_adult.png" alt="" />
													</c:if>
												</c:if>
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
														<img class="cover" src="<%=filePath %>${list.ucm_cover_url }" alt="" />
													</c:otherwise>
												</c:choose>
											</div>
											<div class="sch_book_infoWrap">
												<!--책제목 나오는 부분-->
												<div class="InfoArea">
													<a href="#"  onClick="fn_Detail('${list.ucm_code }','${list.ucm_code}');return false;">
													<div class="infoBookTitle">${list.ucm_title }</div>
													<div class="infoAuthorName">${list.ucm_writer }</div>
													<div class="infoPublisher">${list.ucp_brand }</div>
													</a>
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
										</li>
									</ul>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
			<!-- 페이징 처리 -->
			<div class="page_pn">
				<ul>
					<c:if test="${not empty chooseCmList }">
						<c:if test="${paging.prev}">
							<li>
								<a href="javascript:page(1);">
									<img src="/images/mobile/icon_page_first.svg" alt="첫페이지" />
								</a>
							</li>
							<li>
								<a href="javascript:page(${paging.getStartPage() - 10});">
									<img src="/images/mobile/icon_page_prev.svg" alt="이전페이지" />
								</a>
							</li>
						</c:if>
						<c:forEach begin="${paging.getStartPage()}" end="${paging.getEndPage()}" var="idx">
							<li class="n <c:if test='${paging.pagenum eq idx}'>t_black_b</c:if>">
								<a href="javascript:page(${idx});">${idx}</a>
							</li>
						</c:forEach>
						<c:if test="${paging.next}">
							<li>
								<a href="javascript:page(${paging.getEndPage() + 1});">
									<img src="/images/mobile/icon_page_next.svg" alt="다음페이지" />
								</a>
							</li>
							<li>
								<a href="javascript:page(${paging.getTotalPage() });">
									<img src="/images/mobile/icon_page_end.svg" alt="마지막페이지" />
								</a>
							</li>
						</c:if>
					</c:if>
				</ul>
			</div>
		</div>
	</main>
	<%@include file="../common/m_footer.jsp" %>
</body>
</html>