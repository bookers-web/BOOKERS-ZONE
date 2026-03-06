package life.bks.zone.util.solr;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.*;

public class SolrUtil {

    public static HttpHeaders solrAuthHeaders() {
        HttpHeaders headers = new HttpHeaders();
        String basicAuth = Base64.getEncoder().encodeToString(("bookers" + ":" + "QnzjtmSolr1!").getBytes(StandardCharsets.UTF_8));
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Basic " + basicAuth);
        headers.setContentType(MediaType.parseMediaType("application/json; charset=UTF-8"));
        return headers;
    }

    public static String prepareSearchKeyword(String keyword) {
        if (keyword == null || keyword.isEmpty())
            return "*";

        String noWhitespace = keyword.replaceAll("\\s+", "");
        String sanitized = noWhitespace.replaceAll("[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]", "");

        if(sanitized.isEmpty())
            return null;

        return "*" + sanitized + "*";
    }

    public static SolrSearchResult parseSolrResponse(String responseBody) throws ParseException {
        JSONParser jsonParser = new JSONParser();
        JSONObject root = (JSONObject) jsonParser.parse(responseBody);
        JSONObject responseObj = (JSONObject) root.get("response");

        long numFound = (long) responseObj.get("numFound");
        JSONArray docs = (JSONArray) responseObj.get("docs");
        List<String> idList = extractList(docs);

        return new SolrSearchResult(numFound, docs, idList);
    }

    public static List<String> extractList(JSONArray docs) {
        List<String> result = new ArrayList<>();
        String field = "id";
        if (docs == null) return result;

        for (Object object : docs) {
            if (!(object instanceof JSONObject)) continue;
            JSONObject doc = (JSONObject) object;

            Object value = doc.get(field);
            if (value != null) {
                result.add(value.toString());
            }
        }

        return result;
    }

    public static String buildSolrURL_v2(String search, String uis_code, String uis_copy_book_flag,
                                      String uis_ucp_code, String uis_return_flag, String uct_code,
                                      String uct_type, String sortField, int pageSize, int pageNum, boolean usePaging, boolean useCategory, String sortFieldLibrary) {
        StringBuilder stringBuilder = new StringBuilder();
        final String BASE_URL = "https://search.bookers.life/solr/bks_core/select";
        stringBuilder.append(BASE_URL).append("?");

        search = prepareSearchKeyword(search);

        if (sortField != null && !sortField.trim().isEmpty() && sortField.equals("publisher")) {
            stringBuilder.append("q=ucm_publisher:").append(search).append("&");
        } else if (sortField != null && !sortField.trim().isEmpty() && sortField.equals("writer")) {
            stringBuilder.append("q=ucm_writer:").append(search).append("&");
        } else if (sortField != null && !sortField.trim().isEmpty() && sortField.equals("title")) {
            stringBuilder.append("q=ucm_title:").append(search).append("&");
        } else if (sortField != null && !sortField.trim().isEmpty() && sortField.equals("all")) {
            stringBuilder.append("q=(")
                    .append("ucm_title:").append(search)
                    .append(" OR ucm_writer:").append(search)
                    .append(" OR ucm_publisher:").append(search)
                    .append(")").append("&");
        } else {
            stringBuilder.append("q=(")
                    .append("ucm_title:").append(search)
                    .append(" OR ucm_writer:").append(search)
                    .append(" OR ucm_publisher:").append(search)
                    .append(")").append("&");
        }

        //ucp_code
        if (uis_ucp_code != null && !uis_ucp_code.trim().isEmpty()) {
            stringBuilder.append("fq=ucm_ucp_code:").append(uis_ucp_code).append("&");
        } else {
            stringBuilder.append("fq=-ucm_ucp_code:").append("UCP0000000425").append("&");
            stringBuilder.append("fq=-ucm_ucp_code:").append("UCP0000000013").append("&");
        }

        //uis_return_flag
        if (uis_return_flag != null && !uis_return_flag.trim().isEmpty() && uis_return_flag.equals("Y")) {
            stringBuilder.append("fq=institutions_included:").append(uis_code).append("&");
        }

        //uct_code 8자리
        if (uct_code != null && !uct_code.trim().isEmpty()) {
            if (uct_code.length() >= 8) {
                stringBuilder.append("fq=ucm_uct_code:").append(uct_code.substring(0,8)).append("&");
            } else {
                stringBuilder.append("fq=ucm_uct_code:").append(uct_code).append("&");
            }
        }

        if (uct_type != null && !uct_type.trim().isEmpty() && uct_type.equals("E")) {
            stringBuilder.append("fq=ucm_file_type:").append("(")
                    .append("EPUB OR PDF")
                    .append(")").append("&");
        } else if (uct_type != null && !uct_type.trim().isEmpty() && uct_type.equals("A")) {
            stringBuilder.append("fq=ucm_file_type:").append("AUDIO").append("&");
        }

        if (uis_copy_book_flag != null && !uis_copy_book_flag.trim().isEmpty() && uis_copy_book_flag.equals("N")) {
            stringBuilder.append("fq=ucm_copy_book_flag:").append(uis_copy_book_flag).append("&");
        }

        stringBuilder.append("fq=-institutions_excluded:").append(uis_code).append("&");
        stringBuilder.append("fq=ucm_svryn:").append("Y").append("&");
        stringBuilder.append("fq=ucm_status:").append("S").append("&");

        // 정렬 추가
        if (sortFieldLibrary != null && !sortFieldLibrary.trim().isEmpty() && sortFieldLibrary.equals("ucm_readbook_count")) {
        	stringBuilder.append("sort=").append("ucm_readbook_count desc").append("&");
        } else if (sortFieldLibrary != null && !sortFieldLibrary.trim().isEmpty() && sortFieldLibrary.equals("ucm_regdate")) {
        	stringBuilder.append("sort=").append("ucm_regdate desc").append("&");
        } else if (sortFieldLibrary != null && !sortFieldLibrary.trim().isEmpty() && sortFieldLibrary.equals("ucm_ebook_pubdate")) {
        	stringBuilder.append("sort=").append("ucm_ebook_pubdate desc").append("&");
        } else {
        	stringBuilder.append("sort=").append("ucm_readbook_count desc").append("&");
        }

        if (usePaging) {
            if (pageNum > 0) {
                stringBuilder.append("start=").append(pageNum).append("&");
            }
            if (pageSize > 0) {
                stringBuilder.append("rows=").append(pageSize).append("&");
            }
        }

        if (useCategory) {
            stringBuilder.append("facet.field=").append("ucm_uct_code").append("&");
            stringBuilder.append("facet.mincount=").append(1).append("&");
            stringBuilder.append("facet=").append(true);
        }

        stringBuilder.append("wt=").append("json");

        return stringBuilder.toString();
    }
}
