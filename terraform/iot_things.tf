

#Create Thing
module "iot_thing_backautomat" {
    depends_on   = [time_sleep.wait_15_seconds]
    source = "./modules/iot_thing"

    thing_name = "backautomat"
    is_sensor = true
    is_actor = true

    aws_account_id = data.aws_caller_identity.current.account_id
    aws_endpoint_address = data.aws_iot_endpoint.user.endpoint_address
    aws_region = var.aws_region
    core_to_events_role_arn = aws_iam_role.core_to_events_role.arn
}

#Create Thing
module "iot_thing_leergut_automat" {
    depends_on   = [time_sleep.wait_15_seconds]
    source = "./modules/iot_thing"

    thing_name = "leergut_automat"
    is_sensor = true
    is_actor = true

    aws_account_id = data.aws_caller_identity.current.account_id
    aws_endpoint_address = data.aws_iot_endpoint.user.endpoint_address
    aws_region = var.aws_region
    core_to_events_role_arn = aws_iam_role.core_to_events_role.arn
}

#Create Thing
module "iot_thing_freezer" {
    depends_on   = [time_sleep.wait_15_seconds]
    source = "./modules/iot_thing"

    thing_name = "freezer"
    is_sensor = true
    is_actor = true

    aws_account_id = data.aws_caller_identity.current.account_id
    aws_endpoint_address = data.aws_iot_endpoint.user.endpoint_address
    aws_region = var.aws_region
    core_to_events_role_arn = aws_iam_role.core_to_events_role.arn
    
}

#Create Thing
module "iot_thing_temperature_sensor" {
    depends_on   = [time_sleep.wait_15_seconds]
    source = "./modules/iot_thing"

    thing_name = "temperature_sensor"
    is_sensor = true
    is_actor = false

    aws_account_id = data.aws_caller_identity.current.account_id
    aws_endpoint_address = data.aws_iot_endpoint.user.endpoint_address
    aws_region = var.aws_region
    core_to_events_role_arn = aws_iam_role.core_to_events_role.arn
    
}


