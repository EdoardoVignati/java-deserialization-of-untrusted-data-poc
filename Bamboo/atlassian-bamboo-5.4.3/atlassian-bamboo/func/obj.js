function handleInput(e) 
{
    var o = Event.element(e);
    debug('o:' + o.id);
    debug('target:' + e.target.id);
    if (o.type == 'checkbox')
    {
        addToList("checkCheckbox(\""+ o.name + "\", \""+ o.value+"\");");
    }
    else if (o.type == 'radio')
    {
        addToList("clickRadioOption(\"" + o.name + "\", \"" + o.value + "\");");
    }
    else if (o.type == 'text')
    {
        // normal input
        addToList("setTextField(\""+ o.name + "\", \""+ o.value+"\");");
    }
    return true;
}

function handleSubmit(e) 
{
    var o = Event.element(e);
    if (o.type == 'submit')
    {
        addToList("submit(\""+ o.name + "\");");
    }
    return true;
}

function handleSelect(e) 
{
    var o = Event.element(e);
    var s = getSelectedLabel(o) + '';
    addToList("selectOption(\""+ o.name + "\", \""+ s + "\");");
    warn('handleselect');
    return true;
}

function handleAnchor(e) 
{
    var o = Event.element(e);
    if (o.id)
    {
        addToList("clickLink(\""+ o.id + "\");");
    }
    else
    {
        addToList("clickLinkWithText(\""+ o.innerHTML + "\");");
    }

    return true;
}

function handleFormSubmit(e) 
{
    var o = Event.element(e);
    if (!o.action)
        o = o.form;
    addToList("setWorkingForm(\""+ o.name + "\");");
    addToList("submit();");
    return true;
}

