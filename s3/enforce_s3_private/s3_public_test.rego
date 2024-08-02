package terraform

test_invalid_s3_bucket_private {
    result = deny with input as data.mock.invalid
    count(result) == 1
}

test_valid_s3_bucket_private {
    result = deny with input as data.mock.valid
    count(result) == 0
}