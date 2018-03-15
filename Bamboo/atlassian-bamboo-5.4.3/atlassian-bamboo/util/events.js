window.BAMBOO = (window.BAMBOO || {});
BAMBOO.EventBus = new Backbone.Wreqr.EventAggregator();

BAMBOO.EventBusMixin = {

    onEvent: function(key, callback, object) {
        var handler = function(value, callback, object) {
            BAMBOO.EventBus.on(value,
                _.bind(callback, object)
            );
        };

        if (_.isArray(key)) {
            _.each(key, _.bind(function(value) {
                handler(value, callback, object || this);
            }, this));
        }
        else {
            handler(key, callback, object || this);
        }
    },

    triggerEvent: function(key) {
        BAMBOO.EventBus.trigger.apply(BAMBOO.EventBus,
            [key, this].concat(
                Array.prototype.slice.call(arguments, 1)
            )
        );
    },

    proxyEvents: function(key, events, object, bindMethod) {
        var scope = object || this, self = this;
        var proxyMethod = (bindMethod) ? scope[bindMethod] : scope.on;

        _.each(events, function(event) {
            proxyMethod.apply(scope, [event, function() {
                self.triggerEvent(
                    [key, event].join(':'), scope
                );
            }]);
        });
    }

};