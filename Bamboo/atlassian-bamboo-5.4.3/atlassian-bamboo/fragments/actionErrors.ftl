[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]

[#if actionErrors?has_content]
<div class="errorBox">
    <span class="errorMessage">[@ww.text name='error.multiple' /]</span>
    <ul>
        [#foreach error in formattedActionErrors]
            <li>${error}</li>
        [/#foreach]
    </ul>
</div>
[/#if]