package ${packageName}.mapper;

import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * @description ${classInfo.classComment}Mapper
 * @author ${authorName}
 * @date ${.now?string('yyyy-MM-dd')}
 */
@Mapper
@Repository
public interface ${classInfo.className}Mapper {

    @Select("select * from ${classInfo.tableName} where ${classInfo.tableName}_id=井{id}")
    public ${classInfo.className} getById(Integer id);

    @Insert("insert into ${classInfo.tableName} " +
            "(<#list classInfo.fieldList as fieldItem >${fieldItem.columnName}<#if fieldItem_has_next>,</#if></#list>) " +
            "values (<#list classInfo.fieldList as fieldItem >井{${fieldItem.fieldName}}<#if fieldItem_has_next>,</#if></#list>)")
    Integer insert(${classInfo.className} ${classInfo.className?uncap_first});

    @Delete(value = "delete from ${classInfo.tableName} where ${classInfo.tableName}_id=井{${classInfo.className?uncap_first}Id}")
    boolean delete(Integer id);

    @Update(value = "update ${classInfo.tableName} set "
    <#list classInfo.fieldList as fieldItem >
        <#if fieldItem.columnName != "id">+" ${fieldItem.columnName}=井{${fieldItem.fieldName}}<#if fieldItem_has_next>,</#if>"</#if>
    </#list>
        +" where ${classInfo.tableName}_id=井{${classInfo.className?uncap_first}Id} ")
    boolean update(${classInfo.className} ${classInfo.className?uncap_first});


    @Results(value = {
    <#list classInfo.fieldList as fieldItem >
        @Result(property = "${fieldItem.fieldName}", column = "${fieldItem.columnName}")<#if fieldItem_has_next>,</#if>
    </#list>
    })
    @Select(value = "select * from ${classInfo.tableName} where ${classInfo.tableName}_id=井{queryParam}")
    ${classInfo.className} selectOne(String queryParam);

    @Results(value = {
    <#list classInfo.fieldList as fieldItem >
        @Result(property = "${fieldItem.fieldName}", column = "${fieldItem.columnName}")<#if fieldItem_has_next>,</#if>
    </#list>
    })
    @Select(value = "select * from ${classInfo.tableName} where "
    <#list classInfo.fieldList as fieldItem >
        +" ${fieldItem.columnName}=井{${fieldItem.fieldName}}<#if fieldItem_has_next> or </#if>"
    </#list>
    )
    List<${classInfo.className}> selectList(${classInfo.className} ${classInfo.className?uncap_first});

}