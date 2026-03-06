package life.bks.zone.util;

public class CommonUtil {
	
	/** 접속 OS 구분 */
	public static String osCheck(String agent) {
		
		// OS 구분
		String os = null;
		
		/** TODO: 20200925 로그인 이력 테이블에서 타 OS가 보이면 추가할 것 */
		if(agent.indexOf("NT 6.0") != -1) os = "Windows Vista/Server 2008";
		else if(agent.indexOf("NT 5.2") != -1) os = "Windows Server 2003";
		else if(agent.indexOf("NT 5.1") != -1) os = "Windows XP";
		else if(agent.indexOf("NT 5.0") != -1) os = "Windows 2000";
		else if(agent.indexOf("NT 10") != -1) os = "Windows 10";
		else if(agent.indexOf("NT 8") != -1) os = "Windows 8";
		else if(agent.indexOf("NT") != -1) os = "Windows NT";
		else if(agent.indexOf("9x 4.90") != -1) os = "Windows Me";
		else if(agent.indexOf("98") != -1) os = "Windows 98";
		else if(agent.indexOf("95") != -1) os = "Windows 95";
		else if(agent.indexOf("Win16") != -1) os = "Windows 3.x";
		else if(agent.indexOf("Windows") != -1) os = "Windows";
		else if(agent.indexOf("Linux") != -1) os = "Linux";
		else if(agent.indexOf("Macintosh") != -1) os = "Macintosh";
		else os = ""; 
		
		return os;
	}

	/** 접속 브라우져 구분 */
	public static String browerCheck(String agent) {
		
		// OS 구분
		String brower = null;
		
		if (agent != null) {
		   if (agent.indexOf("iPhone") > -1) {
		      brower = "iPhone";
		   } else if (agent.indexOf("Android") > -1) {
		      brower = "Android";
		   }else if(agent.indexOf("Mobi") > -1) {
			   brower = "else model";
		   }
		}
		
		return brower;
	}
	
	public static String xssClean(String value) {
	    String returnVal = value;
	    returnVal = returnVal.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	    returnVal = returnVal.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
	    returnVal = returnVal.replaceAll("'", "&#39;");
	    returnVal = returnVal.replaceAll("eval\\((.*)\\)", "");
	    returnVal = returnVal.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
	    return returnVal;
	  }
}
