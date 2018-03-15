[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator]
[#assign warningTitle = "serverstate.export.warning.title"]
[#assign warningMessage = "serverstate.export.warning"]
[#include "serverStatusControl.ftl" /]
[/@decorators.displayAdminDecorator]