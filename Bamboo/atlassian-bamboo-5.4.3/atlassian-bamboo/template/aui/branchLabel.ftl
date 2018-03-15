<div id="${parameters.containerId}"></div>

<script>
    (function($) {
        new Bamboo.Feature.BranchLabel({
            el: $('#${parameters.containerId}')
        });
    }(AJS.$));
</script>