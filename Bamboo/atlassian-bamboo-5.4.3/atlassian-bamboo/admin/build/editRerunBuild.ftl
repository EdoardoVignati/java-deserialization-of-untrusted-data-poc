[#-- @ftlvariable name="action" type="com.atlassian.bamboo.v2.ww2.build.RerunBuild" --]
[@ww.form action="executeRerunBuild" namespace="/ajax" submitLabelKey="rerunBuild.form.button.proceed" cancelSubmitKey="rerunBuild.form.button.cancel" cssClass="custom-build"]

    [@ww.text name="rerunBuild.form.message"/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='buildNumber' /]
    [@ww.hidden name='returnUrl' /]

[/@ww.form]
