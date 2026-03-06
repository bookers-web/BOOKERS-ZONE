<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="filePath" value="https://files.bookers.life" />
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
	if('${frontCmVO.um_code ne reportVO.ubr_um_code }' == 'true'){
		// 아이디 마스킹 처리
		/*
		var originStr = $(".writer_ID").html();
		var maskingStr;
		var strLength = originStr.length;
		if(strLength < 3){
			maskingStr = originStr.replace(/(?<=.{1})./gi, "*");
		}else {
			maskingStr = originStr.replace(/(?<=.{2})./gi, "*");
		}
		
		$(".writer_ID").html(maskingStr);
		*/
		$(".writer_ID").each(function(){
			var maskingStr;
			var originStr = $(this).html();
			var strLength = originStr.length;
			
			maskingStr = originStr.substring(0,2);
			for(var i=0; i< strLength; i++){
				maskingStr += '*';
			}
			$(this).html(maskingStr);
		});
	}
	
	// 독서감상문 좋아요 버튼(빈 하트일 경우). 타인의 독서감상문 좋아요 하기
		
	// 독서감상문 좋아요 취소(채워진 하트일 경우). 타인의 독서감상문 좋아요 취소하기
	$(".btn_favorite_detail").on("click", function() {
		if ( $('.like_on').css('display') === 'inline-block' ){
			$.ajax( {
				url: "/front/lounge/bookReportCommentStateService.json",
				data: {"ubrc_code" : $("#ubrc_code").val(), "ubrc_ubr_code": $("#ubrc_ubr_code").val() },
				dataType: "json",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				async : false,
				success: function( data ) {
					if(data.count > 0 ){
						$("#like_on").css("display","none");
						$("#like_off").css("display","inline-block");
						var Like=$("#likeCount").text();//좋아요 값
						var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
						$("#likeCount").text(LikeNum-1);//나의 좋아요 클릭으로 카운트-1
						
						$("#ubrc_code").val("");
					}
				},
				error: function() {
					alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
				}
			});
		} else {
				$.ajax( {
					url: "/front/lounge/bookReportCommentStateService.json",
					data: {"ubrc_code" : '', "ubrc_ubr_code": $("#ubrc_ubr_code").val() },
					dataType: "json",
					contentType: "application/x-www-form-urlencoded; charset=UTF-8",
					async : false,
					success: function( data ) {
						if(data.count > 0 ){
							$("#like_off").css("display","none");
							$("#like_on").css("display","inline-block");
							var Like=$("#likeCount").text();//좋아요 값
							var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
							$("#likeCount").text(LikeNum+1);//나의 좋아요 클릭으로 카운트+1
							
							$("#ubrc_code").val(data.resultMsg);

						}
					},
					error: function() {
						alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
					}
				});
		}
	});
});

