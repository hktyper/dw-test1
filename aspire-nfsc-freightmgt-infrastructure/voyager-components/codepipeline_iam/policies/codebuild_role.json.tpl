{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${codepipeline_account_id}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
