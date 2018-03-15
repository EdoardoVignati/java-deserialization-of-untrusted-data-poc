[#import "/fragments/labels/labels.ftl" as lb /]

<div class="label-edit-mode">[@lb.showLabelsWithNone immutablePlan resultsSummary false /]</div>
<div class="label-view-mode">[@lb.showLabelsWithNone immutablePlan resultsSummary true false /]</div>