resource "aws_apigatewayv2_api" "ecs_api" {
  name          = "tech-challenge"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "ecs_integration" {
  api_id             = aws_apigatewayv2_api.ecs_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${aws_eip.api_eip.public_ip}"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "ecs_route" {
  api_id    = aws_apigatewayv2_api.ecs_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.ecs_integration.id}"
}

resource "aws_apigatewayv2_stage" "ecs_stage" {
  api_id      = aws_apigatewayv2_api.ecs_api.id
  name        = ""
  auto_deploy = true
}