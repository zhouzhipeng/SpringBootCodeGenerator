package com.softdev.system.generator.service;

import com.softdev.system.generator.util.FreemarkerUtil;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * GeneratorService
 *
 * @author zhengkai.blog.csdn.net
 */
@Slf4j
@Service
public class GeneratorServiceImpl implements GeneratorService {

    @Autowired
    private FreemarkerUtil freemarkerTool;

    String templateCpnfig = null;

    /**
     * 从项目中的JSON文件读取String
     *
     * @author zhengkai.blog.csdn.net
     */
    public String getTemplateConfig() throws IOException {
        templateCpnfig = null;
        if (templateCpnfig != null) {
        } else {
            InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("template.json");
            templateCpnfig = new BufferedReader(new InputStreamReader(inputStream))
                    .lines().collect(Collectors.joining(System.lineSeparator()));
            inputStream.close();
        }
        //log.info(JSON.toJSONString(templateCpnfig));
        return templateCpnfig;
    }

    /**
     * 根据配置的Template模板进行遍历解析，得到生成好的String
     *
     * @author zhengkai.blog.csdn.net
     */
    @Override
    public Map<String, String> renderBatchFTLs(String[] ftlFiles, Map<String, Object> params) throws IOException, TemplateException {
        Map<String, String> result = new LinkedHashMap<>(32);
        result.put("tableName", params.get("tableName") + "");
        for (String ftl : ftlFiles) {
            String fileName = ftl.split("/")[1];
            result.put(fileName.substring(0, fileName.length() - ".ftl".length()), freemarkerTool.processString(ftl, params));
        }
        return result;
    }

    @Override
    public String renderFTL(String ftlPath, Map<String, Object> params) throws Exception {
        return freemarkerTool.processString(ftlPath, params);
    }
}
