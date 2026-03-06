<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {

	<c:if test="${not empty bomBoardVO}">
		let notice = [];
		let curDate =  new Date();
		let path = 'https://files.bookers.life';
		<c:forEach var="notice" items="${bomBoardVO}">
			notice.push({
				un_no: '${notice.un_no}',
				un_uis_code: '${notice.un_uis_code}',
				un_event_url: '${notice.un_event_url}',
				un_image_url: '${notice.un_image_url}',
				un_display_startdate: '${notice.un_display_startdate}',
				un_display_enddate: '${notice.un_display_enddate}',
				un_expiry_date: '${notice.un_expiry_date}',
				un_message: '${notice.un_message}',
				displayStartDate: new Date('${notice.un_display_startdate}'),
				displayEndDate: new Date('${notice.un_display_enddate}')
			});
		</c:forEach>

		notice.forEach(function (notice) {
		    var unUisCode = notice.un_uis_code ? notice.un_uis_code : "default";
		    var cookieKey = "popup-overlay-" + unUisCode + "-" + notice.un_no;
		    var cookieValue = getCookie(cookieKey);
		    
		    // 세션의 UM_UIS_CODE (템플릿 변수)
		    var sessionUisCode = '${sessionScope.UM_UIS_CODE}';
		    if (!sessionUisCode) {
		        sessionUisCode = "default";
		    }
		    
		    if (cookieValue !== "Y" && (unUisCode === "default" || sessionUisCode === unUisCode)) {
		        if (notice.displayStartDate.getTime() <= curDate.getTime() &&
		            curDate.getTime() <= notice.displayEndDate.getTime()) {
		            $("#popup-" + notice.un_no).css('display', 'block');
		            return false;  // 반복 종료
		        } else {
		            $("#popup-" + notice.un_no).remove();
		        }
		    } else {
		        $("#popup-" + notice.un_no).remove();
		    }
		});

	</c:if>
	// 팝업이 남아 있는지 확인
	if ($('.popup-content').length === 0) {
		$('.popup-overlay').remove(); // 남은 팝업이 없으면 overlay 제거
	}
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
  // const ucmCode = $book.data('ucmCode') || $(this).parent().attr('id') || '';
  // const ucsCode = $book.data('ucsCode') || $(this).parent().attr('ucm_ucs_code') || '';
  const ucmCode = $book.data('ucmCode') || $book.attr('id') || '';
  const ucsCode = $book.data('ucsCode') || $book.attr('ucm_ucs_code') || '';
  
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

//쿠키설정
function setCookie(name, value, expiredays, noticeId) {
    let todayDate = new Date();
    todayDate.setDate(todayDate.getDate() + expiredays);
    document.cookie = name + '=' + encodeURIComponent(value) + '; path=/; expires=' + todayDate.toUTCString() + ';';
    closePopup(noticeId);
}


//쿠키 불러오기
function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i].trim();
        if (c.indexOf(nameEQ) === 0) {
            return decodeURIComponent(c.substring(nameEQ.length));
        }
    }
    return "";
}



function fn_location(){
	fn_event_url();
}

function fn_event_url(uem_code) {
    // form 생성
    const frm = document.createElement('form');
    frm.setAttribute('method', 'post'); // form 전송 방식 설정
    frm.setAttribute('action', '/front/home/eventDetail.do'); // form 전송 URL 설정

    // uem_code input 생성 및 추가
    const inputUemCode = document.createElement('input');
    inputUemCode.setAttribute('type', 'hidden');
    inputUemCode.setAttribute('name', 'uem_code');
    inputUemCode.setAttribute('value', uem_code); // 전달된 값 설정
    frm.appendChild(inputUemCode);

    // uem_url input 생성 및 추가
    const url = '/front/home/eventDetail.do';
    const inputUemUrl = document.createElement('input');
    inputUemUrl.setAttribute('type', 'hidden');
    inputUemUrl.setAttribute('name', 'uem_url');
    inputUemUrl.setAttribute('value', url);
    frm.appendChild(inputUemUrl);

    // form을 body에 추가 후 제출
    document.body.appendChild(frm);
    frm.submit();
}

function fn_event_url2(){
	// form 생성
    const frm = document.createElement('form');
    frm.setAttribute('method', 'post'); // form 전송 방식 설정
    frm.setAttribute('action', 'https://busan.nanet.go.kr/loanIssue/loanIssueList.do'); // form 전송 URL 설정

    // form을 body에 추가 후 제출
    document.body.appendChild(frm);
    frm.setAttribute("target", "_blank");
    frm.submit();
}

