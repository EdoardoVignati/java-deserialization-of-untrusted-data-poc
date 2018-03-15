BAMBOO.BuildStatistics = (function ($) {
    var colours = {
            fail: '#a00',
            success: '#393'
        };

    function generatePieData(successRate, failureRate) {
        function sliceWithinBounds(slice) {
            var min = 0.125, /* small enough so that it only renders a white line at the size we have the graph */
                max = 100 - min;

            return Math.max(Math.min(slice, max), min);
        }
        function buildSuccessSeriesConfig(label, data, colour) {
            return {
                label: label,
                data: sliceWithinBounds(data),
                color: colour
            }
        }

        return [
            buildSuccessSeriesConfig('Successful', successRate, colours.success),
            buildSuccessSeriesConfig('Failed', failureRate, colours.fail)
        ];
    }
    function buildNumberSeriesConfig(data, colour) {
        return {
            data: data,
            bars: { show: true, fill: 1, lineWidth: 0 },
            color: colour,
            shadowSize: 0
        }
    }

    return {
        init: function () {
            $(function () {
                var $buildSuccessChart = $('#build-success-chart'),
                    $buildNumberChart = $('#build-number-chart'),
                    buildNumberResults = $buildNumberChart.data('json')['results'];

                $.plot($buildSuccessChart, generatePieData($buildSuccessChart.data('successful'), $buildSuccessChart.data('failed')), {
                    series: {
                        pie: {
                            show: true,
                            radius: 1,
                            label: { show: false }
                        }
                    },
                    legend: { show: false }
                });
                $.plot($buildNumberChart, [ buildNumberSeriesConfig(buildNumberResults['failed'], colours.fail), buildNumberSeriesConfig(buildNumberResults['successful'], colours.success) ], {
                    xaxis: { show: false },
                    yaxis: { show: false },
                    grid: { show: false }
                });
            });
        }
    };
})(jQuery);