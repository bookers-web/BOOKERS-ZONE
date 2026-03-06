<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:choose>
<c:when test="${sessionScope.UM_UIS_CODE eq 'UIS0000000487'}">
</c:when>
<c:otherwise>
<div class="footerTop">
	<a href="/front/home/companyInfo.do" target="_blank">회사 소개</a>
	<a href="/front/home/tosInfo.do">이용약관</a>
</div>
</c:otherwise>
</c:choose>
<hr/>
<c:choose>
<c:when test="${sessionScope.UM_UIS_CODE eq 'UIS0000000487'}">
<div class="footerContent">
	<div class="footerLogo">
		<img src="/images/fox-logo.svg" alt="" style="width:120px;"/>
	</div>
	<div class="footerInfo">
      <div class="f-con">
        <p></p>
      </div>
      <div class="f-con">
        <p>㈜폭스에듀</p>
        <p>[본사](06253)서울특별시 강남구 도곡로1길 23</br>(역삼동), 3층</p>
      </div>
      <div class="f-con">
       <p></p>
      </div>
    </div>
    <div class="footerContact">
      <div class="f-con">
        <p>대표자 : 이종탁</p>
        <p>사업자등록번호 : 697-88-02547</p>
        <p>사업문의 E-MAIL : library@foxedu.kr</p>
      </div>
    </div>
</div>
</c:when>
<c:otherwise>
<div class="footerContent">
	<div class="footerLogo">
		<img src="/images/bookers_logo_s.png" alt="" />
	</div>
	<div class="footerInfo">
      <div class="f-con">
        <p>사업자등록번호 : 458-88-01884</p>
      </div>
      <div class="f-con">
        <p>본사 : (61475) 광주광역시 동구 금남로 245, 7층 717호(금남로1가, 전일빌딩)</p>
        <p>경남지사 : (51013) 경상남도 김해시 관동로 14 경남콘텐츠기업지원센터 2층</p>
        <p>기업부설연구소 : (04081) 서울 마포구 토정로 112(상수동 351-16) 8층</p>
      </div>
      <div class="f-con">
        <p>Copyright © bookers. All Rights Reserved.</p>
      </div>
    </div>
    <div class="footerContact">
      <div class="f-con">
        <p>콘텐츠 제휴/공급문의 E-MAIL : contents@bookers.life</p>
        <p>B2B 제휴/도입 문의 E-MAIL : b2b@bookers.life</p>
        <p>대표전화 : 02-2038-2696</p>
      </div>
    </div>
</div>
</c:otherwise>
</c:choose>

<hr/>

<script>

  $(function () {

    /* 260224 : 북커버 이미지 비율 체크(특정 비율 넘어선 경우 type-vh로 class 분기) */

    // 북커버 기준 사이즈
    const BASE_W = 145;
    const BASE_H = 220;
    const BASE_RATIO = BASE_H / BASE_W; // 1.571

    $('.bookBG img.cover').each(function () {

      const $img = $(this);

      function checkRatio() {

        const w = this.naturalWidth;
        const h = this.naturalHeight;

        if (!w || !h) return;

        const ratio = h / w;

        if (ratio > BASE_RATIO) {
          $img.closest('.bookBG').addClass('type-vh');
        }

      }

      if (this.complete) {
        checkRatio.call(this);
      } else {
        $img.on('load', checkRatio);
      }

    });

  });

</script>

<script type="text/javascript">

$(document).ready(function() {
	var footTop = $(".footerContent");
	console.log(fn_isMobile());
	if (fn_isMobile()) {
		footTop.append('<div class="footer_mobileBtn"><button class="version_mobile" type="button" onclick="fn_go_mobile();">모바일 버전</button></div>');
	}
});
function fn_isMobile(){
	var UserAgent = navigator.userAgent;

	if (UserAgent.match(/iPhone|iPad|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null)
	{
		return true;
	}else{
		return false;
	}

}

var oldAction = $("#frm").attr("action");
function fn_go_mobile() {
	var frm = $("#frm");
	
	
	frm.append('<input type="hidden" id="searchMobileYn" name="searchMobileYn" value="Y">');
	$("#frm").attr("action","/front/mobile/main.do");
	frm.submit();
}

</script>
