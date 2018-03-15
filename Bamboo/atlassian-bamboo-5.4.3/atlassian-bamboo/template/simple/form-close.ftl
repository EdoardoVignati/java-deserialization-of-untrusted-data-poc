<#if ctx.isXsrfTokenNeeded(parameters.action)>
    <#assign xsrfToken = ctx.xsrfToken!/>
    <#if xsrfToken?has_content>
        <input type="hidden" name="atl_token" value="${xsrfToken?html}" />
    </#if>
</#if>
</form>

<#-- 
 Code that will add javascript needed for tooltips
--><#t/>
<#if parameters.hasTooltip?default(false)><#t/>
	<#lt/><!-- javascript that is needed for tooltips -->
	<#lt/><script language="JavaScript" type="text/javascript" src="<@ww.url value='/webwork/tooltip/wz_tooltip.js' encode='false' />"></script>
</#if><#t/>
<#if parameters.selectFirstFieldOfForm!false><#t/>
    <script type="text/javascript">
        jQuery(function(){
            BAMBOO.DynamicFieldParameters.selectFirstFieldOfForm('${parameters.id?html}');
        });
    </script>
</#if><#t/>

<#-- Clears the current form context -->
${(action.setCurrentFormTheme(null))!}
