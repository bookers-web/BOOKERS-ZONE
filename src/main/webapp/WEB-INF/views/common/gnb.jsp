<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(document).ready(function() {
	var path = "<%= request.getServletPath() %>";
	var middlePath = path.split('/');

	if (middlePath[3] == 'home') {
		$('#a_home').addClass('nav_focus');
		$('#a_lounge').removeClass('nav_focus');
	} else if (middlePath[3] == 'lr') {
		$('#a_lounge').addClass('nav_focus');
		$('#a_home').removeClass('nav_focus');
	}
});

</script>
<!-- 비회원 관내 이용자 전용 - 비밀번호 변경 리다이렉트 비활성화 -->
<nav id="gnb">
	<ul class="gnb_list">
		<li>
			<a href="/front/home/main.do" id = "a_home">홈</a>
		</li>
		<li>
			<a href="/front/lounge/main.do" id = "a_lounge">독서라운지</a>
		</li>
	</ul>
</nav>
