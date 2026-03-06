import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const responseTime = new Trend('response_time');

export const options = {
  stages: [
    { duration: '10s', target: 10 },
    { duration: '30s', target: 50 },
    { duration: '30s', target: 100 },
    { duration: '10s', target: 0 },
  ],
  thresholds: {
    'http_req_duration': ['p(95)<500'],
    'errors': ['rate<0.1'],
  },
};

const BASE_URL = 'http://localhost:8081';

export default function () {
  const scenarios = [
    () => testIpCheck(),
    () => testSessionValidate(),
    () => testMainPage(),
  ];

  const scenario = scenarios[Math.floor(Math.random() * scenarios.length)];
  scenario();
  
  sleep(0.5);
}

function testIpCheck() {
  const res = http.get(`${BASE_URL}/api/ip-auth/check`);
  
  const passed = check(res, {
    'ip-check status 200': (r) => r.status === 200,
    'ip-check has data': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.success === true;
      } catch (e) {
        return false;
      }
    },
  });

  errorRate.add(!passed);
  responseTime.add(res.timings.duration);
}

function testSessionValidate() {
  const res = http.get(`${BASE_URL}/api/ip-auth/session/validate`);
  
  const passed = check(res, {
    'validate status 200': (r) => r.status === 200,
  });

  errorRate.add(!passed);
  responseTime.add(res.timings.duration);
}

function testMainPage() {
  const res = http.get(`${BASE_URL}/zone/main`);
  
  const passed = check(res, {
    'main page status 200': (r) => r.status === 200,
  });

  errorRate.add(!passed);
  responseTime.add(res.timings.duration);
}

export function handleSummary(data) {
  return {
    'stdout': textSummary(data),
    'load-test-result.json': JSON.stringify(data, null, 2),
  };
}

function textSummary(data) {
  const duration = data.metrics.http_req_duration;
  const reqs = data.metrics.http_reqs;
  
  return `
========== LOAD TEST SUMMARY ==========
Total Requests: ${reqs ? reqs.values.count : 0}
Request Rate: ${reqs ? (reqs.values.rate).toFixed(2) : 0} req/s

Response Time:
  - Avg: ${duration ? duration.values.avg.toFixed(2) : 0}ms
  - p95: ${duration ? duration.values['p(95)'].toFixed(2) : 0}ms
  - Max: ${duration ? duration.values.max.toFixed(2) : 0}ms

Error Rate: ${data.metrics.errors ? (data.metrics.errors.values.rate * 100).toFixed(2) : 0}%
========================================
`;
}
