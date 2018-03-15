[#-- @ftlvariable name="stageState" type="com.atlassian.bamboo.chains.StageExecution" --]
[#-- @ftlvariable name="chainExecution" type="com.atlassian.bamboo.chains.ChainExecution" --]
[#-- @ftlvariable name="chain" type="com.atlassian.bamboo.chains.Chain" --]
[#include "notificationCommonsHtml.ftl" ]

[#assign chainResultKey = chainExecution.planResultKey/]

<div>
<style type="text/css">
    [#--NB: These css styles will not actually be picked up by some email clients do don't put anything vital to presentation in here. --]        
.successful a, .successful a:visited, .successful a:link, .successful a:hover,.successful  a:active {color:#393}
.failed a, .failed a:visited, .failed a:link, .failed a:hover,.failed  a:active {color:#d62829}
.notexecuted a, .notexecuted a:visited, .notexecuted a:link, .notexecuted a:hover,.notexecuted  a:active {color:#ffcc66}
td a, td a:link, td a:visited, td a:hover, td a:active {background:transparent;font-family: Arial, sans-serif;text-decoration:underline;}
td a:link {color:#369;}
td a:visited {color:#444;}
td a:hover, td a:active {color:#036;}
td a:hover {text-decoration:none;}
</style>
<font size="2" color="black" face="Arial, Helvetica, sans-serif" style="font-family: Arial, sans-serif;font-size: 13px;color:#000">
<table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">

<tr>
	<td style="vertical-align:top">
        [#if stageState.successful]
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#e4f5e3;border-top:1px solid #b4e2b4;border-bottom:1px solid #b4e2b4;color:#393;">
			<tr>
				<td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
					<img src="${baseUrl}/images/iconsv4/icon-build-successful.png" width="15" height="15">
				</td>
				<td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#393;padding:5px 10px">
                    <span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;">Stage <b>${stageState.name}</b> of plan </span>
					<a href="${baseUrl}/chain/result/viewChainResult.action?buildKey=${chain.key}&buildNumber=${chainResultKey.buildNumber}" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#393">${chainResultKey}</a>
					<span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;"> was successful.</span>
                    <span class="successful" style="font-family: Arial, sans-serif; font-size: 13px;">
                    </span>
                </td>
			</tr>
        </table>
		<br>
        [#else]
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffe6e7;border-top:1px solid #eec0c0;border-bottom:1px solid #eec0c0;color:#d62829;">
        <tr>
        <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
            <img src="${baseUrl}/images/iconsv4/icon-build-failed.png" width="15" height="15">
        </td>
        <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#d62829;padding:5px 10px">
            <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;">Stage <b>${stageState.name}</b> of plan </span>
            <a href="${baseUrl}/chain/result/viewChainResult.action?buildKey=${chain.key}&buildNumber=${chainResultKey.buildNumber}" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#d62829">${chainResultKey}</a>
            <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;">failed.</span>
            <span class="failed" style="font-family: Arial, sans-serif; font-size: 13px;">
            </span>
        </td>
        </tr>
        </table>
        <br>
        [/#if]
    </td>
    <td width="150" style="vertical-align:top">
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
            <tr>
                <td style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;vertical-align:top;padding:5px 10px">
                    Actions
                </td>
            </tr>
        </table>
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#f5f9fc;border-bottom:1px solid #bbd0e5;">
            <tr>
                <td style="font-family: Ariel, sans-serif; font-size: 13px; color:#036;vertical-align:top;padding:5px 10px;line-height:1.7">
                    <a href="${baseUrl}/chain/result/viewChainResult.action?buildKey=${chain.key}&buildNumber=${chainResultKey.buildNumber}" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">View Online</a>
                </td>
            </tr>
        </table>
    </td>
</tr>

[#list stageState.builds as build]

<tr>
	<td style="vertical-align:top">
        [#if build.buildState == "Successful"]
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#e4f5e3;border-top:1px solid #b4e2b4;border-bottom:1px solid #b4e2b4;color:#393;">
			<tr>
				<td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
					<img src="${baseUrl}/images/iconsv4/icon-build-successful.png" width="15" height="15">
				</td>
				<td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#393;padding:5px 10px">
					<span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;">Build </span>
					<a href="${baseUrl}/browse/${build.planResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#393">${build.planResultKey}</a>
					<span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;"> was successful.</span>
                </td>
			</tr>
        </table>
        [#else]
        [#if build.completed]
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffe6e7;border-top:1px solid #eec0c0;border-bottom:1px solid #eec0c0;color:#d62829;">
            <tr>
                <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
                    <img src="${baseUrl}/images/iconsv4/icon-build-successful.png" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#d62829;padding:5px 10px">
                    <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;">Build </span>
                    <a href="${baseUrl}/browse/${build.planResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#d62829">${build.planResultKey}</a>
                    <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;">failed.</span>
                </td>
            </tr>
        </table>
        [#else]
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffffcc;border-top:1px solid #ffcc00;border-bottom:1px solid #ffcc00;color:#ffcc66;">
            <tr>
                <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
                    <img src="${baseUrl}/images/iconsv4/icon-build-unknown.png" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#ffcc66;padding:5px 10px">
                    <span class="notexecuted" style="font-family: Arial, sans-serif; font-size: 14px;">Build </span>
                    <a href="${baseUrl}/browse/${build.planResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#ffcc66">${build.planResultKey}</a>
                    <span class="notexecuted" style="font-family: Arial, sans-serif; font-size: 14px;">not executed.</span>
                </td>
            </tr>
        </table>
        [/#if]
        [/#if]
    </td>
<tr>
[/#list]
<tr>
    <td>
    [@showEmailFooter baseUrl/]
    </td>
</tr>
</table>
</font>
</div>
