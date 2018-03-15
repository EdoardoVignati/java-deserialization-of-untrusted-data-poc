AJS.test.require('bamboo.web.resources:plan-status-history');

module('BAMBOO.PlanStatusHistory.Navigator#scheduleNextUpdate');

test('is called on init', function () {
    var Navigator = BAMBOO.PlanStatusHistory.Navigator.extend({
        scheduleNextUpdate: sinon.spy()
    });
    var nav = new Navigator();
    ok(nav.scheduleNextUpdate.calledOnce, 'should be called on init');
});

module('BAMBOO.PlanStatusHistory.Navigator#render', {
    setup: function () {
        var Navigator = BAMBOO.PlanStatusHistory.Navigator.extend({
            scheduleNextUpdate: function () {}
        });
        this.navigator = new Navigator({
            el: jQuery('#qunit-fixture')
        });
        this.navigator.render = sinon.spy(this.navigator, 'render');
    },
    teardown: function () {
        this.navigator.render.restore();
    }
});

test('is called when #updateReturnUrls is called', function () {
    this.navigator.updateReturnUrls(null, '');
    ok(this.navigator.render.calledOnce, 'should render when updateReturnUrls is called');
});