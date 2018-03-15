[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.AbstractSetupAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.AbstractSetupAction" --]
[#include "/fragments/decorator/setupHeader.ftl"]
[#import "/setup/setupCommon.ftl" as sc/]
[#assign metaStepData = (page.properties["meta.step"]!"0")?number?int /]
[#assign installType = ((setupPersister.setupType)!"")?string /]

<header id="header" role="banner">
    <nav class="aui-header aui-dropdown2-trigger-group" role="navigation">
        <div class="aui-header-inner">
            <div class="aui-header-primary">
                <h1 id="logo" class="aui-header-logo aui-header-logo-bamboo">
                    <a href="${req.contextPath}/">
                        <span class="aui-header-logo-device">[@ww.text name='bamboo.name' /]</span>
                    </a>
                </h1>
            </div>
            <div class="aui-header-secondary">
                <ul class="aui-nav">
                    <li id="system-help-menu">
                        <a class="aui-dropdown2-trigger" aria-haspopup="true" aria-owns="system-help-menu-content" href="https://confluence.atlassian.com/display/BAMBOO" title="Help"><span class="aui-icon aui-icon-small aui-iconfont-help">Help</span></a>
                        <div id="system-help-menu-content" class="aui-dropdown2 aui-style-default">
                            <div class="aui-dropdown2-section">
                                <ul id="jira-help" class="aui-list-truncate">
                                    <li><a href="https://confluence.atlassian.com/display/BAMBOO/Running+the+Setup+Wizard">Setup Help</a></li>
                                    <li><a href="https://confluence.atlassian.com/display/BAMBOO">Bamboo Help</a></li>
                                    <li><a href="https://answers.atlassian.com/tags/bamboo/">Bamboo Answers</a></li>
                                </ul>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header><!-- END #header -->

<section id="content" role="main">
    [#if installType == "custom" || installType == "install"]
        [#assign progressSteps = [] /]
        [#if installType == "custom"]
            [#list 1..4 as i]
                [#assign progressSteps = progressSteps + [{
                    "text": action.getText("setup.type.custom.step.${i}"),
                    "isCurrent": (metaStepData == i)
                }] /]
            [/#list]
        [/#if]
        <header class="aui-page-header">
            <div class="aui-page-header-inner">
                <div class="aui-page-header-main">
                    [@ui.header pageKey='setup.type.${installType}' /]
                </div><!-- .aui-page-header-main -->
                [#if progressSteps?size gt 0]
                    <div class="aui-page-header-actions">
                        [@sc.progressTracker isInverted=true steps=progressSteps /]
                    </div><!-- .aui-page-header-actions -->
                [/#if]
            </div><!-- .aui-page-header-inner -->
        </header>
    [/#if]
	<div class="aui-page-panel">
        <div class="aui-page-panel-inner">
            <div class="aui-page-panel-content">${body}</div>
        </div>
    </div>
</section><!-- END #content -->

[#include "/fragments/decorator/setupFooter.ftl"]