BAMBOO.MODEL.DeploymentVersionStatus = Brace.Model.extend({
                                                              namesAttributes: {
                                                                  versionState: 'string',
                                                                  userName: 'string',
                                                                  displayName: 'string',
                                                                  gravatarUrl: 'string',
                                                                  creationDate: 'date'
                                                              }
                                                          });

BAMBOO.MODEL.Artifact = Brace.Model.extend({
                                            namedAttributes: {
                                                id: 'number',
                                                label: 'string',
                                                size: 'number',
                                                isSharedArtifact: 'boolean',
                                                isGloballyStored: 'boolean',
                                                linkType: 'string',
                                                planResultKey: BAMBOO.MODEL.ResultKey
                                            }
                                           });

BAMBOO.MODEL.DeploymentVersionItem = Brace.Model.extend({
                                                            namedAttributes: {
                                                                name: 'string',
                                                                planResultKey: BAMBOO.MODEL.ResultKey,
                                                                type: 'string',
                                                                label: 'string',
                                                                location: 'string',
                                                                copyPattern: 'string',
                                                                size: 'number',
                                                                artifact: BAMBOO.MODEL.Artifact
                                                            }
                                                        });

BAMBOO.MODEL.DeploymentVersionVariableContext = Brace.Model.extend({
                                                                        namedAttributes: {
                                                                            key: 'string',
                                                                            value: 'string',
                                                                            variableType: 'string',
                                                                            isPassword: 'boolean'
                                                                        }
                                                                   });
BAMBOO.MODEL.DeploymentVersion = Brace.Model.extend({
                                                        namedAttributes: {
                                                            name: 'string',
                                                            planBranchName: 'string',
                                                            creationDate: Date,
                                                            creatorUserName: 'string',
                                                            creatorGravatarUrl: 'string',
                                                            creatorDisplayName: 'string',
                                                            planResultKey: BAMBOO.MODEL.ResultKey,
                                                            items: Brace.Collection.extend({
                                                                                               model: BAMBOO.MODEL.DeploymentVersionItem
                                                                                           }),
                                                            versionStatus: BAMBOO.MODEL.DeploymentVersionStatus,
                                                            variableContext: Brace.Collection.extend({
                                                                                                        model: BAMBOO.MODEL.DeploymentVersionVariableContext
                                                                                                    }),
                                                            operations:  BAMBOO.MODEL.Operations
                                                        }
                                                    });
