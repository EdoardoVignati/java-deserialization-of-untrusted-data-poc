BAMBOO.MODEL.DeploymentEnvironment = Brace.Model.extend({
      namedAttributes: {
          name: 'string',
          deploymentProjectId: 'number',
          position: 'number',
          operations:  BAMBOO.MODEL.Operations
      }
});

BAMBOO.MODEL.DeploymentEnvironmentStatus = Brace.Model.extend({
    namedAttributes: {
        deploymentResult: BAMBOO.MODEL.DeploymentResult,
        environment: BAMBOO.MODEL.DeploymentEnvironment
    }
});