package aws.s3_bucket_versioning

import input as tfplan

deny[msg] {
    s3_bucket_versioning = tfplan.resource_changes[_]
    s3_bucket_versioning.type == "aws_s3_bucket_versioning"
    s3_bucket_versioning.change.after.versioning_configuration.status != "Enabled"
    msg = sprintf(
        "S3 Bucket %s does not have versioning enabled.", 
        [s3_bucket_versioning.name]
        )
}