<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>부커스 존</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: #fff;
    }
    .container {
      text-align: center;
      padding: 2rem;
    }
    h1 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }
    p {
      font-size: 1.2rem;
      opacity: 0.9;
      margin-bottom: 2rem;
    }
    .status {
      background: rgba(255,255,255,0.1);
      padding: 1.5rem 2rem;
      border-radius: 12px;
      backdrop-filter: blur(10px);
    }
    .status-item {
      display: flex;
      justify-content: space-between;
      padding: 0.5rem 0;
      border-bottom: 1px solid rgba(255,255,255,0.2);
    }
    .status-item:last-child { border-bottom: none; }
  </style>
</head>
<body>
  <div class="container">
    <h1>부커스 존</h1>
    <p>전자도서관 서비스에 오신 것을 환영합니다.</p>
    
    <div class="status">
      <div class="status-item">
        <span>기관명</span>
        <span>${uisName != null ? uisName : '테스트'}</span>
      </div>
      <div class="status-item">
        <span>기관코드</span>
        <span>${uisCode != null ? uisCode : '-'}</span>
      </div>
      <div class="status-item">
        <span>접속 상태</span>
        <span>정상</span>
      </div>
    </div>
  </div>
</body>
</html>
