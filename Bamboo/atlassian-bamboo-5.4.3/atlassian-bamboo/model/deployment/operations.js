BAMBOO.MODEL.Operations = Brace.Model.extend({
                                                 namedAttributes: {
                                                     canView: 'boolean',
                                                     canEdit: 'boolean',
                                                     canDelete: 'boolean',
                                                     allowedToExecute: 'boolean',
                                                     canExecute: 'boolean',
                                                     cantExecuteReason: 'string',
                                                     allowedToCreateVersion: 'boolean',
                                                     allowedToSetVersionStatus: 'boolean'
                                                 }
                                             });