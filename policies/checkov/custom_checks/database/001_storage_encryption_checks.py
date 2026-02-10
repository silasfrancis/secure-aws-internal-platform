from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class RDSStorageEncryptionEnabled(BaseResourceCheck):
    def __init__(self):
        name = "Ensure RDS instances have storage encryption enabled"
        id = "CUSTOM_AWS_RDS_001"
        supported_resources = ['aws_db_instance']
        categories = [CheckCategories.ENCRYPTION]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        storage_encrypted = conf.get('storage_encrypted')

        if not storage_encrypted:
            self.details = "RDS instance does not specify storage encryption."
            return CheckResult.FAILED

        if not storage_encrypted or storage_encrypted[0] is not True:
            self.details = "RDS instance does not have storage encryption enabled."
            return CheckResult.FAILED
        return CheckResult.PASSED