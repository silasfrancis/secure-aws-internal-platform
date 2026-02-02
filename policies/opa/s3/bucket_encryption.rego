package aws.s3_bucket_encryption

import input as tfplan

deny[msg] {
    s3_bucket_encryption = tfplan.resource_changes[_]
    s3_bucket_encryption.type == "aws_s3_bucket_server_side_encryption_configuration"
    not exists s3_bucket_encryption.change.after.rule[_].apply_server_side_encryption_by_default
    msg = sprintf(
        "S3 Bucket %s does not have default encryption enabled.", 
        [s3_bucket_encryption.name]
        )
}

deny[msg] {
    s3_bucket_encryption = tfplan.resource_changes[_]
    s3_bucket_encryption.type == "aws_s3_bucket_server_side_encryption_configuration"
    s3_bucket_encryption.change.after.rule[_].apply_server_side_encryption_by_default.sse_algorithm != "AES256" and
    s3_bucket_encryption.change.after.rule[_].apply_server_side_encryption_by_default.sse_algorithm != "aws:kms"
    msg = sprintf(
        "S3 Bucket %s does not use a strong encryption algorithm (AES256 or aws:kms).", 
        [s3_bucket_encryption.name]
        )
}