module "guard_duty_sns_topic" {

  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"
  count   = local.enable_just_guard_duty_notification ? 1 : 0

  subscribers     = var.guard_duty_sns_subscribers
  sqs_dlq_enabled = false

  attributes = ["guardduty"]
}

resource "aws_sns_topic_policy" "sns_topic_guard_duty" {
  count  = local.enable_just_guard_duty_notification ? 1 : 0
  arn    = local.enable_just_guard_duty_notification ? module.guard_duty_sns_topic[0].sns_topic_arn : null
  policy = data.aws_iam_policy_document.guard_duty_sns_topic_policy[0].json
}

data "aws_iam_policy_document" "guard_duty_sns_topic_policy" {
  count     = local.enable_just_guard_duty_notification ? 1 : 0
  policy_id = "GuardDutyPublishToSNS"
  statement {
    sid = ""
    actions = [
      "sns:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = [module.guard_duty_sns_topic[0].sns_topic_arn]
    effect    = "Allow"
  }
}

resource "aws_cloudwatch_event_rule" "guard_duty_findings" {
  count       = local.enable_just_guard_duty_notification == true ? 1 : 0
  name        = "${local.name_prefix}-guard-duty-event-rule"
  description = "GuardDuty Findings"
  tags        = var.tags

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.guardduty"
      ],
      "detail-type" : [
        "GuardDuty Finding"
      ]
    }
  )
}

resource "aws_cloudwatch_event_target" "guard_duty_imported_findings" {
  count = local.enable_just_guard_duty_notification == true ? 1 : 0
  rule  = aws_cloudwatch_event_rule.guard_duty_findings[0].name
  arn   = local.enable_just_guard_duty_notification ? module.guard_duty_sns_topic[0].sns_topic_arn : ""
}