function closePopup(noticeId) {
    // 특정 팝업 요소 삭제
    let popupElement = document.getElementById(`popup-`+noticeId);
    if (popupElement) {
        popupElement.remove(); // 해당 팝업 삭제
    }
	// 모든 팝업이 닫힌 경우 overlay 숨김
    const remainingPopups = document.querySelectorAll('.popup-content');
    if (remainingPopups.length === 0) {
        const overlay = document.querySelector('.popup-overlay');
        if (overlay) {
            overlay.style.display = 'none'; // overlay 숨김
        }
    }
}

</script>
<style type="text/css">
.popup-overlay {
    display: flex;
    justify-content: center; /* 가로 정렬 */
    align-items: flex-start; /* 세로로 위쪽 정렬 */
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1000;
    padding: 20px; /* 전체 여백 */
    overflow-x: auto; /* 가로 스크롤 활성화 */
}

.popup-container {
    display: flex;
    flex-direction: row; /* 가로 정렬 */
    gap: 20px; /* 팝업 간격 */
    flex-wrap: nowrap; /* 줄바꿈 안 함 */
    width: 100%; /* 부모 요소의 가로 크기 유지 */
    justify-content: center; /* 중앙 정렬 */
	margin-top: 150px;
}

.popup-content {
	display: none;
    position: relative; /* 버튼 위치를 기준으로 조정할 수 있도록 relative 설정 */
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    text-align: center;
    min-width: 600px; /* 팝업 고정 너비 */
    max-width: 600px;
    background: #fff; /* 팝업 배경색 */
}
.popup-close {
    position: absolute;
    top: 10px; /* 팝업의 상단으로부터 10px 떨어짐 */
    right: 10px; /* 팝업의 오른쪽으로부터 10px 떨어짐 */
    background: none;
    border: none;
    font-size: 18px;
    font-weight: bold;
    color: #fafafa;
    cursor: pointer;
    z-index: 1; /* 닫기 버튼을 항상 위에 표시 */
}
.popup-close:hover {
    color: #ff0000; /* 호버 시 버튼 색상 */
}

.popup-bottom {
    margin-top: 10px;
    background: transparent; /* 배경 투명 */
    color: #333; /* 텍스트 색상 */
    border: 1px solid #333; /* 테두리 추가 */
    padding: 5px 10px; /* 버튼 크기 */
    cursor: pointer;
    border-radius: 5px;
    font-size: 14px;
}

