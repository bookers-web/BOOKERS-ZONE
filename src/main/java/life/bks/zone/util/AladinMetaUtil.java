package life.bks.zone.util;

/**
 * 알라딘 메타데이터 유틸리티
 */
public class AladinMetaUtil {

    /**
     * 카테고리명에서 마지막 카테고리를 추출합니다.
     * @param categoryName 카테고리명
     * @return 마지막 카테고리명
     */
    public static String extractLastCategory(String categoryName) {
        if (categoryName == null || categoryName.isEmpty()) {
            return null;
        }

        // '>'의 개수 세기
        int delimiterCount = categoryName.length() - categoryName.replace(">", "").length();

        if (delimiterCount >= 1 && delimiterCount <= 3) {
            // 마지막 '>' 이후의 문자열 추출
            int lastIndex = categoryName.lastIndexOf('>');
            if (lastIndex != -1 && lastIndex + 1 < categoryName.length()) {
                return categoryName.substring(lastIndex + 1).trim();
            }
        }

        return null;
    }
}
