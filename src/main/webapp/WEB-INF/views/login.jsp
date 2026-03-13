<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>부커스 존 - 로그인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css">
</head>
<body class="login-page">
  <header class="header">
    <h1 class="logo">
      <img src="${pageContext.request.contextPath}/resources/images/v2/common/logo.svg" alt="bookers">
    </h1>
  </header>

  <main class="main">
    <div class="background-overlay"></div>
    
    <div class="card">
      <div class="card-content">
        <h2 class="title">매일 새로운 독서가 시작되는 곳<br><strong>부커스 존에 오신걸 환영합니다.</strong></h2>
        
        <div class="login-options">
          <a href="${pageContext.request.contextPath}/zone/enter" class="login-btn login-btn--guest">
            <svg class="login-btn__icon" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M25.0339 24.9979C30.7868 24.9979 35.4505 20.3342 35.4505 14.5812C35.4505 8.82825 30.7868 4.16455 25.0339 4.16455C19.2809 4.16455 14.6172 8.82825 14.6172 14.5812C14.6172 20.3342 19.2809 24.9979 25.0339 24.9979Z" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M42.8581 45.8333C42.8581 37.7708 34.8372 31.25 24.9622 31.25C15.0872 31.25 7.06641 37.7708 7.06641 45.8333" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="login-btn__text">
              <span class="login-btn__title">비회원 관내 이용자</span>
              <span class="login-btn__subtitle">바로 이용하기</span>
            </span>
          </a>
          
          <a href="https://www.bookers.life/login.do" class="login-btn login-btn--member">
            <svg class="login-btn__icon" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M25.0339 24.9979C30.7868 24.9979 35.4505 20.3342 35.4505 14.5812C35.4505 8.82825 30.7868 4.16455 25.0339 4.16455C19.2809 4.16455 14.6172 8.82825 14.6172 14.5812C14.6172 20.3342 19.2809 24.9979 25.0339 24.9979Z" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M7.06641 45.8333C7.06641 37.7708 15.0872 31.25 24.9622 31.25C26.9622 31.25 28.8998 31.5208 30.7123 32.0208" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M45.7995 37.4979C45.7995 39.0604 45.362 40.5395 44.5912 41.7895C44.1537 42.5395 43.5912 43.2062 42.9453 43.7479C41.487 45.0604 39.5703 45.8312 37.4661 45.8312C34.4245 45.8312 31.7786 44.2062 30.3411 41.7895C29.5703 40.5395 29.1328 39.0604 29.1328 37.4979C29.1328 34.8729 30.3411 32.5187 32.2578 30.9979C33.6953 29.8521 35.5078 29.1646 37.4661 29.1646C42.0703 29.1646 45.7995 32.8937 45.7995 37.4979Z" stroke="currentColor" stroke-width="3" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M34.2148 37.5001L36.2773 39.5626L40.7148 35.4585" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="login-btn__text">
              <span class="login-btn__title">회원 서비스</span>
              <span class="login-btn__subtitle">로그인 후 이용하기</span>
            </span>
          </a>
        </div>
        
        <ul class="notes">
          <li>관내 이용은 로그인 없이 도서 열람이 가능합니다.</li>
          <li>관내 서비스는 원활한 이용을 위해 동시 접속을 <span class="highlight">${maxConcurrent}명</span>으로 제한하고 있습니다.</li>
          <li>이용 인원 초과 시 접속이 제한될 수 있으니, 잠시 후 다시 시도해 주세요.</li>
        </ul>
      </div>
    </div>
  </main>

  <footer class="footer">
    <p>&copy; 2025. <strong>bookers</strong> Co., Ltd All Rights Reserved.</p>
  </footer>

  <!-- 동시접속 초과 모달 -->
  <div id="maxConcurrentModal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
      <button class="modal-close" onclick="closeModal()" aria-label="닫기">&times;</button>
      <svg class="modal-illustration" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
        <circle cx="60" cy="60" r="56" fill="#FFF3E0"/>
        <circle cx="60" cy="52" r="24" fill="#FFE0B2"/>
        <circle cx="52" cy="48" r="3" fill="#333"/>
        <circle cx="68" cy="48" r="3" fill="#333"/>
        <path d="M54 58 Q60 62 66 58" stroke="#333" stroke-width="2" stroke-linecap="round" fill="none"/>
        <rect x="46" y="78" width="28" height="32" rx="4" fill="#EF5350"/>
        <rect x="50" y="84" width="20" height="4" rx="1" fill="#fff"/>
        <rect x="50" y="92" width="20" height="4" rx="1" fill="#fff"/>
      </svg>
      <p class="modal-title">이용 인원 초과</p>
      <p class="modal-message">현재 동시 이용자 수가 많아<br>접속이 어렵습니다.<br>잠시 후 다시 시도해 주세요.</p>
      <button class="modal-btn" onclick="closeModal()">확인</button>
    </div>
  </div>


  <script>
    function closeModal() {
      document.getElementById('maxConcurrentModal').style.display = 'none';
    }
    (function() {
      var params = new URLSearchParams(window.location.search);
      if (params.get('error') === 'max_concurrent') {
        document.getElementById('maxConcurrentModal').style.display = 'flex';
        history.replaceState(null, '', window.location.pathname);
      }
    })();
  </script>
</body>
</html>
