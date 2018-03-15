[#assign editorElementId=parameters.id?html]
[#assign name=parameters.name?html]
[#assign isReadonly=parameters.isReadonly!false]

[#assign editorValueId=editorElementId + "_value"/]
[#assign resizableId=editorElementId + "_resizable"]
[#assign editorRef=editorElementId + "_ref"]

[#if name?eval??]
    [#if name?eval.getClass().array]
        [#assign editorValue=name?eval[0]]
    [#else]
        [#assign editorValue=name?eval]
    [/#if]
[/#if]

<textarea id="${editorValueId}" name="${name}" class="hidden aceDataModel" data-editor-ref="${editorRef}">${editorValue!""?html}</textarea>

<div id="${resizableId}" class="bambooAceResizableContainer">
    <div id="${editorElementId}" style="position: relative" class="bambooAceEditor"></div>
</div>

<script>
    ${editorRef} = ace.edit("${editorElementId}"); //this has to be a global var, otherwise you'll get line numbers as a part of the content...

    var     editor = ${editorRef},
            HighlightMode = ace.require("ace/mode/sh").Mode;

    editor.getSession().setMode(new HighlightMode());
    editor.setShowPrintMargin(false);
    editor.renderer.setHScrollBarAlwaysVisible(false);

    [#if isReadonly]
        editor.setReadOnly(true);
    [/#if]
    AJS.$("#${resizableId}").resizable({
                                           resize: function(event, ui) { editor.resize(); }
                                       });
    //we need to copy data from editor to form on submit
    AJS.$('#${editorElementId}').closest('form').submit(AceEditorManager.editorToModel);

    AJS.$(AceEditorManager.init());
</script>
