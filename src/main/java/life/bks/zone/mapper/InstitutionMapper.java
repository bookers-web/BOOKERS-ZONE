package life.bks.zone.mapper;

import life.bks.zone.domain.InstitutionInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface InstitutionMapper {

    InstitutionInfo selectByUisCode(@Param("uisCode") String uisCode);
}
