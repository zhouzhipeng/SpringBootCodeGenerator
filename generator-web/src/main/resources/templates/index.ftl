<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SQL转Java JPA、MYBATIS实现类代码生成平台</title>
    <meta name="keywords" content="sql转实体类,sql转DAO,SQL转service,SQL转JPA实现,SQL转MYBATIS实现">

    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />
    <@netCommon.commonScript />

<script>

    <@netCommon.viewerCounter />

    $(function () {
        /**
         * 初始化 table sql 3
         */
        var ddlSqlArea = CodeMirror.fromTextArea(document.getElementById("ddlSqlArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-sql",
            lineWrapping:false,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        ddlSqlArea.setSize('auto','auto');
        // controller_ide
        var genCodeArea = CodeMirror.fromTextArea(document.getElementById("genCodeArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-java",
            lineWrapping:true,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        genCodeArea.setSize('auto','auto');

        var codeData;
        // 使用：var jsonObj = $("#formId").serializeObject();
        $.fn.serializeObject = function()
        {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function() {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
        var historyCount=0;
        //初始化清除session
        if (window.sessionStorage){
            //修复当F5刷新的时候，session没有清空各个值，但是页面的button没了。
            sessionStorage.clear();
        }
        /**
         * 生成代码
         */
        $('#btnGenCode').click(function ()  {
            var jsonData = {
                "tableSql": ddlSqlArea.getValue(),
                "packageName":$("#packageName").val(),
                "returnUtil":$("#returnUtil").val(),
                "authorName":$("#authorName").val(),
                "dataType":$("#dataType").val(),
                "tinyintTransType":$("#tinyintTransType").val(),
                "nameCaseType":$("#nameCaseType").val(),
                "swagger":$("#isSwagger").val()
            };
            $.ajax({
                type: 'POST',
                url: base_url + "/genCode",
                data:(JSON.stringify(jsonData)),
                dataType: "json",
                contentType: "application/json",
                success: function (data) {
                    if (data.code === 200) {
                        codeData = data.data;
                        genCodeArea.setValue(codeData.default);
                        genCodeArea.setSize('auto', 'auto');
                        $.toast("√ 代码生成成功");
                        //添加历史记录
                        addHistory(codeData);
                        
                        //渲染 resultButtons
                        $("#resultButtons").html(codeData.resultButtons);
                        /**
                         * 按钮事件组
                         */
                        $('.generator').bind('click', function () {
                            if (!$.isEmptyObject(codeData)) {
                                genCodeArea.setValue(codeData[this.id]);
                                genCodeArea.setSize('auto', 'auto');
                            }
                        });
                        
                    } else {
                        $.toast("× 代码生成失败 :"+data.msg);
                    }
                }
            });
            return false;
        });
        /**
         * 切换历史记录
         */
        function getHistory(tableName){
            if (window.sessionStorage){
                var valueSession = sessionStorage.getItem(tableName);
                codeData = JSON.parse(valueSession);
                $.toast("$ 切换历史记录成功:"+tableName);
                genCodeArea.setValue(codeData.entity);
            }else{
                console.log("浏览器不支持sessionStorage");
            }
        }
        /**
         * 添加历史记录
         */
        function addHistory(data){
            if (window.sessionStorage){
                //console.log(historyCount);
                if(historyCount>=9){
                    $("#history").find(".btn:last").remove();
                    historyCount--;
                }
                var tableName=data.tableName;
                var valueSession = sessionStorage.getItem(tableName);
                if(valueSession!==undefined && valueSession!=null){
                    sessionStorage.removeItem(tableName);
                }else{
                    $("#history").prepend('<button id="his-'+tableName+'" type="button" class="btn">'+tableName+'</button>');
                    //$("#history").prepend('<button id="his-'+tableName+'" onclick="getHistory(\''+tableName+'\');" type="button" class="btn">'+tableName+'</button>');
                    $("#his-"+tableName).bind('click', function () {getHistory(tableName)});
                }
                sessionStorage.setItem(tableName,JSON.stringify(data));
                historyCount++;
            }else{
                console.log("浏览器不支持sessionStorage");
            }
        }
        
        $('#btnCopy').on('click', function(){
            $("#optionsBar").toggle();
        });

    });
</script>
</head>
<body style="background-color: #e9ecef">


<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron">
    <div class="container">
        <h2>Java Code Generator!</h2>
        <hr>

        <textarea id="ddlSqlArea" placeholder="请输入表结构信息..." class="form-control btn-lg" style="height: 250px;">
CREATE TABLE 'user_info' (
  'user_id' int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  'user_name' varchar(255) NOT NULL COMMENT '用户名',
  'add_time' datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY ('user_id')
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息'
        </textarea><br>

        
        <p><button class="btn btn-primary btn-lg" id="btnGenCode" role="button" data-toggle="popover" data-content="">开始生成 »</button> 
            <button class="btn alert-secondary" id="btnCopy">详细设置</button>
        </p>
       



        <div id="optionsBar" style="display: none">
            <div class="input-group mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text">作者名称</span>
                </div>
                <input type="text" class="form-control" id="authorName" name="authorName" value="zhouzhipeng">
                <div class="input-group-prepend">
                    <span class="input-group-text">返回封装</span>
                </div>
                <input type="text" class="form-control" id="returnUtil" name="returnUtil" value="ReturnT">
                <div class="input-group-prepend">
                    <span class="input-group-text">包名路径</span>
                </div>
                <input type="text" class="form-control" id="packageName" name="packageName" value="com.zhouzhipeng">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text">数据类型</span>
                </div>
                <select type="text" class="form-control" id="dataType"
                        name="dataType">
                    <option value="sql">ddl-sql</option>
                    <option value="json">json</option>
                    <option value="insert-sql">insert-sql</option>
                    <#--<option value="sql-regex">sql-regex</option>-->
                </select>
                <div class="input-group-prepend">
                    <span class="input-group-text">tinyint转换类型</span>
                </div>
                <select type="text" class="form-control" id="tinyintTransType"
                        name="tinyintTransType">
                    <option value="boolean">boolean</option>
                    <option value="Boolean">Boolean</option>
                    <option value="Integer">Integer</option>
                    <option value="int">int</option>
                    <option value="String">String</option>
                </select>
                <div class="input-group-prepend">
                    <span class="input-group-text">命名转换规则</span>
                </div>
                <select type="text" class="form-control" id="nameCaseType"
                        name="nameCaseType">
                    <option value="CamelCase">驼峰</option>
                    <option value="UnderScoreCase">下划线</option>
                    <#--<option value="UpperUnderScoreCase">大写下划线</option>-->
                </select>
                <div class="input-group-prepend">
                    <span class="input-group-text">swagger-ui</span>
                </div>
                <select type="text" class="form-control" id="isSwagger"
                        name="isSwagger">
                    <option value="false">关闭</option>
                    <option value="true">开启</option>
                </select>
            </div>

            <hr>
        </div>

   

        <div id="history" class="btn-group" role="group" aria-label="Basic example"></div>


        <div id="resultButtons"></div>
      
        
        <textarea id="genCodeArea"  class="form-control btn-lg" >点击上方 "开始生成" 按钮后在此查看结果！
        </textarea>
    </div>
</div>

    <@netCommon.commonFooter />
</body>
</html>
