{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "logs:*",
        "cloudwatch:*",
        "dynamodb:*",
        "ecr:*",
        "elasticmapreduce:*",
        "events:*",
        "s3:*",
        "iam:*",
        "kms:*",
        "lambda:*",
        "codeartifact:*",
        "codebuild:*",
        "codepipeline:*",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "sns:*",
        "sqs:*"
      ],
      "Resource": "*"
    %{if cross_account_roles == []}
    }
    %{else}
    },
    %{for role in cross_account_roles}
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${role}"
    }
    %{endfor}
    %{endif}
  ]
}
