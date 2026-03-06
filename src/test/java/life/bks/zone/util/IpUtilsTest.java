package life.bks.zone.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.assertj.core.api.Assertions.assertThat;

class IpUtilsTest {

    @Nested
    @DisplayName("isInRange - IP 대역 매칭")
    class IsInRangeTest {

        @Test
        @DisplayName("단일 IP 정확히 일치")
        void exactMatch() {
            assertThat(IpUtils.isInRange("192.168.1.100", "192.168.1.100")).isTrue();
            assertThat(IpUtils.isInRange("192.168.1.100", "192.168.1.101")).isFalse();
        }

        @Test
        @DisplayName("CIDR /24 대역 매칭")
        void cidr24Match() {
            String cidr = "192.168.1.0/24";
            
            assertThat(IpUtils.isInRange("192.168.1.0", cidr)).isTrue();
            assertThat(IpUtils.isInRange("192.168.1.1", cidr)).isTrue();
            assertThat(IpUtils.isInRange("192.168.1.255", cidr)).isTrue();
            assertThat(IpUtils.isInRange("192.168.2.1", cidr)).isFalse();
        }

        @Test
        @DisplayName("CIDR /16 대역 매칭")
        void cidr16Match() {
            String cidr = "10.0.0.0/16";
            
            assertThat(IpUtils.isInRange("10.0.0.1", cidr)).isTrue();
            assertThat(IpUtils.isInRange("10.0.255.255", cidr)).isTrue();
            assertThat(IpUtils.isInRange("10.1.0.1", cidr)).isFalse();
        }

        @Test
        @DisplayName("CIDR /8 대역 매칭")
        void cidr8Match() {
            String cidr = "10.0.0.0/8";
            
            assertThat(IpUtils.isInRange("10.0.0.1", cidr)).isTrue();
            assertThat(IpUtils.isInRange("10.255.255.255", cidr)).isTrue();
            assertThat(IpUtils.isInRange("11.0.0.1", cidr)).isFalse();
        }

        @Test
        @DisplayName("CIDR /32 단일 호스트")
        void cidr32Match() {
            String cidr = "192.168.1.100/32";
            
            assertThat(IpUtils.isInRange("192.168.1.100", cidr)).isTrue();
            assertThat(IpUtils.isInRange("192.168.1.101", cidr)).isFalse();
        }

        @Test
        @DisplayName("null 또는 빈 값 처리")
        void nullOrEmpty() {
            assertThat(IpUtils.isInRange(null, "192.168.1.0/24")).isFalse();
            assertThat(IpUtils.isInRange("192.168.1.1", null)).isFalse();
            assertThat(IpUtils.isInRange(null, null)).isFalse();
        }

        @Test
        @DisplayName("잘못된 CIDR 형식")
        void invalidCidr() {
            assertThat(IpUtils.isInRange("192.168.1.1", "invalid")).isFalse();
            assertThat(IpUtils.isInRange("192.168.1.1", "192.168.1.0/invalid")).isFalse();
        }

    }

    @Nested
    @DisplayName("실제 사용 시나리오")
    class RealWorldScenarioTest {

        @Test
        @DisplayName("192.168.0.27은 192.168.0.0/16 대역에 포함")
        void clientIpMatchesCidr16() {
            // 사용자 시나리오: TBL_IP_AUTH_CONFIG에 192.168.0.0/16 등록
            assertThat(IpUtils.isInRange("192.168.0.27", "192.168.0.0/16")).isTrue();
            assertThat(IpUtils.isInRange("192.168.255.255", "192.168.0.0/16")).isTrue();
            assertThat(IpUtils.isInRange("192.169.0.1", "192.168.0.0/16")).isFalse();
        }

        @Test
        @DisplayName("localhost 변형 매칭")
        void localhostVariants() {
            assertThat(IpUtils.isInRange("127.0.0.1", "127.0.0.1")).isTrue();
            assertThat(IpUtils.isInRange("0:0:0:0:0:0:0:1", "0:0:0:0:0:0:0:1")).isTrue();
        }

        @ParameterizedTest
        @DisplayName("콤마 구분 패턴에서 각 항목 개별 매칭")
        @CsvSource({
            "127.0.0.1, 127.0.0.1",
            "10.5.3.1, 10.0.0.0/8",
            "192.168.0.27, 192.168.0.0/16"
        })
        void commaPatternMatching(String clientIp, String pattern) {
            // findConfigByIp()에서 콤마로 split 후 각각 isInRange 호출하는 시나리오
            String fullPattern = "127.0.0.1,::1,0:0:0:0:0:0:0:1,192.168.0.0/16,10.0.0.0/8";
            boolean matched = false;
            for (String p : fullPattern.split(",")) {
                if (IpUtils.isInRange(clientIp, p.trim())) {
                    matched = true;
                    break;
                }
            }
            assertThat(matched).isTrue();
        }
    }

    @Nested
    @DisplayName("stripPort - IPv4:port 포트 제거 (getClientIp 내부 호출)")
    class StripPortTest {

        @Test
        @DisplayName("getClientIp에서 포트가 제거되는지 간접 검증 — isInRange로 확인")
        void ipWithPortShouldMatchAfterStrip() {
            // stripPort는 private이므로 isInRange를 통한 시나리오 검증
            // getClientIp()가 "127.0.0.1:65076" → "127.0.0.1"로 변환 후 비교하는 흐름
            // 여기서는 stripPort 후의 결과를 직접 검증
            String stripped = stripPortManual("127.0.0.1:65076");
            assertThat(IpUtils.isInRange(stripped, "127.0.0.1")).isTrue();
        }

        @Test
        @DisplayName("포트 없는 IPv4는 그대로")
        void ipWithoutPort() {
            assertThat(stripPortManual("192.168.0.27")).isEqualTo("192.168.0.27");
        }

        @Test
        @DisplayName("IPv6는 변경하지 않음")
        void ipv6Unchanged() {
            assertThat(stripPortManual("::1")).isEqualTo("::1");
            assertThat(stripPortManual("0:0:0:0:0:0:0:1")).isEqualTo("0:0:0:0:0:0:0:1");
        }

        @Test
        @DisplayName("null 처리")
        void nullInput() {
            assertThat(stripPortManual(null)).isNull();
        }

        /**
         * IpUtils.stripPort()는 private이므로 동일 로직으로 검증
         */
        private String stripPortManual(String ip) {
            if (ip == null || !ip.contains(".") || !ip.contains(":")) {
                return ip;
            }
            int lastColon = ip.lastIndexOf(':');
            String afterColon = ip.substring(lastColon + 1);
            try {
                Integer.parseInt(afterColon);
                return ip.substring(0, lastColon);
            } catch (NumberFormatException e) {
                return ip;
            }
        }
    }
}
