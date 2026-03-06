package life.bks.zone.mapper;

import life.bks.zone.domain.IpAuthConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IpAuthConfigMapper {
    List<IpAuthConfig> selectAll();

    List<IpAuthConfig> selectEnabledConfigs();

    IpAuthConfig selectByUisCode(@Param("uisCode") String uisCode);

    IpAuthConfig selectByUisCodeForUpdate(@Param("uisCode") String uisCode);

    IpAuthConfig selectByIpPattern(@Param("ipPattern") String ipPattern);

    int insert(IpAuthConfig config);

    int update(IpAuthConfig config);

    int updateMaxConcurrent(@Param("uisCode") String uisCode, @Param("maxConcurrent") int maxConcurrent);

    int delete(@Param("uisCode") String uisCode);
}
