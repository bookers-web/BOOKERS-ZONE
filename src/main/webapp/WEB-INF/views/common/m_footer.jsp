<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="m_footer"><!--하단-->
		<img src="/images/mobile/logo_footer.svg" alt="bookers logo">
		<div class="foot_buttonArea" style="">
			<button class="version_pc" onclick="fn_go_pc();"><span class="foot_buttonTxt">PC버전</span></button>
		</div>
		<p class="footer_infoArea">
			<b class="foot_tel">대표 전화 : 02 - 2038 - 2696</b><br>
			Copyright bookers. All right reserved.
		</p>
</footer>
<script type="text/javascript">
var oldAction = $("#frm").attr("action")
function fn_go_pc() {
	var frm = $("#frm");
	
	
	frm.append('<input type="hidden" id="searchMobileYn" name="searchMobileYn" value="N">');
	
	$("#frm").attr("action","/front/home/main.do");
	frm.submit();
}
</script>