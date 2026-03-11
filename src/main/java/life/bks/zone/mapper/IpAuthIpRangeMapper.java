package life.bks.zone.mapper;

import life.bks.zone.domain.IpAuthIpRange;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IpAuthIpRangeMapper {

    List<IpAuthIpRange> selectEnabledRanges();

    List<IpAuthIpRange> selectByUisCode(@Param("uisCode") String uisCode);

    int insert(IpAuthIpRange range);

    int update(IpAuthIpRange range);

    int deleteByUisCode(@Param("uisCode") String uisCode);
}