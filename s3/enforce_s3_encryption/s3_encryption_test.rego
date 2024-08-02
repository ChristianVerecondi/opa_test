package terraform


test_valid_s3_bucket_encryption {
    result = deny with input as data.mock.valid
    count(result) == 0
}

test_invalid_s3_bucket_encryption {
    result = deny with input as data.mock.invalid
    count(result) == 1
}
