import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter, Trend } from 'k6/metrics';

const successCounter = new Counter('session_success');
const failCounter = new Counter('session_fail');
const responseTime = new Trend('response_time');

export const options = {
  scenarios: {
    concurrent_session_test: {
      executor: 'shared-iterations',
      vus: 15,
      iterations: 15,
      maxDuration: '30s',
    },
  },
  thresholds: {
    'session_success': ['count==10'],
    'session_fail': ['count==5'],
  },
};

const BASE_URL = 'http://localhost:8081';

export function setup() {
  const clearRes = http.del(`${BASE_URL}/api/ip-auth/session/all`);
  console.log('Cleared all sessions before test');
  sleep(1);
}

export default function () {
  const uniqueIp = `10.0.0.${__VU}`;
  
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'X-Forwarded-For': uniqueIp,
    },
  };

  const payload = JSON.stringify({
    uisCode: 'UIS0000000013',
  });

  const startTime = Date.now();
  const res = http.post(`${BASE_URL}/api/ip-auth/session`, payload, params);
  responseTime.add(Date.now() - startTime);

  let success = false;
  try {
    const body = JSON.parse(res.body);
    success = body.success && body.data && body.data.success === true;
  } catch (e) {
    console.log(`VU ${__VU}: Parse error - ${e.message}`);
  }

  if (success) {
    successCounter.add(1);
    console.log(`VU ${__VU} [${uniqueIp}]: Session CREATED`);
  } else {
    failCounter.add(1);
    console.log(`VU ${__VU} [${uniqueIp}]: Session REJECTED (limit exceeded)`);
  }

  sleep(0.5);
}

export function handleSummary(data) {
  const success = data.metrics.session_success ? data.metrics.session_success.values.count : 0;
  const fail = data.metrics.session_fail ? data.metrics.session_fail.values.count : 0;
  
  const passed = success === 10 && fail === 5;
  
  const summary = `
========== CONCURRENT LIMIT TEST ==========
Session Success: ${success} (expected: 10)
Session Fail: ${fail} (expected: 5)
MAX_CONCURRENT: 10

Result: ${passed ? 'PASS - Concurrent limit working correctly!' : 'FAIL - Check concurrent limit logic'}
============================================
`;

  console.log(summary);
  
  return {
    'stdout': summary,
  };
}
