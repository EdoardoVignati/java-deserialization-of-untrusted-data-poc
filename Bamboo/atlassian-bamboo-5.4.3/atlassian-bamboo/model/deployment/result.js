BAMBOO.MODEL.DeploymentResult = Brace.Model.extend({
    namedAttributes: {
        deploymentVersion: BAMBOO.MODEL.DeploymentVersion,
        deploymentVersionName: 'string',
        lifeCycleState: 'string',
        deploymentState: 'string',
        startedDate: Date,
        queuedDate: Date,
        executedDate: Date,
        finishedDate: Date,
        reasonSummary: 'string',
        key: BAMBOO.MODEL.ResultKey,
        agent: BAMBOO.MODEL.Agent,
        logEntries: Brace.Collection.extend({
            model: BAMBOO.MODEL.logEntry
        }),
        operations: BAMBOO.MODEL.Operations
    }
});

BAMBOO.MODEL.Agent = Brace.Model.extend({
    namedAttributes: {
        name: 'string',
        type: 'string'
    }
});

BAMBOO.MODEL.logEntry = Brace.Model.extend({
    namedAttributes: {
       log: 'string',
       unstyledLog: 'string',
       date: Date,
       formattedDate: 'string'
    }
});