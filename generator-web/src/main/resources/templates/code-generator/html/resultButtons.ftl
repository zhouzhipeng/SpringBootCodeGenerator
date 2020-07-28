<#list groupNames?keys as key>

<div class="row" style="margin-top: 10px;">
        
    <div class="btn-toolbar col-md-12" role="toolbar" aria-label="Toolbar with button groups">
        <div class="input-group">
            <div class="input-group-prepend">
                <div class="btn btn-secondary disabled setWidth" >${key!}</div>
            </div>
        </div>
        <div class="btn-group" role="group" aria-label="First group">
            <#list groupNames[key]  as name>
            <button type="button" class="btn btn-default generator" id="${name}">${name}</button>
            </#list>
        </div>
    </div>
 
</div>

</#list>

<hr>