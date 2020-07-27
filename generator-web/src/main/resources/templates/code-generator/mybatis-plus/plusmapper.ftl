package ${packageName}.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import ${packageName}.entity.${classInfo.className};
import java.util.List;

/**
 * @description ${classInfo.classComment}
 * @author ${authorName}
 * @date ${.now?string('yyyy-MM-dd')}
 */
@Mapper
public interface ${classInfo.className}Mapper extends BaseMapper<${classInfo.className}> {


}
