resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "DATATABLE_ID" = {
                "type" = "string"
            },
            "KEY_VALUE" = {
                "type" = "string"
            }
        },
        "title" = "Get Value from Datatable",
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {},
        "title" = "Row",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/flows/datatables/$${input.DATATABLE_ID}/rows/$${input.KEY_VALUE.replace(' ', '%20')}?showbrief=false"
        headers = {
            UserAgent = "PureCloudIntegrations/1.0"
            Content-Type = "application/json"
        }
    }

    config_response {
        success_template = "$${rawResult}"
    }
}