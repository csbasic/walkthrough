output "marketup-runner" {
  value = aws_instance.marketup-runner.id
}

output "runner_instance_public_ip" {
  value       = aws_instance.marketup-runner.public_ip
  description = "The public IP of the EC2 instance"
}


output "instance-type" {
  value = aws_instance.marketup-runner.instance_type
}

output "instance-volume-type" {
  value = aws_instance.marketup-runner.tags_all
}


