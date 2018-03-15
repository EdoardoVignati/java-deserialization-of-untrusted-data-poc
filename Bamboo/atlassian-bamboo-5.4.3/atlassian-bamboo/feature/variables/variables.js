(function ($, BAMBOO) {
    BAMBOO.VARIABLES = {};

    /**
     * Inline Editing
     * @param options
     *  - target        String - selector targeting the span/element to make inline-editable
     *  - submit        Function - handles what to do when value is submitted
     *  - cancel        Function - handles what to do when cancel is triggered
     *  - focus         Function - handles what to do when focus is given to the edit field
     *  - $delegator    jQuery Object - where the event handler should be bound
     */
    BAMBOO.inlineEdit = function (options) {
        var defaults = {
                target: null,
                submit: null,
                cancel: null,
                focus: null
            },
            handleEdit = function (event) {
                var $target = $(this);
                var $row = $target.parents('tr:first');

                if (!keyIsPassword($row)) {
                    prepareRow($row, $target);
                }
                // field contains password
                else {
                    prepareRow($row, $target, true,
                        _.bind(function () {
                            var keyElement = $row.find('td:eq(0) .inline-edit-field');
                            var $input = $target.siblings('div.input-password');

                            keyElement.trigger('selected', !!$input.length);
                        }, this)
                    );
                }

                event.preventDefault();
            },
            handleKeyDown = function (event) {
                var keyCode = event.which;
                var $element = $(event.currentTarget);

                // on ESCAPE revert current changes
                if (keyCode === $.ui.keyCode.ESCAPE) {
                    revertRow($element.blur().parents('tr:first'));
                    event.preventDefault();
                }
                // on ENTER apply current changes
                else if (keyCode === $.ui.keyCode.ENTER) {
                    updateRow($element.blur().parents('tr:first'));
                    event.preventDefault();
                }
            },
            prepareRow = function ($row, $target, clearValue, callback) {
                // update currently active row
                options.$delegator.find('tr.active').each(function () {
                    revertRow($(this));
                });

                // find elements
                var $elements = $row.find('.inline-edit-view');
                var elementsCount = $elements.length;

                $elements.each(function (index) {
                    var $target = $(this);
                    var $input = $target.parent('td:first').find('.inline-edit-field:text');

                    // set current value
                    $input.val($target.text());

                    // clear value for last element if flag was set
                    if (clearValue && (elementsCount - 1) === index) {
                        $input.val('');
                    }

                    if (!$input.data('hasInlineEditHandlers')) {
                        $input.keydown(handleKeyDown)
                            .data('hasInlineEditHandlers', true)
                            .data('lastValidValue', $input.val());
                    }

                    $target.hide();
                    $input.parent().removeClass('hidden');
                });

                if ($.isFunction(options.focus)) {
                    options.focus($target);
                }

                // focus on first input field (which was clicked)
                $target.parent().find('.inline-edit-field').addClass('focus').focus();

                if ($.isFunction(callback)) {
                    callback();
                }
            },
            revertRow = function ($row) {
                // activate first row
                options.$delegator.find('tr.inactive').removeClass('inactive');

                // cancel callback
                if ($.isFunction(options.cancel)) {
                    options.cancel($row.find('td:eq(0) input:visible'));
                }

                // reset styles and behaviour
                $row.removeClass('active')
                    .find('.inline-edit-view, .inline-edit-field')
                    .attr('style', '');

                $row.find('td:eq(1) .input-password').addClass('hidden');
            },
            updateRow = function ($row) {
                if (!$.isFunction(options.submit)) {
                    updateRowSuccess();
                }
                // submit callback
                else {
                    options.submit($row.find('td:eq(1)').find('input:visible'), _.bind(function () {
                        updateRowSuccess($row);
                    }, this));
                }
            },
            updateRowSuccess = function ($row) {
                var keyCell = $row.find('td:eq(0)');

                // is key value empty?
                if ($.trim(keyCell.find('input').val()).length > 0) {
                    // activate first row
                    options.$delegator.find('tr.inactive').removeClass('inactive');

                    // cancel callback
                    if ($.isFunction(options.cancel)) {
                        options.cancel(keyCell.find('input:visible'));
                    }

                    // reset styles and behaviour
                    $row.removeClass('active')
                        .find('.inline-edit-view, .inline-edit-field')
                        .attr('style', '');

                    keyCell.find('.inline-edit-view:first').text(
                        keyCell.find('.inline-edit-field:text').val()
                    );

                    // default password value
                    var value = '********';
                    var valueCell = $row.find('td:eq(1)');

                    valueCell.find('.input-password')
                        .addClass('hidden');

                    if (!keyIsPassword($row)) {
                        value = valueCell.find('.inline-edit-field:text').val();
                    }

                    $row.find('td:eq(1) .inline-edit-view:first').text(value);
                }
            },
            keyIsPassword = function ($row) {
                var value = $.trim($row.find('.inline-edit-view:first').text()).toLowerCase();
                return (value.indexOf('password') >= 0);
            };

        options = $.extend(true, defaults, options);

        // append update handler
        options.$delegator.find('.operations button[name="update"]').on('click', function () {
            updateRow($(this).parents('tr:first'));
        });

        // append revert handler
        options.$delegator.find('.operations a.cancel-variable').on('click', function () {
            revertRow($(this).parents('tr:first'));
        });

        // revert current active TR if user click on .add-variable fields
        options.$delegator.find('tr.add-variable').on('click', 'input', _.bind(function () {
            var $active = options.$delegator.find('tr.active');

            if ($active.length) {
                revertRow($active);
                $(this).removeClass('inactive');
            }
        }, this));

        if (options.target) {
            options.$delegator.delegate(options.target, 'click', handleEdit);
        }
    };

    function VariablesTable(options) {
        if (!(this instanceof VariablesTable)) {
            return new VariablesTable(options);
        }

        var defaults = {
            selectors: {
                table: null,
                addRow: '.add-variable',
                deleteRow: '.delete-variable',
                overrideButton: '.variables-override'
            },
            templates: {
                row: null
            },
            availableVariables: null
        }, that = this;
        this.options = $.extend(true, defaults, options);

        this.$table = $(this.options.selectors.table)
            .on('click', this.options.selectors.deleteRow, function (e) { _.bind(that.handleDeleteClick, that)(this, e); })
            .on('click', this.options.selectors.overrideButton, _.bind(this.handleOverrideClick, this))
            .on('change', 'select', this.handleChangeVariableSelection);

        this.$addVariable = this.$table.find(this.options.selectors.addRow)
            .on('keydown', 'input:text, select', _.bind(this.handleAdd, this))
            .on('click', 'input:submit', _.bind(this.handleAdd, this));
    }

    VariablesTable.prototype = {
        handleAdd: function (e) {
            if (e.type == 'click' || e.which == jQuery.ui.keyCode.ENTER) {
                e.preventDefault();
                var $inputs = this.$addVariable.find(':input'),
                    key = $inputs.filter('[name="variableKey"]').val(),
                    value = $inputs.filter('[name="variableValue"]').val();

                $(AJS.template.load(this.options.templates.row).fill({
                    id: 'variable_' + key,
                    key: key,
                    value: value
                }).toString()).appendTo(this.$table.find('tbody'));
            }
        },
        handleChangeVariableSelection: function () {
            var $this = $(this),
                $option = $this.find('option:selected'),
                $text = $this.closest('tr').find('input:text'),
                id = $option.val();

            $this.prop('name', 'key_' + id);
            $text.prop('name', 'variable_' + id).val($option.data('currentValue') || '');
        },
        handleDeleteClick: function (el, event) {
            var $this = $(el);
            var href = $this.attr('href');
            var self = this;

            event.preventDefault();

            // show confirmation dialog when deleting a record
            new Bamboo.Widget.Dialog({
                header: AJS.I18n.getText('variables.delete.dialog.header'),
                content: bamboo.feature.variables.deleteConfirmaton(),
                height: 240,
                width: 600,
                buttons: [
                    {
                        id: 'confirm',
                        label: AJS.I18n.getText('global.buttons.confirm'),
                        cssClass: 'aui-button aui-button-primary',
                        params: {
                            self: self,
                            $this: $this,
                            href: href
                        },
                        callback: function (id, params) {
                            if (params.href) {
                                $.post(params.href, { 'bamboo.successReturnMode': 'json', decorator: 'nothing', confirm: true }).done(_.bind(function (result) {
                                    if (params.self.resultStatusMatches(result, 'OK')) {
                                        if (!$('table[id=global-variable-config]').length) {
                                            var variable = {};
                                            variable.key = params.$this.data('variableKey');

                                            if (params.self.options.overriddenVariablesMap[variable.key]) {
                                                var oldPicker = params.$this.closest('tbody').find('.bamboo-single-select');

                                                if (oldPicker) {
                                                    oldPicker.remove();
                                                }

                                                params.self.options.globalNotOverriddenVariables.push(variable);

                                                var variableSelect = new BAMBOO.VariableSingleSelect({
                                                    el: '#variableKey',
                                                    bootstrap: params.self.options.globalNotOverriddenVariables
                                                });

                                                variableSelect.singleSelect.field.$placeholder.attr(
                                                    'placeholder', AJS.I18n.getText('plan.variables.name.placeholder')
                                                );
                                            }
                                        }
                                        params.$this.closest('tr').remove();
                                    }
                                }, params.self));
                            } else {
                                params.$this.closest('tr').remove();
                            }

                            this.dialog.remove();
                        }
                    },
                    {
                        id: 'cancel',
                        label: AJS.I18n.getText('global.buttons.cancel'),
                        type: 'link'
                    }
                ]
            });
        },
        handleOverrideClick: function (e) {
            var $row = $(bamboo.feature.variables.variablesTableRow({
                id: '',
                key: '',
                value: '',
                availableVariables: this.options.availableVariables
            })).appendTo(this.$table.find('tbody'));

            this.handleChangeVariableSelection.call($row[0]);

            e.preventDefault();
        },
        resultStatusMatches: function (result, match) {
            return (result['status'].toUpperCase() == match);
        }
    };

    BAMBOO.VARIABLES.VariablesTable = VariablesTable;

    function VariablesConfigurationForm(options) {
        if (!(this instanceof VariablesConfigurationForm)) {
            return new VariablesConfigurationForm(options);
        }

        var defaults = {
            selectors: {
                form: null,
                table: '.variables-list',
                addRow: '.add-variable',
                deleteRow: '.delete-variable'
            },
            templates: {
                row: null
            },
            classes: {
                active: 'active',
                inactive: 'inactive'
            },
            updateVariableUrl: null,
            overriddenVariablesMap: {},
            globalNotOverriddenVariables: []
        }, that = this;

        this.options = $.extend(true, defaults, options);
        this.cache = {};

        this.$form = $(this.options.selectors.form)
            .on('submit', _.bind(this.handleSubmit, this));
        this.$table = this.$form.find(this.options.selectors.table)
            .on('click', this.options.selectors.deleteRow, function (event) {
                _.bind(that.handleDeleteClick, that)(this, event);
            });

        this.$addVariable = this.$table.find(this.options.selectors.addRow)
            .on('change', 'select', this.handleChangeVariableSelection);

        // global table handler for input <> password fields
        this.$table.on('selected keyup', 'tr td:first-child input', function (event, focusValue) {
            _.bind(that.handleChangeVariableName, this)(that, focusValue);
        });

        BAMBOO.inlineEdit({
            target: '.inline-edit-view',
            $delegator: this.$form,
            submit: _.bind(this.handleInlineSubmit, this),
            focus: _.bind(this.handleInlineFocus, this),
            cancel: _.bind(this.handleInlineCancel, this)
        });
    }

    VariablesConfigurationForm.prototype = new VariablesTable();

    $.extend(true, VariablesConfigurationForm.prototype, {
        clearFormErrors: function () {
            this.$form.find('.error,.aui-message').remove();
        },
        clearFieldErrors: function ($field) {
            $field.nextAll('.error').remove();
        },
        resultFieldErrors: function (fieldErrors, func) {
            for (var fieldName in fieldErrors) {
                if (fieldErrors.hasOwnProperty(fieldName)) {
                    func(fieldName, fieldErrors[fieldName]);
                }
            }
        },
        handleChangeVariableSelection: function () {
            var $this = $(this),
                $option = $this.find('option:selected'),
                $text = $this.closest('tr').find('input:text');

            $text.val($option.data('currentValue') || '');
        },
        handleChangeVariableName: function (self, focusValue) {
            var $this = $(this);
            var $tr = $this.parents('tr:first');
            var id = $tr.attr('id');

            var value = $.trim($this.val()).toLowerCase();
            var hasPassword = (value.indexOf('password') >= 0);

            // initialize cache object
            if (!self.cache[id]) {
                self.cache[id] = {};
            }

            // runs only once per row & then is cached
            if (_.isEmpty(self.cache[id])) {
                self.cache[id].varHasPassword = null;

                // always synchronize input & password field
                self.cache[id].$varInput = $tr.find('.variable-value input')
                    .on('keyup', _.bind(function () {
                        self.cache[id].$varPassword.val(
                            self.cache[id].$varInput.val()
                        );
                    }, $this));

                self.cache[id].$varPassword = $tr.find('.variable-value-password input')
                    .on('keyup', _.bind(function () {
                        self.cache[id].$varInput.val(
                            self.cache[id].$varPassword.val()
                        );
                    }, $this));

                // register toggle for show/hide password field
                self.cache[id].$varToggle = $tr.find('.input-password > button').on('click', _.bind(function (event) {
                    self.cache[id].$varInput.parent().toggleClass('hidden')
                        .find('button').toggleClass('hidden');

                    self.cache[id].$varPassword
                        .parent().toggleClass('hidden');

                    event.preventDefault();
                }, self));
            }

            // input contains 'password' string
            if (hasPassword) {
                self.cache[id].$varInput.parent().addClass('hidden');
                self.cache[id].$varPassword.val(self.cache[id].$varInput.val()).parent().removeClass('hidden');
                self.cache[id].varHasPassword = true;

                if (focusValue) {
                    self.cache[id].$varPassword.focus();
                }
            }
            else if (self.cache[id].varHasPassword !== false) {
                self.cache[id].$varInput.parent().removeClass('hidden').find('button').addClass('hidden');
                self.cache[id].$varPassword.parent().addClass('hidden');
                self.cache[id].varHasPassword = false;

                if (focusValue) {
                    self.cache[id].$varInput.focus();
                }
            }

            // focus variable key
            if (!_.isUndefined(focusValue) && !focusValue) {
                $this.focus();
            }
        },
        handleSubmit: function (e) {
            e.preventDefault();
            this.clearFormErrors();
            var formUrl = this.$form.attr('action'),
                data = this.$addVariable.find(':input').serialize() + '&' + BAMBOO.XsrfUtils.getAtlTokenQueryParam(formUrl) + '&bamboo.successReturnMode=json&decorator=nothing&confirm=true';
            $.post(formUrl, data, _.bind(function (result) {
                if (this.resultStatusMatches(result, 'OK')) {
                    window.location.reload();
                } else if (this.resultStatusMatches(result, 'ERROR')) {
                    var fieldErrors = result['fieldErrors'],
                        errors = result['errors'],
                        $firstError;

                    if (fieldErrors) {
                        this.resultFieldErrors(fieldErrors, _.bind(function (fieldName, fieldError) {
                            this.$addVariable.find(':input[name="' + fieldName + '"]').after(BAMBOO.buildFieldError(fieldError));
                        }, this));
                    }
                    if (errors) {
                        this.$form.prepend(BAMBOO.buildAUIErrorMessage(errors));
                    }
                    $firstError = this.$addVariable.find(':input:visible:enabled.errorField:first').focus();
                    if (!$firstError.length) {
                        this.$addVariable.find(':input:visible:enabled:first').focus();
                    }
                }
            }, this));
        },
        handleInlineSubmit: function ($target, callback) {
            var $loading = $('<span/>', { 'class': 'icon icon-loading' }),
                name = $target.attr('name'),
                id, $key, $value;

            if (name.indexOf('key_') === 0) {
                id = BAMBOO.stripPrefixFromId('key_', name);
                $key = $target;
                $value = this.$form.find(':input[name="value_' + id + '"]');
            }
            else if (name.indexOf('value_') === 0) {
                id = BAMBOO.stripPrefixFromId('value_', name);
                $key = this.$form.find(':input[name="key_' + id + '"]');
                $value = $target;
            }

            if (id && $key && $value) {
                $loading.insertAfter($target[0]);
                this.clearFieldErrors($target);

                $.post(this.options.updateVariableUrl, BAMBOO.XsrfUtils.addXsrfTokenProperty(this.options.updateVariableUrl, {
                        variableId: id,
                        variableKey: $key.val(),
                        variableValue: $value.val(),
                        'bamboo.successReturnMode': 'json',
                        decorator: 'nothing',
                        confirm: true
                    })).done(_.bind(function (result) {
                        var fieldErrors = result.fieldErrors,
                            errors = result.errors,
                            $tr = $target.closest('tr');

                        $loading.remove();

                        if (!$tr.find('.focus').length) {
                            $tr.removeClass('active');
                        }
                        if (this.resultStatusMatches(result, 'OK')) {
                            $target.data('lastValidValue', $target.val());
                            var $div = $("#override_field_" + id);

                            $div.html($(bamboo.feature.variables.overrideText({
                                variable: this.options.overriddenVariablesMap[$key.val()]
                            })));

                            if (!this.$form.find('.focus').length) {
                                this.$addVariable.removeClass(this.options.classes.inactive).find('input').removeAttr('disabled');
                            }

                            if (callback) {
                                callback();
                            }
                        }
                        else if (this.resultStatusMatches(result, 'ERROR')) {
                            if (fieldErrors) {
                                this.resultFieldErrors(fieldErrors, _.bind(function (fieldName, fieldError) {
                                    var $field = (fieldName === 'variableValue' ? $value : $key);
                                    this.clearFieldErrors($field);
                                    $field.after(BAMBOO.buildFieldError(fieldError));
                                }, this));
                            }
                            if (errors) {
                                $key.after(BAMBOO.buildAUIErrorMessage(errors));
                            }
                        }

                        // update variable meta-data
                        $tr.find('td.variable-value-container')
                            .attr('data-variable-key', $key.val());

                    }, this)).fail(function () {
                        $loading.remove();
                        var error = [AJS.I18n.getText("variables.error.server.error")];
                        $key.after(BAMBOO.buildFieldError(error));
                    });
            }
        },
        handleInlineFocus: function ($target) {
            $target.closest('tr').addClass(this.options.classes.active);
            this.$addVariable.addClass(this.options.classes.inactive);
        },
        handleInlineCancel: function ($target) {
            this.clearFieldErrors($target.closest('tr').removeClass(this.options.classes.active).end());
            this.$addVariable.removeClass(this.options.classes.inactive);
        }
    });

    BAMBOO.VARIABLES.VariablesConfigurationForm = VariablesConfigurationForm;
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));