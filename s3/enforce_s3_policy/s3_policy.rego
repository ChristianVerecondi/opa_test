package terraform

import input.tfplan.resource_changes as changes
import future.keywords.in
import future.keywords.contains

array_contains(arr, elem) {
  arr[_] == elem
}

access_address = ["access-analyzer.amazonaws.com", "arn:aws:iam:"]

allow_access_analyzer = [
  # Define the allowed IAM principal
  #"access-analyzer.amazonaws.com",
  # Define the allowed actions (adjust based on your needs)
  "s3:GetAccessPoint",
  "s3:GetAccessPointPolicy",
  "s3:GetAccessPointPolicyStatus",
  "s3:GetAccountPublicAccessBlock",
  "s3:GetBucketAcl",
  "s3:GetBucketLocation",
  "s3:GetBucketPolicy",
  "s3:GetBucketPolicyStatus",
  "s3:GetBucketPublicAccessBlock",
  "s3:ListAccessPoints",
  "s3:ListAllMyBuckets"
]

#deny[msg] {
#  bucket := changes[_].change.after
#  policy := bucket.statement[_].principals[_].identifiers
#  some access in access_address
#    not array_contains(policy, access)
#  # Check if policy allows access for access-analyzer.amazonaws.com
#  msg := sprintf(" S3 bucket '%s' policy does not allow access for access-analyzer.amazonaws.com ", [bucket.bucket])
#}



deny[msg] {
  bucket := changes[_].change.after
  policy := bucket.statement[_].actions
  # Check if policy allows access for access-analyzer.amazonaws.com
  some access_policy in allow_access_analyzer
    not array_contains(policy, access_policy)
    msg := sprintf(" S3 bucket '%s' policy does not allow access for access-analyzer.amazonaws.com ", [bucket.bucket])
}

