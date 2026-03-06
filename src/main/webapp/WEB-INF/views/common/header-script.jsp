<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/gtmhead.jsp" %>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="-1"/>
<meta name="viewport" content="width=1280, user-scalable=yes" /> 
<meta name="format-detection" content="telephone=no, address=no, email=no">
<meta name="HandleHeldFriendly" content="true">
<meta name="MobileOptimized" content="1280">

<c:choose>
<c:when test="${sessionScope.UM_UIS_CODE eq 'UIS0000000326'}">
<title>부산광역시 전자도서관(구독)</title>
</c:when>
<c:otherwise>
<title>부커스 - B2B구독형 전자책부터 독서교육플랫폼까지!</title>
</c:otherwise>
</c:choose>
<meta name="description" content="국내 유일의 B2B 독서교육 전문 플랫폼. 이제부터 B2B 고객들은 부커스를 통해 전자책 및 오디오북 구독 서비스를 만나보실 수 있습니다.">
<meta name="keywords" content="전자책, 오디오북, 이북, 구독">
<link rel="stylesheet" href="/css/bootstrap.css">
<script src="/js/jquery.min.js"></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/js/bootstrap.js"></script>
<link rel="stylesheet" href="/css/swiper.css">
<script src="/js/swiper.js"></script>
<script src="/js/jquery.als-2.1.js"></script>
<script src="/js/printThis.js"></script>
<script src="/js/index.js"></script>
<link rel="stylesheet" href="/css/medium-editor.min.css">
<link rel="stylesheet" href="/css/themes/default.min.css">
<script src="/js/medium-editor.min.js"></script>
<script type="text/javascript">
//검색
$(document).ready(function() {
	var sessionUisCode = '<%=session.getAttribute("UM_UIS_CODE") %>';
	var url = window.location.href;
	if (url.includes("chongmu") || sessionUisCode == "UIS0000000437") {
		document.title = "총무닷컴 ebook 서비스";
		var linkElement = $('<link rel="icon" href="data:,">');
		$('head').append(linkElement);
		$('meta[name="description"]').attr('content','국내 유일의 B2B 독서교육 전문 플랫폼.');
	}
});
function fn_go_search_page(){
	var str = $('#searchName').val().trim(); // trim() 메서드를 사용하여 문자열 양 끝의 공백 제거
    var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

	if(str == ''){
		alert('검색어를 입력해 주세요.');
		return false;
	}else{
		if(regExp.test(str)){
			 var t = str.replace(regExp, "").trim(); // trim() 메서드를 사용하여 특수문자만으로 이루어진 문자열 제거 후 다시 trim
			if(t == ''){
				alert('특수문자만으로는 검색을 할 수 없습니다.');
				return false;
			}else{
				document.getElementById('searchForm').submit();
			}			
		}else{
			document.getElementById('searchForm').submit();
		}
	}
}
</script>
<c:choose>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq 'F23E4F' }">
		<link rel="stylesheet" href="/css/index-red.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq 'C2845E' }">
		<link rel="stylesheet" href="/css/index-brown.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq '2D80D3' }">
		<link rel="stylesheet" href="/css/index-blue.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq '18B542' }">
		<link rel="stylesheet" href="/css/index-green.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq '875FD3' }">
		<link rel="stylesheet" href="/css/index-purple.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:when test="${sessionScope.UIS_KEYCOLOR eq 'FCBE07' }">
		<link rel="stylesheet" href="/css/index-yellow.css?v=<%= System.currentTimeMillis() %>">	
	</c:when>
	<c:otherwise>
		<link rel="stylesheet" href="/css/index.css?v=<%= System.currentTimeMillis() %>">
	</c:otherwise>
</c:choose>
