resource "aws_eip" "api_eip" {
  domain = "vpc"

  tags = {
    Name = "api_eip"
  }
}

resource "aws_eip_association" "api_eip_association" {
  instance_id   = data.terraform_remote_state.api.outputs.api_instance_id
  allocation_id = aws_eip.api_eip.id
}