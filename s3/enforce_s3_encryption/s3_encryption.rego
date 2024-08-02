package terraform

import input.tfplan.resource_changes as changes

allowed_sse_algorithms = ["aws:kms", "AES256"]

array_contains(arr, elem) {
  arr[_] = elem
}

## Rule to require server-side encryption
#deny[msg] {
#    bucket := changes[_].change.after
#    bucket.server_side_encryption_configuration == 0
#    msg := sprintf("%s: requires server-side encryption with expected sse_algorithm to be one of %v", [bucket.bucket, allowed_sse_algorithms])
#}

# Rule to enforce specific SSE algorithms
deny[msg] {
    bucket := changes[_].change.after
    sse_configuration := bucket.server_side_encryption_configuration[_]
    apply_sse_by_default := sse_configuration.rule[_].apply_server_side_encryption_by_default[_]
    print(bucket.bucket)
    print(apply_sse_by_default)
    not array_contains(allowed_sse_algorithms, apply_sse_by_default.sse_algorithm)
    msg := sprintf(
        "%s: expected sse_algorithm to be one of %v",
        [bucket.bucket, allowed_sse_algorithms]
    )
}