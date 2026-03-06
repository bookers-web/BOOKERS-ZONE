package life.bks.zone.mapper;

import life.bks.zone.domain.IpAuthSession;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface IpAuthSessionMapper {
    IpAuthSession selectById(@Param("sessionId") String sessionId);

    List<IpAuthSession> selectByUisCode(@Param("uisCode") String uisCode);

    int countActiveByUisCode(@Param("uisCode") String uisCode);

    int insert(IpAuthSession session);

    int updateLastActiveAt(@Param("sessionId") String sessionId, @Param("lastActiveAt") LocalDateTime lastActiveAt);

    int delete(@Param("sessionId") String sessionId);

    int deleteByUisCode(@Param("uisCode") String uisCode);

    int deleteAll();

    int deleteExpiredSessions(@Param("threshold") LocalDateTime threshold);

    List<IpAuthSession> selectExpiredSessions(@Param("threshold") LocalDateTime threshold);
}
