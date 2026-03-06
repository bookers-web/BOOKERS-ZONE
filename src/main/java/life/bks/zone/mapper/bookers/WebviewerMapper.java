package life.bks.zone.mapper.bookers;

import life.bks.zone.domain.WebviewerBook;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.HashMap;

@Mapper
public interface WebviewerMapper {
    WebviewerBook selectBookDetail(@Param("ucmCode") String ucmCode);

    int countMemberLibrary(@Param("umCode") String umCode);

    WebviewerBook selectMemberLibrary(@Param("umCode") String umCode);

    int countMemberLibraryBook(@Param("umlCode") String umlCode, @Param("ucmCode") String ucmCode);

    WebviewerBook selectMemberLibraryBook(@Param("umCode") String umCode, @Param("ucmCode") String ucmCode);

    int insertLibrary(WebviewerBook book);

    int insertLibraryBook(WebviewerBook book);

    int insertOnlyLibraryBook(WebviewerBook book);

    int updateLibraryBookStatus(WebviewerBook book);

    int updateReadCount(@Param("ucmCode") String ucmCode);

    void getSequence(WebviewerBook book);

    HashMap<String, Object> callGetLicense(HashMap<String, Object> param);
}
