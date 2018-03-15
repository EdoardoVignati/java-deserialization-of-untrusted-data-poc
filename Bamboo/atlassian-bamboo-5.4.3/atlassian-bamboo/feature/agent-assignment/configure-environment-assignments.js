BAMBOO.EnvironmentAssignmentsSingleSelect = Backbone.View.extend({
   initialize: function (options) {
       options || (options = {});
       this.singleSelect = new BAMBOO.SingleSelect({
           el: this.$el,
           bootstrap: options.bootstrap || [],
           maxResults: options.maxResults || 5,
           matcher: _.bind(this.matcher, this),
           resultItemTemplate: bamboo.feature.agent.assignment.environmentItemResult
       });
       this.singleSelect.on('selected', this.handleSelection, this);
   },
   containsMatch: function (str, find) {
       return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
   },
   matcher: function (assignment, query) {
       var matches = false;
       matches = matches || this.containsMatch(assignment.get('name'), query);
       return matches;
   },
   handleSelection: function (model) {
       this.trigger('selected', model);
   }
});

BAMBOO.EnvironmentAssignmentsSelectedList = BAMBOO.SelectedList.extend({
   initialize: function (options) {
       this.capabilitiesTooltipUrl = options.capabilitiesTooltipUrl;
       BAMBOO.EnvironmentAssignmentsSelectedList.__super__.initialize.apply(this, arguments);
   },
   render: function (addedItem) {
       this.$el.html(bamboo.feature.agent.assignment.environmentList({environments: this.model.collection.toJSON(),
                                                                      addedEnvironment: addedItem ? addedItem.attributes : null,
                                                                      capabilitiesTooltipUrl: this.capabilitiesTooltipUrl }));
   }
});

BAMBOO.EnvironmentAssignmentMultiSelect = Backbone.View.extend({
     initialize: function (options) {
         this.assignmentSelect = new BAMBOO.EnvironmentAssignmentsSingleSelect({
             el: this.$el,
             bootstrap: options.bootstrap || [],
             maxResults: 10
         });
         this.assignmentSelect.on('selected', this.handleSelection, this);
         this.selectedAssignments = new BAMBOO.EnvironmentAssignmentsSelectedList({
             el: options.selectedAssignmentsEl,
             bootstrap: options.selectedAssignments || [],
             capabilitiesTooltipUrl: options.capabilitiesTooltipUrl
         });
     },
     handleSelection: function (model) {
         this.selectedAssignments.addItem(model);
         this.assignmentSelect.singleSelect.setValue('');
     }
 });

