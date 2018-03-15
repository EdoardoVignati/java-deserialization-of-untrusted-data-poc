[@ui.bambooSection titleKey="buildExpiry.enable.type"]

    [@ww.checkbox id='custom_buildExpiryConfig_result'
    name='custom.buildExpiryConfig.expiryTypeResult'
    labelKey='buildExpiry.enable.type.result' /]

    [@ww.checkbox name='custom.buildExpiryConfig.expiryTypeArtifact'
    labelKey='buildExpiry.enable.type.artifact'
    cssClass='buildExpiryPartial' /]
    [@ww.checkbox name='custom.buildExpiryConfig.expiryTypeBuildLog'
    labelKey='buildExpiry.enable.type.buildlog'
    cssClass='buildExpiryPartial'/]
[/@ui.bambooSection]

[@ui.bambooSection titleKey="buildExpiry.enable.criteria"]
    [#assign periodValue]${stack.findString('custom.buildExpiryConfig.period')!'days'}[/#assign]
    [@ww.textfield name='custom.buildExpiryConfig.duration' labelKey='buildExpiry.enable.timing' template='periodPicker' periodField='custom.buildExpiryConfig.period' periodValue=periodValue/]
    [@ww.textfield name='custom.buildExpiryConfig.buildsToKeep' labelKey='buildExpiry.enable.builds' /]
    [@ww.checkbox name='custom.buildExpiryConfig.excludeLabels' labelKey='buildExpiry.enable.excludeLabels' toggle='true' /]
    [@ui.bambooSection dependsOn='custom.buildExpiryConfig.excludeLabels' showOn='true']
        [@ww.textfield name='custom.buildExpiryConfig.labelsToKeep' labelKey='buildExpiry.enable.excludeLabels.labels' /]
    [/@ui.bambooSection]
[/@ui.bambooSection]

<script type="text/javascript">
    AJS.$(function ()
          {
              var $parent = AJS.$('#custom_buildExpiryConfig_result'),
                      $children = AJS.$(':input.buildExpiryPartial');
              $parent.click(function ()
                            {
                                checkboxTree.cascadeToChildren($parent, $children, checkboxTree.DISABLE_CHILDREN_ON_PARENT_CHECKED);
                            });
              if ($parent.is(":checked"))
              {
                  checkboxTree.cascadeToChildren($parent, $children, checkboxTree.DISABLE_CHILDREN_ON_PARENT_CHECKED);
              }
          });
</script>
