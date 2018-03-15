[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayAdminDecorator]
    ${body}
[/@decorators.displayAdminDecorator]