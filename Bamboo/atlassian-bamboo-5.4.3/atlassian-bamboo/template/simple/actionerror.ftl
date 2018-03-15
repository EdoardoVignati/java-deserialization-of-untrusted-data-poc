[#if action.hasActionErrors() ]
	<ul>
        [#list formattedActionErrors as error]
            <li><span class="errorMessage">${error}</span></li>
        [/#list]
	</ul>
[/#if]