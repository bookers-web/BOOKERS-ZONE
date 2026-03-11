package life.bks.zone.mapper;

import life.bks.zone.domain.ZoneConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ZoneConfigMapper {

    ZoneConfig selectByUisCode(@Param("uisCode") String uisCode);

    ZoneConfig selectByUisCodeForUpdate(@Param("uisCode") String uisCode);

    List<ZoneConfig> selectAll();

    int insert(ZoneConfig config);

    int update(ZoneConfig config);

    int delete(@Param("uisCode") String uisCode);
}
