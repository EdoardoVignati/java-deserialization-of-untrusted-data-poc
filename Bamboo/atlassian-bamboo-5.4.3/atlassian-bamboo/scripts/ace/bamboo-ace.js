var AceEditorManager = function($) {
    var
            toEditorSession = function(aceDataModel) {
                var $aceDataModel = $(aceDataModel),
                        editorRef = $aceDataModel.data("editorRef");
                return eval(editorRef).getSession();
            },
            forEachDataModel = function(fun) {
                $(".aceDataModel").each(fun);
            };
    return {
        init: function() {
            forEachDataModel(function(){ toEditorSession(this).setValue($(this).val());  } );
        },
        editorToModel: function() {
            forEachDataModel(function(){ $(this).val(toEditorSession(this).getValue()); }  );
        }
    }
}(jQuery);
