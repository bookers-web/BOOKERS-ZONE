package life.bks.zone.mapper;

import life.bks.zone.domain.IpAuthLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface IpAuthLogMapper {
    int insert(IpAuthLog log);

    List<IpAuthLog> selectBySessionId(@Param("sessionId") String sessionId);

    List<IpAuthLog> selectByUisCode(@Param("uisCode") String uisCode,
                                     @Param("startDate") LocalDateTime startDate,
                                     @Param("endDate") LocalDateTime endDate);

    int deleteOldLogs(@Param("threshold") LocalDateTime threshold);
}
