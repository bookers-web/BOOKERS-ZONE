package life.bks.zone.util;

import jakarta.servlet.http.HttpServletRequest;
import java.net.InetAddress;
import java.net.UnknownHostException;

public class IpUtils {
    
    private IpUtils() {}
    
    public static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        
        if (isEmptyOrUnknown(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (isEmptyOrUnknown(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (isEmptyOrUnknown(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (isEmptyOrUnknown(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (isEmptyOrUnknown(ip)) {
            ip = request.getRemoteAddr();
        }
        
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        ip = stripPort(ip);

        return ip;
    }
    
    public static boolean isInRange(String clientIp, String ipPattern) {
        if (clientIp == null || ipPattern == null) {
            return false;
        }

        ipPattern = ipPattern.trim();
        clientIp = clientIp.trim();

        // IP 범위 (start~end) 형식: 198.0.0.1~198.0.1.199
        if (ipPattern.contains("~")) {
            return isInIpRange(clientIp, ipPattern);
        }

        // CIDR 형식: 192.168.0.0/16
        if (ipPattern.contains("/")) {
            return isInCidrRange(clientIp, ipPattern);
        }

        // 단일 IP 정확 매칭
        return clientIp.equals(ipPattern);
    }
    
    private static boolean isInCidrRange(String ip, String cidr) {
        try {
            String[] parts = cidr.split("/");
            String networkAddress = parts[0];
            int prefixLength = Integer.parseInt(parts[1]);
            
            InetAddress clientAddr = InetAddress.getByName(ip);
            InetAddress networkAddr = InetAddress.getByName(networkAddress);
            
            byte[] clientBytes = clientAddr.getAddress();
            byte[] networkBytes = networkAddr.getAddress();
            
            if (clientBytes.length != networkBytes.length) {
                return false;
            }
            
            int fullBytes = prefixLength / 8;
            int remainingBits = prefixLength % 8;
            
            for (int i = 0; i < fullBytes; i++) {
                if (clientBytes[i] != networkBytes[i]) {
                    return false;
                }
            }
            
            if (remainingBits > 0 && fullBytes < clientBytes.length) {
                int mask = 0xFF << (8 - remainingBits);
                if ((clientBytes[fullBytes] & mask) != (networkBytes[fullBytes] & mask)) {
                    return false;
                }
            }
            
            return true;
        } catch (UnknownHostException | NumberFormatException e) {
            return false;
        }
    }

    /**
     * IP 범위(start~end) 매칭. IPv4 주소를 long으로 변환하여 숫자 범위 비교.
     * 예: "198.0.0.1~198.0.1.199" → 198.0.0.1 <= clientIp <= 198.0.1.199
     */
    private static boolean isInIpRange(String clientIp, String rangePattern) {
        try {
            String[] parts = rangePattern.split("~");
            if (parts.length != 2 || parts[0].trim().isEmpty() || parts[1].trim().isEmpty()) {
                return false;
            }

            long target = ipv4ToLong(clientIp);
            long start = ipv4ToLong(parts[0].trim());
            long end = ipv4ToLong(parts[1].trim());

            return target >= start && target <= end;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * IPv4 주소를 unsigned long 값으로 변환한다.
     * 예: "192.168.1.100" → 3232235876L
     */
    private static long ipv4ToLong(String ipAddress) {
        try {
            byte[] octets = InetAddress.getByName(ipAddress.trim()).getAddress();
            if (octets.length != 4) {
                throw new IllegalArgumentException("IPv4 only: " + ipAddress);
            }
            long result = 0;
            for (byte octet : octets) {
                result = (result << 8) | (octet & 0xFF);
            }
            return result;
        } catch (UnknownHostException e) {
            throw new IllegalArgumentException("Invalid IP: " + ipAddress, e);
        }
    }
    
    private static boolean isEmptyOrUnknown(String value) {
        return value == null || value.isEmpty() || "unknown".equalsIgnoreCase(value);
    }

    /**
     * IPv4:port 형식에서 포트를 제거한다. (예: "127.0.0.1:65076" → "127.0.0.1")
     * IPv6 주소("::1", "fe80::1" 등)는 변경하지 않는다.
     */
    private static String stripPort(String ip) {
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
    
    public static String getUserAgent(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        return userAgent != null ? userAgent : "UNKNOWN";
    }
}
