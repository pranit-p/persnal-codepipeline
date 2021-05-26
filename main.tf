#  main module file
provider "aws" {
  region = "us-east-1"
  profile = "for-terraform-aws-access"
}



resource "aws_codebuild_source_credential" "aws-code-build-source-credentials" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = "<GITHUB_TOKEN>"
}

resource "aws_codebuild_project" "code-build-for-pipeline" {
  name = "terraform-codepipeline-demo"
  service_role = aws_iam_role.example.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "hashicorp/terraform:latest"
    type = "LINUX_CONTAINER"
  }
  source {
    type = "GITHUB"
    location = "<Repo_url>"
  }
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.example.id
  policy = <<policy
{
  "Version": "2012-10-17",
  "Statement": [
   {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "organizations:DescribeAccount",
                "organizations:DescribeOrganization",
                "organizations:DescribeOrganizationalUnit",
                "organizations:DescribePolicy",
                "organizations:ListChildren",
                "organizations:ListParents",
                "organizations:ListPoliciesForTarget",
                "organizations:ListRoots",
                "organizations:ListPolicies",
                "organizations:ListTargetsForPolicy"
            ],
            "Resource": "*"
    },
    {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
    }
  ]
}
  policy

}