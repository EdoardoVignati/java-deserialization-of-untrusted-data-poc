[#--
    Requirements:

    buildName  scalar which will hold plan key
    subBuildKey   scalar which will hold plan name
--]

[@ww.textfield labelKey='job.name' name='buildName' id='buildName' required='true' /]
[@ww.textfield labelKey='job.key' name='subBuildKey' fromField='buildName' template='keyGenerator' /]
[@ww.textfield labelKey='job.description' name='buildDescription' required='false'/]



