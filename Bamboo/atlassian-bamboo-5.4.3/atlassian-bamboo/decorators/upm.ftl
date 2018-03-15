[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator context="upm"]
[#assign warningTitle = "serverstate.upm.warning.title"]
[#assign warningMessage = "serverstate.upm.warning"]
[#include "serverStatusControl.ftl" /]
[/@decorators.displayAdminDecorator]