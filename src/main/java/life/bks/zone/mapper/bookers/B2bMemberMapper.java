package life.bks.zone.mapper.bookers;

import life.bks.zone.domain.B2bMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface B2bMemberMapper {
    int insertMember(B2bMember member);

    B2bMember selectByUserid(@Param("umUserid") String umUserid);

    B2bMember selectByUisCodeAndUserid(@Param("umUisCode") String umUisCode, @Param("umUserid") String umUserid);

    void getSequence(B2bMember member);
}
