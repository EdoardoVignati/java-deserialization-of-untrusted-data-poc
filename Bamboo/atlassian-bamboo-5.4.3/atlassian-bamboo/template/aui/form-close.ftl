</div><!-- END .form-content-container -->
[#if parameters.submitLabelKey?has_content || parameters.cancelUri?has_content || parameters.buttons?has_content || parameters.backLabelKey?has_content]
    [#if parameters.cancelUri??]
        [#assign sanitizedCancelUri=fn.sanitizeUri(parameters.cancelUri)]
    [/#if]
    [#if action.returnUrl??]
        [#assign sanitizedReturnUrl=fn.sanitizeUri(action.returnUrl)]
    [/#if]

    <div class="buttons-container[#if parameters.wizard?exists] wizardFooter[/#if]">
        <div class="buttons">
            ${parameters.buttonsBefore!}[#t/]
            [#-- This is needed so that the Next button is the default button --]
            [#if parameters.submitLabelKey?has_content]
                [@ww.submit value="${action.getText(parameters.submitLabelKey)}" theme='simple' name='save' id="${parameters.id}_defaultSave" cssClass='assistive' tabindex="-1" /]
            [/#if]
            [#if parameters.backLabelKey?has_content]
                [@ww.submit id="backButton" name="backButton"
                    customAccessKey="${action.getText('global.key.back')}"
                    title="${action.getText(parameters.backLabelKey)}"
                    value="${action.getText(parameters.backLabelKey)}"/]
            [#elseif parameters.wizard?exists]
                <input id="backButton" type="submit" disabled="disabled" value="[@ww.text name='global.buttons.back' /]" />
            [/#if]
            [#if parameters.submitLabelKey?has_content]
                [@ww.submit value="${action.getText(parameters.submitLabelKey)}" name='save' primary=(!(parameters.submitButtonNotPrimary))!true hideAccessKey=false/]
            [/#if]
            ${parameters.buttons!}[#t/]
            [#if sanitizedCancelUri?has_content || sanitizedReturnUrl?has_content]
                [#if sanitizedReturnUrl?has_content]
                    [@ww.url value='${sanitizedReturnUrl}' id='cancelUri'/][#t/]
                [#else]
                    [@ww.url value='${sanitizedCancelUri}' id='cancelUri' /][#t/]
                [/#if]
                [#assign cancelText]
                    [#if parameters.cancelSubmitKey?has_content]
                        [@ww.text name=parameters.cancelSubmitKey /][#t/]
                    [#else]
                        [@ww.text name='global.buttons.cancel' /][#t/]
                    [/#if]
                [/#assign]

                <a class="cancel" accesskey="[@ww.text name='global.key.cancel' /]" href="${cancelUri}">${cancelText}</a>[#lt/]
            [/#if]
        </div>
    </div>
[/#if]
[#include "/${parameters.templateDir}/simple/form-close.ftl" /]
