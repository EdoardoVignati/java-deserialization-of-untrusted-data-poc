<errors>
    [#list actionErrors as error]
    <error>${error?xml}</error>
    [/#list]
</errors>