package terraform

import input.tfplan.resource_changes as changes

# Rule enforce S3 bucket region to ap-southeast-2
deny[msg] {
    bucket := changes[_].change.after
    bucket.region != "ap-southeast-2"
    msg := sprintf("Bucket '%s' denied for region not set to ap-southeast-2'", [bucket.bucket, bucket.region])
}