.popup-bottom:hover {
    background: rgba(0, 0, 0, 0.1); /* 호버 시 약간의 배경색 */
    color: #000; /* 텍스트 색상 변경 */
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
		<nav id="snb">
			<ul class="snb_list">
				<li>
					<a href="/front/home/main.do" class="nav_focus">추천</a>
				</li>
				<li>
					<a href="/front/home/newBookList.do">최신 업데이트</a>
				</li>
				<li>
					<a href="/front/home/popularList.do">인기</a>
				</li>
				<li>
					<a href="/front/home/categoryList.do">주제별</a>
					<c:if test="${hasEbook or hasAudio}">
					<div class="depth-sub">
						<c:if test="${hasEbook}">
						<a href="/front/home/categoryList.do?uct_type=E" class="<c:if test="${searchVO.uct_type eq 'E'}">on</c:if>">eBook</a>
						</c:if>
						<c:if test="${hasAudio}">
						<a href="/front/home/categoryList.do?uct_type=A" class="<c:if test="${searchVO.uct_type eq 'A'}">on</c:if>"">오디오북</a>
						</c:if>
					</div>
					</c:if>
				</li>
			</ul>
		</nav>
		<hr/>
	</div>
	<div id="container">
		<form name="frm" id="frm" action="/front/home/recommendList.do" method="post">
		</form>
		<form name="frm2" id="frm2" action="/front/home/bookDetail.do" method="post">
		</form>
		<div class="popup-overlay">
			<div class="popup-container">
				<c:if test="${sessionScope.UM_UIS_CODE != null && not empty bomBoardVO}">
				    <c:forEach var="notice" items="${bomBoardVO}">
				        <!-- notice.un_uis_code가 null 또는 empty이면 true, 아니면 세션과 비교 -->
				        <c:if test="${empty notice.un_uis_code or sessionScope.UM_UIS_CODE == notice.un_uis_code}">
				            <div class="popup-content" id="popup-${notice.un_no}">
				                <button type="button" class="popup-close" onclick="closePopup('${notice.un_no}');">×</button>
				                <c:choose>
				                    <c:when test="${not empty notice.un_event_url}">
				                        <img src="<%=filePath %>${notice.un_image_url}" alt="" id="endImg-${notice.un_no}" width="600" height="750" onclick="fn_event_url('${notice.un_event_url}')" />
				                    </c:when>
				                    <c:otherwise>
				                        <c:choose>
				                    		<c:when test="${sessionScope.UM_UIS_CODE == 'UIS0000000517' || sessionScope.UM_UIS_CODE == 'UIS0000000619' }">
				                    			<img src="<%=filePath %>${notice.un_image_url}" alt="" id="endImg-${notice.un_no}" width="600" height="750" onclick="fn_event_url2()" />
				                    		</c:when>
				                    		<c:otherwise>
				                    			<img src="<%=filePath %>${notice.un_image_url}" alt="" id="endImg-${notice.un_no}" width="600" height="750" />
				                    		</c:otherwise>
				                    	</c:choose>
				                    </c:otherwise>
				                </c:choose>
								<button type="button" onclick="setCookie('popup-overlay-${empty notice.un_uis_code ? 'default' : notice.un_uis_code}-${notice.un_no}', 'Y', ${notice.un_expiry_date}, ${notice.un_no});" class="popup-bottom">${notice.un_message}</button>
				            </div>
				        </c:if>
				    </c:forEach>
				</c:if>

			</div>
		</div>
		<div class="content w-full-layout"><!-- 251119 [고] : w-full-layout class 추가 -->
			<c:choose>
			<c:when test="${empty list }">
				<div class="contentsNot" style="display:block;">
					<img src="/images/img_nodata.png" alt="" />
					<div>아직 등록된 추천도서가 없어요.</div>
				</div>
			</c:when>
			<c:otherwise>
				
				<div class="contentsYes">
				
				<c:forEach items="${list }" var="mainList">
				<!-- 251119 [고] :cardListItemGroup 그룹핑 추가 loop start// -->
				<div class="cardListItemGroup">
					<div class="cardListTitle">
						<a href="/front/home/recommendList.do?uil_code=${mainList.uil_code }" class="cardList_detail"><span class="txtPart">${mainList.uil_name }</span>
						<img src="/images/icon_more_view.png" alt="" /></a>
					</div>
					<div class="cardList_wrap swiper-container">
						<ul class="cardList_content swiper-wrapper">
							<c:forEach items="${mainList.bookList }" var="book">
							<li class="swiper-slide">
								<div class="coverArea">
									<div class="book" id="${book.ucm_code }" series="${book.ucm_ucs_code }">
										<!-- 19금 도서 노출 유무 -->
										<c:if test="${mainList.uis_use_adult_book eq 'Y' }">
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

										<c:choose>
										<c:when test="${empty book.ucm_cover_url }">
										<img class="cover" src="/images/img_coverNot.png" alt="" />
										</c:when>
										<c:otherwise>
										<div class="bookBG">
                        				<span class="back"></span><!-- 251119 [고] : back 추가 -->
										<img class="cover" src="<%=filePath %>${book.ucm_cover_url }" alt="" />
										<c:choose>
										<c:when test='${book.uce_use_yn eq "Y" }'>
										<img src="/images/v2/icon/badge_bookers_only.png" class="bdg-booker-only" width="36" alt="부커스단독 /"><!-- 251119 [고] : 부커스단독 뱃지 추가 -->
										</c:when>
										</c:choose>
										 </div>
										</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="bookTitle_recomand"><a href="#"  onClick="fn_Detail('${book.ucm_ucs_code }','${book.ucm_code}');return false;">${book.ucm_title }</a> </div>

								<div class="infoAuthorName2">${book.ucm_writer }</div>
								<div class="bookBadgeGroup"><!-- 251119 [고] : 리스트 뱃지 추가 -->
									<c:choose>
										<c:when test='${book.badge_e eq "Y" }'>
										<span class="book-bdg-event">이벤트</span>
										</c:when>
									</c:choose>
									<c:choose>
										<c:when test='${book.badge_n eq "Y" }'>
										<span class="book-bdg-recent">최신</span>
										</c:when>
									</c:choose>
									<c:choose>
										<c:when test='${book.badge_p eq "Y" }'>
										<span class="book-bdg-best">인기</span>
										</c:when>
									</c:choose>
								</div>
							</li>
							</c:forEach>
						</ul>
						<c:if test="${mainList.book_count > 6 }">
						<div class="cardList_btn">
							<div class="btn1 swiper-button-next"><img src="/images/btn_slide_next.png" alt="다음 버튼" class="next"></div>
							<div class="btn2 swiper-button-prev"><img src="/images/btn_slide_prev.png" alt="이전 버튼" class="prev"></div>
						</div>
						</c:if>
					</div>
					<div class="blankArea"></div>
				</div>
					<!-- //251119 [고] :cardListItemGroup 그룹핑 추가 loop end -->
				</c:forEach>
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
