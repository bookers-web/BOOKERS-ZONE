package life.bks.zone.util.solr;

import lombok.Getter;
import org.json.simple.JSONArray;

import java.util.List;

@Getter
public class SolrSearchResult {
    private final long numFound;
    private final JSONArray docs;
    private final List<String> idList;

    public SolrSearchResult(long numFound, JSONArray docs, List<String> idList) {
        this.numFound = numFound;
        this.docs = docs;
        this.idList = idList;
    }
}
