window.onload = function ()
{
    $('frameHolder').onload = preparePage;
    Effect.Appear('commands', {
        afterFinish: function()
            {
//              $('commands').style.overflow = 'auto';
             }});
    Effect.BlindDown('frameHolderHolder');
    preparePage();
}

var eventsToListen = new Array();

function addEventsToListen(tagName, eventName, alternativeHandlerMethod)
{
    var eventToListen = new Object();
	eventToListen.tagName = tagName;
	eventToListen.eventName = eventName;
    if (alternativeHandlerMethod)
    {
        eventToListen.alternativeHandlerMethod = alternativeHandlerMethod;
    }
    
    eventsToListen[eventsToListen.length] = eventToListen;
}

function preparePage(oEvent)
{

    debug('Preparing Page');
    $('currentUrl').value = idoc().location;
    for (j = 0; j < eventsToListen.length ; j++)
    {
        var anchors = idoc().getElementsByTagName(eventsToListen[j].tagName);
        for (i = 0; i < anchors.length ; i++)
        {
            if (eventsToListen[j].alternativeHandlerMethod)
            {
                Event.observe(anchors[i], eventsToListen[j].eventName, eventsToListen[j].alternativeHandlerMethod, false);
            }
            else
            {
                Event.observe(anchors[i], eventsToListen[j].eventName, handleNewEvent, false);
    //        anchors[i].onclick = handleNewEvent;
            }
        }
    }
}


function idoc()
{
    return frames['frameHolder'].document;
}

function ifr()
{
    return frames['frameHolder'];
}

function loadPage()
{
    $('frameHolder').src = $('currentUrl').value;
    return false;
}

function handleNewEvent(e)
{
    var o = Event.element(e);
    var url = 'http://localhost:8080/jira/secure/FuncTestWriterAddEvent.jspa';
    var pars = 'decorator=none';
    if (o.id)
    {
        pars = pars + '&elementId=' + o.id;
    }

    pars = pars + '&tagName=' + o.nodeName ;
    pars = pars + '&eventType=' + e.type ;
    pars = pars + '&innerHtml=' + o.innerHTML;

    info('Params: ' + pars);
    callAjax(url, pars);

    return true;
}


function addResponseToList(originalRequest)
{
    info('Response: ' + originalRequest.responseText)
    addToList(originalRequest.responseText);
}

function addToList(message)
{
    new Insertion.Bottom('commandsList', "<li><a class='deleteLink' href='#' onclick='removeListItem(this);return false;'>del</a>" + message + "</li>")
//    Sortable.create("commandsList", {constraint:false});
    $(commandsText).style.display = 'none';
}

function callAjax(url, pars)
{
    var hiddenIframe = frames['hiddenIFrame'];
    $('hiddenIFrame').onload = handleDodgyAjax;
    hiddenIframe.window.location = url + '?' + pars;
    // debug(url + '?' + pars);

/*
    new Ajax.Request(
                url,
                {method: 'get', parameters: pars, onComplete: addResponseToList}
                );
*/
}

function handleDodgyAjax()
{
    var hiddenIframe = frames['hiddenIFrame'];
    var data = hiddenIframe.document.getElementById('data');
    if (data && data.innerHTML && data.innerHTML != '')
    {
        info('Response: ' + data.innerHTML);
        addToList(data.innerHTML);
    }
    hiddenIframe.onload = null;
}

function saveUrl() 
{
    saveCookie('currentUrl', $('currentUrl').value);
}

function loadUrl() 
{
    var url = readCookie('currentUrl');
    if (url && url != '')
    {
        $('currentUrl').value = url;
        loadPage();
    }
}

function getSelectedLabel(selectObject)
{
    var selectedValues = '';
    for (var i = 0; i < selectObject.length; i++)
    {
        if(selectObject.options[i].selected)
        {
            return trimLine(selectObject.options[i].innerHTML);
        }
    }

    return selectedValues;
}

function trimLine(str)
{
    return str.replace(/^[\s|\n]+|[\s|\n]+$/, ''); 
}


function getSel()
{
	var txt = '';
	txt = idoc().getSelection();
    return txt;
}

function assertPresent() 
{
    var t = getSel();
    if (t && t != '')
        addToList("assertTextPresent(\""+t+"\");");
}

var beforeTxt = '';
function assertBefore() 
{
    var t = getSel();
    if (t && t != '')
    {
        if (beforeTxt != '')
        {
            addToList("assertTextPresentBeforeText(\""+beforeTxt+"\", \""+t+"\");");
            beforeTxt = '';
            $('assertBefore').innerHTML = 'Assert Before...';
        }
        else
        {
            beforeTxt = t;
            $('assertBefore').innerHTML = 'Assert after \"' + beforeTxt + '\"';
        }
    }
}

function displayAllIssues() 
{
    var searchBox = idoc().getElementById('quickSearchInput');
    searchBox.value = '';
    searchBox.form.submit();
    addToList("displayAllIssues();");
}

function removeListItem(o) 
{
    var parentLi = findParentNodeOfTag('LI', o);
    Effect.Puff(parentLi, {
        afterFinish: function()
            {
                parentLi.parentNode.removeChild(parentLi);
             }});
                parentLi.parentNode.removeChild(parentLi);
}

function removeAllCommands()
{
    var lis = $('commands').getElementsByTagName('LI');
    while(lis.length)
    // for (i=0;i<lis.length;i++)
    {
//        Effect.Puff(lis[i], {
//        afterFinish: function()
//            {
//                lis[i].parentNode.removeChild(lis[i]);
//             }});
        lis[0].parentNode.removeChild(lis[0]);
    }
}

function findParentNodeOfTag(nodeName, o) 
{
    var parentNode = o.parentNode;
    while (parentNode) 
    {
        if (parentNode.nodeName == nodeName)
            return parentNode;
        else
            parentNode = parentNode.parentNode;
    }

    return;
}

function extractCommands() 
{
    $('commandsText').style.display = '';

    var commandsLis = $('commandsList').getElementsByTagName('LI');
    $('commandsText').value = '';
    for (i=0;i<commandsLis.length;i++)
    {
        $('commandsText').value = $('commandsText').value + commandsLis[i].lastChild.data + '\n';
    }

    $('commandsText').select();
    $('commandsText').focus();
}

function debug(s)
{
    // Do nudda
}
