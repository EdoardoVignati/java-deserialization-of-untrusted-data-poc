[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
<html>
<head>
    <title>[@ww.text name='plan.create' /]</title>
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
[@ui.header pageKey="plan.create" descriptionKey="plan.create.description" /]
<ul id="creationOption">
    <li>
        <a id="createNewPlan"  href="[@ww.url action="newPlan" namespace="/build/admin/create"/]">
            <strong>[@ww.text name="plan.create.new.title"/]</strong>
            <span>[@ww.text name="plan.create.new.help"/]</span>
        </a>
    </li>
    [#if plansToClone?has_content]
        <li>
            <a id="clonePlan" href="[@ww.url action="clonePlan" namespace="/build/admin/create"/]">
                <strong>[@ww.text name="plan.create.clone.title"/]</strong>
                <span>[@ww.text name="plan.create.clone.help"/]</span>
            </a>
        </li>
    [/#if]
    [#if featureManager.mavenProjectImportSupported]
        <li>
            <a id="importMavenPlan" href="[@ww.url action="importMavenPlan" namespace="/build/admin/create"/]">
                <strong>[@ww.text name="plan.create.maven.title"/]</strong>
                <span>[@ww.text name="plan.create.maven.help"/]</span>
            </a>
        </li>
    [/#if]
</ul>
</body>
</html>