[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.TestOgnlEscaping" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.TestOgnlEscaping" --]

<html>
<head>
    <meta name="decorator" content="adminpage">
</head>
<body>

    ExploitStringValue [@ww.textfield name='name' value=exploitString/]
    ExploitObjectValue [@ww.textfield name='name' value=exploitObject/]
    ExploitStringName [@ww.textfield name=exploitString/]
    ExploitObjectName [@ww.textfield name=exploitObject/]

    ExploitStringValue [@ww.textfield name='name' value=ognlStaticCall/]
    ExploitObjectValue [@ww.textfield name='name' value=ognlStaticCallObject/]
    ExploitStringName [@ww.textfield name=ognlStaticCall/]
    ExploitObjectName [@ww.textfield name=ognlStaticCallObject/]

    <br/>

    ExploitStringQuotedValue [@ww.textfield name='name' value='exploitString'/]
    ExploitObjectQuotedValue [@ww.textfield name='name' value='exploitObject'/]
    ExploitStringQuotedValue [@ww.textfield name='name' value='ognlStaticCall'/]
    ExploitObjectQuotedValue [@ww.textfield name='name' value='ognlStaticCallObject'/]


    ExploitStringQuotedName [@ww.textfield name='exploitString'/]
    ExploitObjectQuotedName [@ww.textfield name='exploitObject'/]
    ExploitStringQuotedName [@ww.textfield name='ognlStaticCall'/]
    ExploitObjectQuotedName [@ww.textfield name='ognlStaticCallObject'/]

    <br/>



    ExploitStringValue [@ww.select name='name' value=exploitString list=exploits/]
    ExploitObjectValue [@ww.select name='name' value=exploitObject list=exploits/]
    ExploitStringName [@ww.select name=exploitString list=exploits/]
    ExploitObjectName [@ww.select name=exploitObject list=exploits/]

    ExploitStringValue [@ww.select name='name' value=ognlStaticCall list=exploits/]
    ExploitObjectValue [@ww.select name='name' value=ognlStaticCallObject list=exploits/]
    ExploitStringName [@ww.select name=ognlStaticCall list=exploits/]
    ExploitObjectName [@ww.select name=ognlStaticCallObject list=exploits/]

    <br/>

    ExploitStringQuotedValue [@ww.select name='name' value='exploitString' list=exploits/]
    ExploitObjectQuotedValue [@ww.select name='name' value='exploitObject' list=exploits/]
    ExploitStringQuotedValue [@ww.select name='name' value='ognlStaticCall' list=exploits/]
    ExploitObjectQuotedValue [@ww.select name='name' value='ognlStaticCallObject' list=exploits/]


    ExploitStringQuotedName [@ww.select name='exploitString' list=exploits/]
    ExploitObjectQuotedName [@ww.select name='exploitObject' list=exploits/]
    ExploitStringQuotedName [@ww.select name='ognlStaticCall' list=exploits/]
    ExploitObjectQuotedName [@ww.select name='ognlStaticCallObject' list=exploits/]
</body>
</html>
