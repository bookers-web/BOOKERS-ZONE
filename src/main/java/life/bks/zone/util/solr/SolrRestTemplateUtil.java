package life.bks.zone.util.solr;

import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

public class SolrRestTemplateUtil {

    public static RestTemplate create(int connectTimeoutMillis, int readTimeoutMillis) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(connectTimeoutMillis);
        factory.setReadTimeout(readTimeoutMillis);
        return new RestTemplate(factory);
    }

    public static RestTemplate defaultTemplate() {
        return create(3000, 5000);
    }
}
