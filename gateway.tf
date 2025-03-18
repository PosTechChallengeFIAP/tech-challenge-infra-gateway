resource "aws_apigatewayv2_api" "ecs_api" {
  name          = "tech-challenge"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "GET", "OPTIONS"]
    allow_headers = ["content-type", "authorization"]
    max_age = 300
  }
}

resource "aws_apigatewayv2_integration" "ecs_integration" {
  api_id             = aws_apigatewayv2_api.ecs_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${aws_eip.api_eip.public_ip}:80"
  integration_method = "ANY"
  connection_type    = "INTERNET"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "ecs_route" {
  api_id    = aws_apigatewayv2_api.ecs_api.id
  route_key = "ANY {proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ecs_integration.id}"
}

resource "aws_apigatewayv2_stage" "ecs_stage" {
  api_id      = aws_apigatewayv2_api.ecs_api.id
  name        = "tech-challenge"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.ecs_api_log_group.arn
    format          = jsonencode({
      requestTime       = "$context.requestTime"
      httpMethod       = "$context.httpMethod"
      status           = "$context.status"
      routeKey         = "$context.routeKey"
      requestId        = "$context.requestId"
      identitySource   = "$context.identity.sourceIp"
      identityUserAgent = "$context.identity.userAgent"
    })
  }
}

resource "aws_cloudwatch_log_group" "ecs_api_log_group" {
  name = "/aws/apigateway/ecs-api-access-logs"
}