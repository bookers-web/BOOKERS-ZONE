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
        
        if (!ipPattern.contains("/")) {
            return clientIp.equals(ipPattern);
        }
        
        return isInCidrRange(clientIp, ipPattern);
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
