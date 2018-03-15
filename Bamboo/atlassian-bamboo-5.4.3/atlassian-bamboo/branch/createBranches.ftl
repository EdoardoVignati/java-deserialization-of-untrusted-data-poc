[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.CreateChainBranch" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.CreateChainBranch" --]

[@ww.form action="/chain/admin/createPlanBranch.action"
          cancelUri='/chain/admin/config/configureBranches.action?buildKey=${planKey}'
          submitLabelKey='global.buttons.create' ]

<p>[@ww.text name="branch.create.new.title.description"/]</p>
    [#assign canDoAuto=action.branchDetectionCapable/]
    [#if canDoAuto]
        <div class="hidden">
            [@ww.textfield id="creationOption" name="creationOption" value="${creationOption!'AUTO'}"/]      [#--this value gets swapped out in javascript--]
        </div>
        <div id="autoBranchCreation" [#if creationOption?? && creationOption != 'AUTO']class="hidden"[/#if]>
            [@cp.displayLinkButton cssClass="switchToManual floating-toolbar" buttonId='switchToManualOption' buttonLabel='branch.create.manual.switch' /]
            <h2>[@ww.text name="branch.create.auto.heading"/] </h2>
            <div class="autoContent">
                <div class="placeHolder">
                    [@ui.icon type="loading" /]
                    <span>[@ww.text name="branch.create.auto.waiting"]
                            [@ww.param]<a class="switchToManual">[/@ww.param]
                            [@ww.param]</a>[/@ww.param]
                            [/@ww.text]
                    </span>
                </div>
            </div>
            <div class="options hidden">
                <h2>[@ww.text name="branch.create.options.heading"/]</h2>
                [@ww.checkbox labelKey="branch.create.auto.enable.option" name='tmp.auto.createAsEnabled'/]
            </div>
        </div>
    [#else]
        [@ww.hidden  id="creationOption" name="creationOption" value="MANUAL"/]
    [/#if]

    <div id="manualBranchCreation" [#if (canDoAuto && !(creationOption?? && creationOption == 'MANUAL'))]class="hidden"[/#if]>
        [#if canDoAuto][@cp.displayLinkButton cssClass="switchToAuto floating-toolbar" buttonId='switchToAutoOption' buttonLabel='branch.create.auto.switch'/][/#if]
        <h2>[@ww.text name="branch.create.manual.heading"/]</h2>
        [@ww.textfield labelKey='branch.name' name='branchName' required='true' /]
        [@ww.textfield labelKey='branch.branchDescription' name='branchDescription' required='false'/]
        [#if canDoAuto]
            [@ww.textfield labelKey="branch.vcsbranchname" name="branchVcsName" required='false'/]
        [/#if]
        [@ww.checkbox labelKey="branch.create.enable.option" name='tmp.createAsEnabled'/]
    </div>

    [@ww.hidden name='planKeyToClone' value='${planKey}' /]
    [@ww.hidden name='planKey' value='${planKey}' /]
[/@ww.form]

<script type="text/javascript">
    BAMBOO.BranchCreation.init({
        templates: {
           branchesList: "branchesList",
           branchesItem: "branchesItem",
           branchesNone: "branchesNone",
           branchesTooMany: "branchesTooMany",
           branchesTimeout: "branchesTimeout",
           branchesError: "branchesError"
        },
        planKey: '${planKey.toString()?js_string}',
        getBranchesUrl: "[@ww.url value='/rest/api/latest/plan/' + planKey + '/vcsBranches' /]",
        containerSelector: ".autoContent",
        checkBoxFieldSetSelector: "#fieldArea_branchesForCreation",
        showMoreSelector: "#showMoreBranches",
        placeHolderSelector: ".placeHolder",
        optionsSelector: ".options"
    });
</script>

<script type="text/x-template" title="branchesList">
    <p>[@ww.text name="branch.create.auto.checkbox.description"/]</p>
    [@ww.checkboxlist name='branchesForCreation' /]
</script>
<script type="text/x-template" title="branchesItem">
    <div class="checkbox">
        <input type="checkbox" class="checkbox" name="branchesForCreation" value="{branch}" id="branchesForCreation-{itemCount}" />
        <label for="branchesForCreation-{itemCount}" title="{branch}">{branch}</label>
    </div>
</script>
<script type="text/x-template" title="branchesNone">
    <p>[#t]
        [@ww.text name="branch.create.auto.none"]
            [@ww.param]<a class="switchToManual">[/@ww.param]
            [@ww.param]</a>[/@ww.param]
        [/@ww.text][#t]
    </p>
</script>
<script type="text/x-template" title="branchesTooMany">
    <div id="showMoreBranches">
        [@ww.text name="branch.create.auto.toomany"/]
    </div>
</script>
<script type="text/x-template" title="branchesTimeout">
      <p>[#t]
      [@ww.text name="branch.create.auto.timeout"]
          [@ww.param]<a class="switchToManual">[/@ww.param]
          [@ww.param]</a>[/@ww.param]
      [/@ww.text][#t]
    </p>
</script>
<script type="text/x-template" title="branchesError">
      <p>[#t]
      [@ww.text name="branch.create.auto.error"]
          [@ww.param]<a class="switchToManual">[/@ww.param]
          [@ww.param]</a>[/@ww.param]
      [/@ww.text][#t]
    </p>
</script>