(function ($)
{
    /**
     * Creates a Cron builder on the page for a specific field.  The builder makes up two form components, the text display
     * (showing the pretty cron expression) and a hidden field (with the raw cron expression)
     * The value to be submitted can only be updated via the cron buidler dialog.
     *
     * USAGE
     * ------
     * Call against display field e.g:
     *
     *   AJS.$("#displayFieldId").cronBuilder({});
     *
     * Arguments (all required)
     *
     * opts {
     *  hiddenFieldSelector:    selector for the field that will be submited as part of the form (usually a hidden field)
     *  dialogTrigger:          html for the cron builder trigger
     *  eventNamespace:         unique namespace for this dialog click event
     *  contextPath:            context path for bamboo instance (used when generating urls;)
     *  dialogSubmitButtonText: text for the dialog submit button
     *  dialogHeadingText:      text for the dialog heading
     * }
     });
     */
    $.fn.cronBuilder = function (opts)
    {
        return this.each(function ()
                         {
                             var $this = $(this),
                                     initialCron = $(opts.hiddenFieldSelector).val(),
                                     $dialogTrigger = $(opts.dialogTrigger),

                                     addCronExpression = function (result)
                                     {
                                         //update fields
                                         $(opts.hiddenFieldSelector).val(result.cronExpression);
                                         $this.text(result.prettyCronExpression);

                                         // need to remove the old dialog and reattach with the new cron expression as the arg.
                                         $($dialogTrigger).unbind("click." + opts.eventNamespace);
                                         attachCronDialog(result.cronExpression);
                                     },

                                     attachCronDialog = function (cron)
                                     {
                                         simpleDialogForm($dialogTrigger, opts.contextPath + "/ajax/editCronExpression.action?cronExpression=" + encodeURIComponent(cron),
                                                          620, 480, opts.dialogSubmitButtonText, "ajax", addCronExpression, null, opts.dialogHeadingText, opts.eventNamespace);
                                     };

                             // generate pretty string
                             $.get(opts.contextPath + "/ajax/getPrettyCronExpression.action?cronExpression=" + encodeURIComponent(initialCron), function (result)
                             {
                                 $this.text(result.prettyCronExpression);
                             });

                             // add the link to the right spot - needed cause it avoids playing with the form templates.
                             $dialogTrigger.insertAfter($this);

                             attachCronDialog(initialCron);
                         });

    };

    /**
     * Replaces an element containing a cron expression with the pretty version of that expression.
     *
     * Usage:  e.g. AJS.$("#element").cronBuilder(${req.contextPath});
     *
     */
    $.fn.cronDisplay = function (contextPath)
    {
        return this.each(function ()
                         {
                             var $this = $(this),
                                     cron = $this.text();

                             // generate pretty string
                             $.get(contextPath + "/ajax/getPrettyCronExpression.action?cronExpression=" + encodeURIComponent(cron), function (result)
                             {
                                 $this.text(result.prettyCronExpression);
                             });
                         });
    };
})(jQuery);