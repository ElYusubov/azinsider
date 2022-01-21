@description('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string = 'Defender for Cloud Coverage'

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string = 'workbook'

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string = 'Azure Security Center'

@description('The unique guid for this workbook instance')
param workbookId string = newGuid()

var workbookContent = {
  version: 'Notebook/1.0'
  items: [
    {
      type: 1
      content: {
        json: '## Defender for Cloud Coverage Dashboard\nThis workbook has been created to provide a consolidated view of Defender for Cloud Coverage across all selected subscriptions.'
      }
      name: 'text - 3'
    }
    {
      type: 1
      content: {
        json: '<svg viewBox="0 0 19 19" width="20" class="fxt-escapeShadow" role="presentation" focusable="false" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true"><g><path fill="#1b93eb" d="M16.82 8.886c0 4.81-5.752 8.574-7.006 9.411a.477.477 0 01-.523 0C8.036 17.565 2.18 13.7 2.18 8.886V3.135a.451.451 0 01.42-.419C7.2 2.612 6.154.625 9.5.625s2.3 1.987 6.8 2.091a.479.479 0 01.523.419z"></path><path fill="url(#0024423711759027356)" d="M16.192 8.99c0 4.392-5.333 7.947-6.483 8.575a.319.319 0 01-.418 0c-1.15-.732-6.483-4.183-6.483-8.575V3.762a.575.575 0 01.313-.523C7.2 3.135 6.258 1.357 9.4 1.357s2.2 1.882 6.274 1.882a.45.45 0 01.419.418z"></path><path d="M9.219 5.378a.313.313 0 01.562 0l.875 1.772a.314.314 0 00.236.172l1.957.284a.314.314 0 01.174.535l-1.416 1.38a.312.312 0 00-.09.278l.334 1.949a.313.313 0 01-.455.33l-1.75-.92a.314.314 0 00-.292 0l-1.75.92a.313.313 0 01-.455-.33L7.483 9.8a.312.312 0 00-.09-.278L5.977 8.141a.314.314 0 01.174-.535l1.957-.284a.314.314 0 00.236-.172z" class="msportalfx-svg-c01"></path></g></svg>&nbsp;<span style="font-family: Open Sans; font-weight: 620; font-size: 14px;font-style: bold;margin:-10px 0px 0px 0px;position: relative;top:-3px;left:-4px;"> Please take the time to answer a quick survey. To submit your feedback,\n</span>[<span style="font-family: Open Sans; font-weight: 620; font-size: 14px;font-style: bold;margin:-10px 0px 0px 0px;position: relative;top:-3px;left:-4px;"> click here. </span>](https://aka.ms/mdfcsurveycoverageworkbook)'
      }
      name: 'survey'
    }
    {
      type: 9
      content: {
        version: 'KqlParameterItem/1.0'
        parameters: [
          {
            id: '2896eab7-cf93-43e5-bc43-92eba7c6bd80'
            version: 'KqlParameterItem/1.0'
            name: 'Subscriptions'
            type: 6
            description: 'Please select one or several subscriptions to allow the workbook to show Defender for Cloud coverage details.'
            isRequired: true
            multiSelect: true
            quote: '\''
            delimiter: ','
            typeSettings: {
              additionalResourceOptions: [
                'value::all'
              ]
              includeAll: true
              showDefault: false
            }
            timeContext: {
              durationMs: 86400000
            }
          }
        ]
        style: 'pills'
        queryType: 0
        resourceType: 'microsoft.operationalinsights/workspaces'
      }
      name: 'parameters - 1'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Microsoft Defender for Cloud coverage by subscriptions\nThis table provides an overview of all selected subscriptions and their corresponding Defender status per plan.'
            }
            name: 'text - 1'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'securityresources\n| where type =~ "microsoft.security/pricings"\n| extend planSet = pack(name, pricingTier = properties.pricingTier)\n| summarize defenderPlans = make_bag(planSet) by subscriptionId\n| project subscriptionId,\n    AppServices = defenderPlans.AppServices,\n    Arm = defenderPlans.Arm,\n    ContainerRegistry = defenderPlans.ContainerRegistry,\n    Containers = defenderPlans.Containers,\n    DNS = defenderPlans.Dns,\n    KeyVaults = defenderPlans.KeyVaults,\n    KubernetesService = defenderPlans.KubernetesService,\n    OpenSourceRelationalDatabases = defenderPlans.OpenSourceRelationalDatabases,\n    StorageAccounts = defenderPlans.StorageAccounts,\n    SqlServerVirtualMachines = defenderPlans.SqlServerVirtualMachines,\n    SqlServers = defenderPlans.SqlServers,\n    VirtualMachines = defenderPlans.VirtualMachines'
              size: 3
              showAnalytics: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscriptions}'
              ]
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'subscriptionId'
                    formatter: 15
                    formatOptions: {
                      linkTarget: 'Resource'
                      showIcon: true
                      customColumnWidthSetting: '50ch'
                    }
                  }
                  {
                    columnMatch: 'AppServices'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Arm'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'ContainerRegistry'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Containers'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'DNS'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'KeyVaults'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'KubernetesService'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'OpenSourceRelationalDatabases'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'StorageAccounts'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'SqlServerVirtualMachines'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'SqlServers'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'VirtualMachines'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Standard'
                          representation: 'green'
                          text: 'on'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'off'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'subscriptionName'
                    formatter: 5
                    formatOptions: {
                      linkTarget: 'Resource'
                    }
                  }
                ]
                rowLimit: 10000
                sortBy: [
                  {
                    itemKey: '$gen_thresholds_ContainerRegistry_3'
                    sortOrder: 2
                  }
                ]
                labelSettings: [
                  {
                    columnId: 'subscriptionId'
                    label: 'Subscription Name'
                  }
                  {
                    columnId: 'AppServices'
                    label: 'App Services'
                  }
                  {
                    columnId: 'Arm'
                    label: 'Resource Manager'
                  }
                  {
                    columnId: 'ContainerRegistry'
                    label: 'Container Registry (deprecated)'
                  }
                  {
                    columnId: 'Containers'
                    label: 'Containers'
                  }
                  {
                    columnId: 'DNS'
                    label: 'DNS'
                  }
                  {
                    columnId: 'KeyVaults'
                    label: 'Key Vaults'
                  }
                  {
                    columnId: 'KubernetesService'
                    label: 'K8s (deprecated)'
                  }
                  {
                    columnId: 'OpenSourceRelationalDatabases'
                    label: 'Open-source relational DBs'
                  }
                  {
                    columnId: 'StorageAccounts'
                    label: 'Storage'
                  }
                  {
                    columnId: 'SqlServerVirtualMachines'
                    label: 'SQL Server on machines'
                  }
                  {
                    columnId: 'SqlServers'
                    label: 'SQL'
                  }
                  {
                    columnId: 'VirtualMachines'
                    label: 'Servers'
                  }
                ]
              }
              sortBy: [
                {
                  itemKey: '$gen_thresholds_ContainerRegistry_3'
                  sortOrder: 2
                }
              ]
            }
            name: 'query - 4'
          }
        ]
      }
      name: 'Overview'
    }
  ]
  isLocked: false
  fallbackResourceIds: [
    'Azure Security Center'
  ]
  fromTemplateId: 'asc-DefenderForCloudCostEstimation'
}

resource workbookId_resource 'microsoft.insights/workbooks@2021-03-08' = {
  name: workbookId
  location: resourceGroup().location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: string(workbookContent)
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
  dependsOn: []
}

output workbookId string = workbookId_resource.id
