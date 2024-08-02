package terraform

import input.tfplan.resource_changes as changes

# Rule enforce S3 bucket not set to public
deny[msg] {
    bucket := changes[_].change.after
    bucket.acl == "public"
    msg := sprintf("Bucket '%s' denied for acl set to 'Public'", [bucket.bucket])
}
