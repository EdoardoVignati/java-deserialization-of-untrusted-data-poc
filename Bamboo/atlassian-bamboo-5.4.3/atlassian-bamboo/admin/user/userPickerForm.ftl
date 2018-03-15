
<div class="inlineSearchForm">
    [@ww.form action='userPickerSearch' namespace='/admin/user' submitLabelKey='Search' theme='simple' ]
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.username" /]</span>
        [@ww.textfield labelKey='user.username' name="usernameTerm" /]
    </div>
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.fullName" /]</span>
        [@ww.textfield labelKey='user.fullName' name="fullnameTerm" /]
    </div>
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.email" /]</span>
        [@ww.textfield labelKey='user.email' name="emailTerm" /]
    </div>
    <div class="inlineSubmitButton" >
        <input type='submit' value='Search' />
    </div>
    [@ww.hidden name='fieldId' /]
    [@ww.hidden name='multiSelect' /]

    [/@ww.form]
    <div class="clearer"></div>
</div>
