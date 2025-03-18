output "gateway_ip" {
  description = "API Gateway URL"
  value = aws_apigatewayv2_api.ecs_api.api_endpoint
}