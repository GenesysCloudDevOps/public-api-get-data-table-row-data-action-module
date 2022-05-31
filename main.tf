resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "Gets a Single Row in a Data Table",
        "properties" = {
            "AttributeName" = {
                "description" = "The attribute name to find in the table",
                "type" = "string"
            },
            "DataTableId" = {
                "type" = "string"
            }
        },
        "required" = [
            "DataTableId"
        ],
        "title" = "Query an attribute in the generic attribute table.",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "Returns an attributes value",
        "properties" = {
            "AttributeValue" = {
                "description" = "The value of the generic attribute.",
                "type" = "string"
            }
        },
        "title" = "Get Generic Attribute Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\"AttributeValue\": \"$${input.AttributeValue}\", \"key\": \"$${input.AttributeName}\"}"
        request_type         = "GET"
        request_url_template = "/api/v2/flows/datatables/$${input.DataTableId}/rows/$${input.AttributeName}?showbrief=false"
        headers = {
            UserAgent = "PureCloudIntegrations/1.0"
            Content-Type = "application/json"
        }
    }

    config_response {
        success_template = "{\"AttributeValue\": $${AttributeValue}\n}"
        translation_map = { 
            AttributeValue = "$.AttributeValue"
        }
    }
}