package life.bks.zone.util;

import java.math.BigDecimal;

public final class JSTLUtil {

	private JSTLUtil() {}
	
	private static final long K = 1024;
	private static final long M = K * K;
	private static final long G = M * K;
	private static final long T = G * K;

	public static String fileSizeToReadable(int data){
		final long value = data;
	    final long[] dividers = new long[] { T, G, M, K, 1 };
	    final String[] units = new String[] { "TB", "GB", "MB", "KB", "B" };
	    if(value < 1)
	        throw new IllegalArgumentException("Invalid file size: " + value);
	    String result = null;
	    for(int i = 0; i < dividers.length; i++){
	        final long divider = dividers[i];
	        if(value >= divider){
	            result = format(value, divider, units[i]);
	            break;
	        }
	    }
	    return result;
	}

	private static String format(final long value,
	    final long divider,
	    final String unit){
	    final double result =
	        divider > 1 ? (double) value / (double) divider : (double) value;
	    return String.format("%.1f %s", Double.valueOf(result), unit);
	}
	
	public static String FormatTextCount(long count) {
		String strTextCount;
		
		BigDecimal textCount = new BigDecimal(count);

        if (textCount.longValue() >= 100000000) {
        	
        	BigDecimal size =  textCount.divide(new BigDecimal(100000000));
        	strTextCount = String.format("%,.1f억", size.floatValue());
        }
        else if (count >= 10000000) {
        	BigDecimal size = textCount.divide(new BigDecimal(10000000));
            strTextCount = String.format("%,.1f천만", size.floatValue());
        }
        else if (count >= 1000000) {
        	BigDecimal size = textCount.divide(new BigDecimal(1000000));
            strTextCount = String.format("%,.1f백만", size.floatValue());
        }
        else if (count >= 100000) {
        	BigDecimal size = textCount.divide(new BigDecimal(100000));
            strTextCount = String.format("%,.1f십만", size.floatValue());
        }
        else if (count >= 10000) {
        	BigDecimal size = textCount.divide(new BigDecimal(10000));
            strTextCount = String.format("%,.1f만", size.floatValue());
        }
        else if (count > 0  && count < 10000) {
        	BigDecimal size = new BigDecimal(count);
            strTextCount = String.format("%,d", size.intValue());
        }
        else
        {
        	strTextCount = "0 자";
        }
        return strTextCount;
    }
	
	public static String toHtml(String data) {
		String strTextCount;
		
		strTextCount = data.replaceAll("(\r\n|\n)", "<br/>");
		
        return strTextCount;
    }
	
	public static String fromHtml(String data) {
		String strTextCount;
		
		strTextCount = data.replaceAll("<br/>", "\r\n");
		
        return strTextCount;
    }
}
