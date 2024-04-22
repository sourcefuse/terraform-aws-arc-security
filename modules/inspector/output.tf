output "aws_cloudwatch_event_rule" {
  description = "The AWS Inspector event rule"
  value       = aws_cloudwatch_event_rule.this.id
}

output "aws_cloudwatch_event_target" {
  description = "The AWS Inspector event target"
  value       = aws_cloudwatch_event_target.this.target_id
}