// 독서감상문 수정
function fn_write_book_report(ucm_code, ubr_code){
	
	var frm = $("#frm");
	
	if($("#selectUcmCode").length > 0 ){
		$("#selectUcmCode").val(ucm_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUcmCode" name="ucm_code" value="' + ucm_code +'">');
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

// 독서감상문 삭제
function fn_delete_book_report(ubr_code){
	
	var frm = $("#frm");
	
	if($("#selectUbrCode").length > 0 ){
		$("#selectUbrCode").val(ubr_code)
	}
	else {
		frm.append('<input type="hidden" id="selectUbrCode" name="ubr_code" value="' + ubr_code +'">');
	}
	
	$("#frm").attr("action","/front/myLibrary/deleteReportBook.do");
	// confirm("독서감상문을 삭제하시겠습니까?");
	// 성공 시 alert("독서감상문이 삭제되었습니다.");
	frm.submit();
	
}

// 독서감상문 공개 설정 변경
function fn_is_open_state(ubr_code){
	
	$.ajax( {
		url: "/front/myLibrary/readBookOpenStateService.json",
		data: {"ubr_code" : ubr_code, "ubr_is_open": $("input[name=ubr_is_open]:checked").val() },
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		success: function( data ) {
			if(data.count > 0 ){
				if ($('.radio_chk:checked').val() === 'Y'){
					alert("모든 기관 공개로 변경되었습니다.");
				} else {
					alert("소속 기관 공개로 변경되었습니다.");
				}
				$("#"+ubr_code).parent().hide();
				location.reload();
			}else{
				alert(data.resultMsg);
			}
		},
		error: function() {
			// $("#idCheck").val("N");
			alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
		}
	});
}

</script>
</head>
<body>
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
		<div class="reportDetail">
			<a href="javascript:history.back();"><img src="/images/icon_back.png" alt="" /></a>
			<span>독서감상문</span>
		</div>
		<hr/>
	</div>
	<div id="container">
		<form name="frm" id="frm" action="/front/lounge/main.do" method="post">
			<input type="hidden" id="ubrc_code" name="ubrc_code" value="${reportVO.ubrc_code }" />
			<input type="hidden" id="ubrc_ubr_code" name="ubrc_ubr_code" value="${reportVO.ubr_code }" />
		</form>
		<div class="content">

			<div class="contentsYes">
				<c:if test="${reportVO.ubr_is_open eq 'Y' }">
					<div class="mT_20 markBox"><span class="mark_all">모든 기관 공개</span></div>
				</c:if>
				<c:if test="${reportVO.ubr_is_open eq 'N' }">
					<div class="mT_20 markBox"><span class="mark_agency">소속 기관 공개</span></div>
				</c:if>
				<c:if test="${frontCmVO.um_code ne reportVO.ubr_um_code }">
				<div class="otherReport" style="display:block;">
					<div class="rDetail_title">${reportVO.ubr_title }</div>
					<div class="writer_ID">${reportVO.um_userid }</div>
					<div class="reportDate" style="padding: 7px 0 0 10px;">${fn:split(reportVO.ubr_regdate, ' ')[0].replace('-','.') }</div>
					<div style="clear: both;"></div>
					<div class="LR_Body">
						${reportVO.ubr_content }
					</div>
					<div class="btn_favorite_detail" style="cursor: pointer;">
						<c:choose>
						<c:when test="${reportVO.ubrc_type eq 'Y' }">
						<span class="like_on" id="like_on" style="display:inline-block; padding: 0;"><img src="/images/icon_favorite_on.png" alt="" /></span>
						<span class="like_off" id="like_off" style="display:none; padding: 0;"><img src="/images/icon_favorite_off.png" alt="" /></span>
						</c:when>
						<c:otherwise>
						<span class="like_off" id="like_off" style="padding: 0;"><img src="/images/icon_favorite_off.png" alt="" /></span>
						<span class="like_on" id="like_on" style="padding: 0;"><img src="/images/icon_favorite_on.png" alt="" /></span>
						</c:otherwise>
						</c:choose>
						<span class="likeCount" id="likeCount"><fmt:formatNumber value="${reportVO.ubr_like }" pattern="#,###" /></span>
					</div>	
				</div>
				</c:if>
				<c:if test="${frontCmVO.um_code eq reportVO.ubr_um_code }">
				<div class="myReport" style="display:block;">
					<div class="LR_private_icon"><img src="/images/icon_private.png" alt=""/></div><!--비공개아이콘-->
					<div class="LR_addSetting"><img src="/images/icon_ellipsis.png" alt=""/></div><!--추가설정아이콘-->
					<div class='settingBody'>
					<!-- <div class='settingExit'><img src='/images/icon_search_delete_bk.png' alt='' /></div> -->
					<div class='settingMenu' onClick="javascript:fn_write_book_report('${reportVO.ucm_code}', '${reportVO.ubr_code }')">수정</div>
					<div class='settingMenu' onClick="javascript:fn_delete_book_report('${reportVO.ubr_code }')">삭제</div>
					<div class='settingMenu privacy'>공개설정 변경</div>
					</div>
					<div class='privacySetting'>
						<div class='privacyExit'>공개 설정 변경<img class='exit' src='/images/icon_search_delete_bk.png' alt='' /></div>
						<div class='privacyMenu'>모든 기관 공개
							<div class='radio_wrap'>
								<input type='radio' id='openSett' class='radio_chk' name='ubr_is_open' value="Y" <c:if test="${reportVO.ubr_is_open eq 'Y' }">checked="checked"</c:if> >
								<label for='openSett'><span></span></label>
							</div>
						</div>
						<div class='privacyMenu'>소속 기관 공개
							<div class='radio_wrap'>
								<input type='radio' id='closeSett' class='radio_chk' name='ubr_is_open' value="N" <c:if test="${reportVO.ubr_is_open eq 'N' }">checked="checked"</c:if> >
								<label for='closeSett'><span></span></label>
							</div>
						</div>
						<button type='button' class='change_cancel'>취소</button>
						<button type='button' class='change_ok' id="${reportVO.ubr_code }" onClick="javascript:fn_is_open_state('${reportVO.ubr_code }');return false;" >확인</button>
					</div>
					<div class="rDetail_title">${reportVO.ubr_title }</div>
					<div class="LR_DateTime">
						<span class="date">${fn:split(reportVO.ubr_regdate, ' ')[0] }</span>
						<!-- <span class="time"><img src="/images/icon_clock.png" alt="" /> ${fn:split(reportVO.ubr_regdate, ' ')[1] }</span> -->
					</div>
					
					<div style="clear: both;"></div>
					<div class="LR_Body">
						${reportVO.ubr_content }
					</div>
					<div class="rDetail_likeCount">
						<button class="btn_favorite_detail_myR" data-toggle="modal" data-target="#intro"><span class="off">${reportVO.ubr_like }</span></button><!-- 좋아요 버튼이 클리기하면 span class="on"으로 변경 -->
							<div class="modal fade" id="intro" role="dialog" aria-labelledby="introHeader" aria-hidden="true" tabindex="-1">
								<div class="modal-dialog">
									<div class="modal-content">
								        <div class="modal-header">
								           <h4 class="modal-title">알림</h4>
								        </div>
								        <div class="modal-body">
								           <p>자신의 글은 좋아요를 할 수 없습니다.</p>
								        </div>
								        <div class="modal-footer">
								           <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
								        </div>
								    </div>
								 </div>
							</div>
						<!-- 
						<span class="like_txt">좋아요</span>
						<span class="like_default"><img src="/images/icon_favorite_d.png" alt="" /></span>
						<span class="likeCount"><fmt:formatNumber value="${reportVO.ubr_like }" pattern="#,###" /></span>
						 -->
					</div>
				</div>
				</c:if>
			</div>
		</div>
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>

</body>
</html>
