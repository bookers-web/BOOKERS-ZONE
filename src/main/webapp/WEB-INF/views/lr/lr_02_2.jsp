<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/common/header-script.jsp" %>

<script type="text/javascript">
$(document).ready(function() {

	oldAction = $("#frm").attr("action")
	
	$("#modifyButton").hide();
	$("#modifyCancelButton").hide();
	// 아이디 마스킹 처리 IE / CHROME
	/* var originStr = $(".other").html();
	if(originStr != null){
		var maskingStr;
		var strLength = originStr.length;
		if(strLength < 3){
			maskingStr = originStr.replace(/(?<=.{1})./gi, "*");
		}else {
			maskingStr = originStr.replace(/(?<=.{2})./gi, "*");
		}
		$(".other").html(maskingStr);
	} */
	
	// 아이디 마스킹 처리 사파리에서  지원안해서 바꿈
	$(".other").each(function(){
		var maskingStr;
		var originStr = $(this).html();
		var strLength = originStr.length;
		
		maskingStr = originStr.substring(0,2);
		for(var i=0; i< strLength; i++){
			maskingStr += '*';
		}
		$(this).html(maskingStr);
	});
	
	// 시간처리 start
	var today = new Date();
	if('${not empty myDiscussionVO }' == 'true'){
		$("div[class=aTime]").each(function(){
			var timeValue = new Date($(this).text());
			var betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
			if (betweenTime < 1) $(this).text('방금전') ;
			if (betweenTime < 60) {
				$(this).text(betweenTime+'분전') ;
				return;
			}
			var betweenTimeHour = Math.floor(betweenTime / 60);
			if (betweenTimeHour < 24) {
				$(this).text(betweenTimeHour+'시간전') ;
				return;
			}
		});
	}
	
	$("div[class=writingTime]").each(function(){
		var timeValue = new Date($(this).text());
		var betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
		if (betweenTime < 1) $(this).text('방금전') ;
		if (betweenTime < 60) {
			$(this).text(betweenTime+'분전') ;
			return;
		}
	
		var betweenTimeHour = Math.floor(betweenTime / 60);
		if (betweenTimeHour < 24) {
			$(this).text(betweenTimeHour+'시간전') ;
			return;
		}
	});
	
	// 시간처리 end
	
	// 정렬 방식 변경 시
	$("#sortField").on('change', function() {
		var frm = $("#frm");
		
		$("#sortField1").val($("#sortField").val());
		$("#frm").attr("action", oldAction)
		frm.submit();
	});
	
	// 도서 이미지 클릭 시
	$(".book img.cover").on("click", function() {
		
		var frm = $("#frm");
		
		if($("#selectUcsCode").length > 0 ){
			$("#selectUcsCode").val($(this).parent().attr("ucm_ucs_code"))
		}
		else {
			frm.append('<input type="hidden" id="selectUcsCode" name="ucm_ucs_code" value="' + $(this).parent().attr("ucm_ucs_code") +'">');
		}
		
		$("#frm").attr("action","/front/home/bookDetail.do");
		
		frm.submit();
	});
	
	// 독서토론 좋아요 버튼(빈 하트일 경우). 타인의 독서토론 좋아요 하기
	$(".like_off").on("click", function() {
		var like_off = $(this).attr("id");
		var ucd_code = $(this).attr("id").split("_")[2];
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/lounge/modifyDiscussionCommentService.json",
			data: {"ucdc_code" : '', "ucd_code" : ucd_code },
			async : false,
			dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					$("#"+like_off).css("display","none");
					$("#"+like_on).css("display","inline-block");
					var Like=$("#count_"+ucd_code).text();//좋아요 값
					var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
					$("#count_"+ucd_code).text(LikeNum+1);//나의 좋아요 클릭으로 카운트+1					
					$("#ucdc_code_"+ucd_code).val(data.resultMsg);
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
		
	});
	// 독서토론 좋아요 취소(채워진 하트일 경우). 타인의 독서감상문 좋아요 취소하기
	$(".like_on").on("click", function() {
		var ucd_code = $(this).attr("id").split("_")[2];
		var like_off = "like_off_"+ucd_code;
		var like_on = 'like_on_'+ $(this).attr("id").split("_")[2];
		
		$.ajax( {
			url: "/front/lounge/modifyDiscussionCommentService.json",
			data: {"ucdc_code" : $("#ucdc_code_"+ucd_code).val(), "ucd_code" : ucd_code },
			dataType: "json",
			async : false,
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					$("#"+like_on).css("display","none");
					$("#"+like_off).css("display","inline-block");
					var Like=$("#count_"+ucd_code).text();//좋아요 값
					var LikeNum=parseInt(Like);//좋아요 값 정수로 변환
					$("#count_"+ucd_code).text(LikeNum-1);//나의 좋아요 클릭으로 카운트-1
					
					$("#ucdc_code_"+ucd_code).val("");
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
	});
	
	// 신고하기 팝업 열기
	$(".notify_open").on("click", function() {
		$(this).parent().hide();
		$(".notify_Pop").show();
		$("body").css("overflow","hidden");
		$("#urc_ucd_code").val($(this).parent().attr("id").split("_")[2]);
	});
	
});

/*한페이지당 게시물 */
 
var oldAction = ""

function page(pagenum) {
	var frm = $("#frm");
	frm.append('<input type="hidden" name="pagenum" value="' + pagenum +'">');

	$("#frm").attr("action", oldAction)
	frm.submit();
}

// 토론글 수정을 위한 데이터 설정
var modifyUcdCode = '';
var modifyType = '';

function fn_modify_set(ucd_code) {
	modifyUcdCode = ucd_code;
	modifyType = 'modify';
	
	var comment = $("#cmt"+ucd_code).html();
	
	comment = comment.replace(/<br>/g, '\r\n');
	comment = comment.replace(/<br>/g, '\r\n');
	
	$("#regiterButton").hide();
	$("#modifyButton").show();
	$("#modifyCancelButton").show();
	
	$(".comment_input").hide();
	$(".comment_Act").show();//실제 입력 창 노출하고
	$("#ucd_comment").focus();//포커스
	$("#ucd_comment").text(comment);
	
	
	autoResize(document.getElementById('ucd_comment'));
	

	$("#ucd_comment").focus().text($("#ucd_comment").val());
	
	var e = $.Event('keydown');
    e.which = 13; // Enter
	
	$("#ucd_comment").focus().trigger(e);
	
}

function fn_modify_cancel() {
	
	modifyUcdCode = '';
	modifyType = '';
	
	$(".comment_Act").hide();//실제 입력창 감추기
	$(".comment_input").show()//입력안내창 보이기
	$(".typing").text("");//실제 입력창 값 지우기
	
	$("#modifyButton").hide();
	$("#modifyCancelButton").hide();
	$("#regiterButton").show();
}

// 토론글 등록
function fn_save(ucd_code, type){
	
	var frm = $("#frm");
	
	$("#frm").attr("action","/front/lounge/discussionWriteProc.do");
	frm.append('<input type="hidden" id="selectUcdCode" name="ucd_code" value="' + ucd_code +'">');

	
	if($("#ucd_comment").val() == ""){
		
		alert("내용을 입력해주세요.");
		return false;
	}
	
	frm.submit();
}

//내글 -> 수정
function fn_save_modify(ucd_code, type){
	
	var frm = $("#frm");
	
	$("#frm").attr("action","/front/lounge/discussionWriteProc.do");
	if(type == 'modify'){
		
		if($("#selectUcdCode").length > 0 ){
			$("#selectUcdCode").val(ucd_code)
		}
		else {
			frm.append('<input type="hidden" id="selectUcdCode" name="ucd_code" value="' + ucd_code +'">');
		}
		
		$("#ucd_comment").val($("#modify_"+ucd_code).val());
		
	}
	
	if($("#ucd_comment").val() == ""){
		
		alert("내용을 입력해주세요.");
		return false;
	}
	
	frm.submit();
}
function fn_delete_discussion(ucd_code, type){
	
	if(confirm("글을 삭제하시겠습니까?")){
		$.ajax( {
			url: "/front/lounge/modifyDiscussionService.json",
			data: {"ucd_code" : ucd_code, "ucd_comments": "" },
			dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					if(type == '1'){
						$("#"+ucd_code).hide();
					}else if(type == '2'){
						$("#"+ucd_code).hide();
						$("#my_"+ucd_code).hide();
					}
					
				}else{
					alert(data.resultMsg);
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
	}
}

function fn_copyright(){
	var urc_title = $("input[name=radio_chk]:checked").val();
	
	var urc_content = "";
	if(urc_title == "기타"){
		// 신고 사유
		urc_content = $("input[name=radio_chk]:checked").parent().parent().find("textarea").val();
		
		// 금칙어 확인
		var upw = $("#upw_list").val().split(";");
		for(var i = 0; i < upw.length-1; i++){
			if(urc_content.indexOf(upw[i]) != -1){
				alert("'" + upw[i] + "' 과 같은 부적절한 용어는 사용 불가능합니다.");
				return false;
			}
		}
	}
	
	if(confirm("신고하시겠습니까?")){
		$.ajax( {
			url: "/front/lounge/reportCopyrightService.json",
			data: { "urc_ucd_code" : $("#urc_ucd_code").val(),
					"urc_title": encodeURI($("input[name=radio_chk]:checked").val()),
					"urc_content" : encodeURI(urc_content),
					"urc_ucm_code" : $("#ucm_code").val()
			},
			dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function( data ) {
				if(data.count > 0 ){
					$(".notify_Pop").hide();
					$("body").css("overflow","scroll");
				}else{
					alert(data.resultMsg);
				}
			},
			error: function() {
				alert("작업중 오류가발생하였습니다. 잠시후 다시 시도해주세요.");
			}
		});
	}
}

function escapeHtml(str) { 
	if (typeof(str) == "string"){ 
		try{ 
			var newStr = ""; 
			var nextCode = 0; 
			
			for (var i = 0;i < str.length;i++){ 
				nextCode = str.charCodeAt(i); 
				if (nextCode > 0 && nextCode < 128){ 
					newStr += "&#"+nextCode+";"; 
				} 
				else{ 
					newStr += "?"; 
				} 
			} 
			return newStr; 
		} 
		catch(err){ 
			
		} 
	} 
	else{ 
		return str; 
	} 
}

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
		<div class="reportDetail">
			<a href="/front/lounge/discussion.do"><img src="/images/icon_back.png" alt="" /></a>
			<span>독서토론</span>
		</div>
		<hr/>
	</div>
	<div id="container">
		<div class="content">
			<div class="contentsYes">
				<div class="rDetail_bookInfo mT_50">
					<div class="coverArea">
						<div class="book" id="${cmVO.ucm_code }">
							<!-- 19금 도서 노출 유무 -->
							<c:if test="${cmVO.ucm_limit_age eq 'R' }">
							<img class="badge_adult" src="/images/icon_adult.png" alt="" />
							</c:if>
							
							<!-- 파일 형태 -->
							<c:choose>
							<c:when test='${cmVO.ucm_file_type eq "PDF" }'>
							<img class="book_badge" src="/images/icon_pdf.png" alt="" />
							</c:when>
							<c:when test='${cmVO.ucm_file_type eq "ZIP" or cmVO.ucm_file_type eq "COMIC" }'>
							<img class="book_badge" src="/images/icon_comic.png" alt="" />
							</c:when>
							<c:when test='${cmVO.ucm_file_type eq "AUDIO" }'>
							<img class="book_badge" src="/images/icon_audiobook.png" alt="" />
							</c:when>
							<c:otherwise>
							
							</c:otherwise>
							</c:choose>
							
							<!-- 표지 이미지 -->
							<c:choose>
							<c:when test="${empty cmVO.ucm_cover_url }">
							<img class="cover" src="/images/img_coverNot.png" alt="" />
							</c:when>
							<c:otherwise>
							<img class="cover" src="<%=filePath %>${cmVO.ucm_cover_url }" alt="" />
							</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="info_bookTitle">${cmVO.ucm_title }</div>
					<div class="bookSubtitle">${cmVO.ucm_sub_title }</div>
					<div class="authorName">${cmVO.ucm_writer }</div>
					<div class="publisher">${cmVO.ucp_brand }</div>
				</div>
				<div class="optionMenu_area mT_30">
					<div class="totalNum">총 <span><fmt:formatNumber value="${paging.getTotalCount() }" pattern="#,###" /></span> 개</div>
					<c:if test="${not empty cmVO.ucd_code and cmVO.ucd_code ne ''}">
						<div class="menuSelect_area3" id="${cmVO.ubr_code }">
							<button class="myComment_Btn">내 글</button>
						</div>
					</c:if>
				</div>
				<form name="frm" id="frm" action="/front/lounge/discussionView.do" method="post" accept-charset="UTF-8">
					<input type="hidden" id="ucm_code"		name="ucm_code"		value="${searchVO.ucm_code }" />
					<input type="hidden" id="um_code"		name="um_code"		value="${searchVO.um_code }" />
					<input type="hidden" id="upw_list" value="${prohibitionVO.upw_list }" />
					<input type="hidden" id="urc_ucd_code"	name="urc_ucd_code" />
					<input type="text" class="comment_input" placeholder="글을 입력해 주세요">
					<div class="comment_Act">
						<textarea class="typing" id="ucd_comment" name="ucd_comment" placeholder="글을 입력해 주세요" maxlength="600" onkeydown="autoResize(this)" onkeyup="autoResize(this)"></textarea>
						<div class="inputGuideLine">
							<div class="noticeArea">
								<span class="pointPop_open"><img src="/images/icon_info.png" alt="" />글 작성 유의사항</span>
								<span class="bar">|</span>
								작성 기준을 위반할 경우 글이 삭제될 수 있습니다.
							</div>
							<div class="registArea">
								<span class="typing_length">0</span> / 600
								<button type="submit" class="registBtn" id="regiterButton" onClick="javascript:fn_save(modifyUcdCode, modifyType);return false;">등 록</button>
								<button type="submit" class="registBtn" id="modifyCancelButton" onClick="javascript:fn_modify_cancel();return false;">취 소</button>
								<button type="submit" class="registBtn" id="modifyButton" onClick="javascript:fn_save(modifyUcdCode, modifyType);return false;">수 정</button>
							</div>
						</div>
					</div>
				</form>
				<script>
					function autoResize(obj){
						obj.style.height = "1px";
						obj.style.height = (2+obj.scrollHeight)+"px";
					}
				</script>
				<div class="CommentNot">
					<img src="/images/img_nodata_sm.png" alt="" />
					<div>아직 작성된 글이 없어요.</div>
					<div style="color:#999999;">첫 토론 글을 작성해 보시겠어요?</div>
				</div>
				<div class="CommentYes">
					<ul class="bookComment">
						<c:forEach items="${list }" var="list">
						<li id="${list.ucd_code }">
							<c:choose>
							<c:when test="${list.ucd_um_code eq searchVO.um_code }">
								<div class="myComment">
									<div class='LR_addSetting'><img src='/images/icon_ellipsis.png' alt=''/></div>
									<div class='LR_settingBody'>
										<!-- <div class='settingExit'><img src='/images/icon_search_delete_bk.png' alt='' /></div> -->
										<div class='settingMenu' onClick="javascript:fn_modify_set('${list.ucd_code }')">수정</div>
										<div class='settingMenu' onClick="javascript:fn_delete_discussion('${list.ucd_code }','1')">삭제</div>
									</div>
									<div class="reportWriter mine">내 글</div>
									<div class="commentText" id="cmt${list.ucd_code }"><c:out value="${list.ucd_comment}" /></div>
									<div class="writingTime">${list.ucd_regdate }</div>
									<div class="comment_likeCount">
										<button class="btn_favorite" data-toggle="modal" data-target="#intro"><span class="off" style="padding-right: 5px;"></span></button><span class="likeCount">${list.like_count }</span>
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
										<!-- <span class="like_default"><img src="/images/icon_favorite_d.png" alt="" /></span>
										<span class="likeCount">${list.like_count }</span> -->
									</div>
									<div style="clear:both;"></div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="otherComment">
									<div class='LR_addSetting'><img src='/images/icon_ellipsis.png' alt=''/></div>
									<div class='LR_settingBody' id="urc_ucd_${list.ucd_code }">
										<!-- <div class='settingExit'><img src='/images/icon_search_delete_bk.png' alt='' /></div> -->
										<div class='settingMenu notify_open'>신고</div>
									</div>
									<div class="reportWriter other">${list.ucd_um_userid }</div>
									<div class="commentText"><c:out value="${list.ucd_comment}" /></div>
									<div class="writingTime">${fn:split(list.ucd_regdate, ' ')[0] }</div>
									<div class="comment_likeCount">
										<c:choose>
										<c:when test="${not empty list.ucdc_um_code }">
										<input type="hidden" id="ucdc_code_${list.ucd_code }" value="${list.ucdc_code }" />
										<span class="like_off" id="like_off_${list.ucd_code }" style="display:none;"><img src="/images/icon_favorite_off.png" alt="" /></span>
										<span class="like_on" id="like_on_${list.ucd_code }" style="display:inline-block;"><img src="/images/icon_favorite_on.png" alt="" /></span>
										</c:when>
										<c:otherwise>
										<input type="hidden" id="ucdc_code_${list.ucd_code }" />
										<span class="like_off" id="like_off_${list.ucd_code }" ><img src="/images/icon_favorite_off.png" alt="" /></span>
										<span class="like_on" id="like_on_${list.ucd_code }"><img src="/images/icon_favorite_on.png" alt="" /></span>
										</c:otherwise>
										</c:choose>
										
										<span class="likeCount" id="count_${list.ucd_code }">${list.like_count }</span>
									</div>
									<div style="clear:both;"></div>
								</div>
							</c:otherwise>
							</c:choose>
						</li>
						</c:forEach>
					</ul>
				</div>
				<div class="page_pn">
					<ul>
						<c:if test="${not empty list }">
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
	</div>
	<hr/>
	<div id="footer"><jsp:include page="/WEB-INF/views/common/footer.jsp" /></div>
</div>


<div class="writePoint_Pop">
	<div class="point_wrap">
		<div class="pointTitle">글 작성 유의사항</div>
		<div class="pointText"><span class="dot">•</span>욕설, 비난 등 타인에게 불쾌감을 주는 내용</div>
		<div class="pointText"><span class="dot">•</span>음란성/선정성이 포함된 내용    </div>
		<div class="pointText"><span class="dot">•</span>홍보 및 반복적 게시 내용</div>
		<div class="pointText"><span class="dot">•</span>해당 책과 상관 없는 내용</div>
		<div class="pointText"><span class="dot">•</span>저작권상 문제가 되는 내용</div>
		<div class="pointTip">※ 작성 기준을 위반할 경우 글이 삭제될 수 있습니다.</div>
		<div class="pointExit">확 인</div>
	</div>
</div>


<div class="notify_Pop">
	<div class="notify_wrap">
		<div class="notifyTitle">신고하기<img class="notify_close" src="/images/icon_close.png" alt="" /></div>
		<div class="notify_reason">신고사유를 선택해 주세요</div>
		<form>
			<ul class="notify_List">
				<li>
					욕설/인신공격
					<div class="radio_wrap">
						<input type="radio" id="reason1" class="radio_chk" name="radio_chk" value="욕설/인신공격">
						<label for="reason1"><span></span></label>
					</div>
				</li>
				<li>
					영리목적/홍보성
					<div class="radio_wrap">
						<input type="radio" id="reason2" class="radio_chk" name="radio_chk" value="영리목적/홍보성">
						<label for="reason2"><span></span></label>
					</div>
				</li>
				<li>
					음란성/선정성
					<div class="radio_wrap">
						<input type="radio" id="reason3" class="radio_chk" name="radio_chk" value="음란성/선정성">
						<label for="reason3"><span></span></label>
					</div>
				</li>
				<li>
					반복 내용 게시
					<div class="radio_wrap">
						<input type="radio" id="reason4" class="radio_chk" name="radio_chk" value="반복 내용 게시">
						<label for="reason4"><span></span></label>
					</div>
				</li>
				<li>
					저작권 등 법적 문제
					<div class="radio_wrap">
						<input type="radio" id="reason5" class="radio_chk" name="radio_chk" value="저작권 등 법적 문제">
						<label for="reason5"><span></span></label>
					</div>
				</li>
				<li class="notify_etc">
					기타
					<div class="radio_wrap">
						<input type="radio" id="reason6" class="radio_chk" name="radio_chk" value="기타">
						<label for="reason6"><span></span></label>
					</div>
					<textarea class="notifyBody" placeholder="내용을 입력해 주세요" disabled id="content" name="content"></textarea>
				</li>
			</ul>
			<div class="notify_Btn">
				<button type="button" class="notifyCancel">취소</button>
				<button type="submit" class="sendBtn" onClick="javascript:fn_copyright();return false;" >보내기</button>
			</div>
		</form>
	</div>
</div>


<div class="myComment_Pop">
	<div class="myComment_wrap">
		<div class="myAnswer_Title">내 글<img class="myAnswer_close" src="/images/icon_close.png" alt="" /></div>
		<div class="myAnswer_scroll">
			<div class="myAnswer_wrap">
				<c:forEach items="${myDiscussionVO }" var="list">
				<div class="myAnswer_item" id="my_${list.ucd_code }">
					<div class="aText_origin">
						<div class="aTime">${list.ucd_regdate }</div>
						<div class="a_addSetting"><img src="/images/icon_ellipsis.png" alt=""/></div>
						<div class="a_settingBody">
							<!-- <div class="settingExit"><img src="/images/icon_search_delete_bk.png" alt="" /></div> -->
							<div class="settingMenu atModify">수정</div>
							<div class="settingMenu atDelete" onClick="javascript:fn_delete_discussion('${list.ucd_code }','2')">삭제</div>
						</div>
						<div style="clear:both;"></div>
							<div class="aText"><c:out value="${list.ucd_comment}" /></div>
						<div class="AlikeCount">
							<span class="like_default"><img src="/images/icon_favorite_d.png" alt="" /></span>
							<span class="likeCount">${list.like_count }</span>
						</div>
					</div>
					<div class="aText_Act">
						<textarea class="aText_input" id="modify_${list.ucd_code }" maxlength="600" onkeydown="autoResize(this)" onkeyup="autoResize(this)"></textarea>
						<div class="aGuideLine">
							<div class="aNotice">
								<img src="/images/icon_info.png" alt="" />작성 기준을 위반할 경우 글이 삭제될 수 있습니다.
							</div>
							<div class="aRegist">
								<span class="typing_length">0</span> / 600
							</div>
						</div>
						<div class="aBtn">
							<button type="button" class="aCancel">취소</button>
							<button type="button" class="aDone" onClick="javascript:fn_save_modify('${list.ucd_code }','modify')">수정완료</button>
						</div>
					</div>
				</div>
				</c:forEach>
			</div>
		</div>
	</div>
</div>
</body>
</html>
