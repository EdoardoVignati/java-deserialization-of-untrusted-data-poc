[#-- ========================================================================================== @nc.showRestartCount --]
[#macro showRestartCount resultSummary]
[#if resultSummary.restartCount > 0] (rerun [#if resultSummary.restartCount > 1]${resultSummary.restartCount} times[#else]once[/#if])[/#if][#t]
[/#macro]

