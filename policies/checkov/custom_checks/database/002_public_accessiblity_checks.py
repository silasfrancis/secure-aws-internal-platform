from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class RDSPublicAccessibilityDisabled(BaseResourceCheck):
    def __init__(self):
        name = "Ensure RDS instances are not publicly accessible"
        id = "CUSTOM_AWS_RDS_002"
        supported_resources = ['aws_db_instance']
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        public_accessibility = conf.get('publicly_accessible')

        if not public_accessibility:
            self.details = "RDS instance does not specify public accessibility."
            return CheckResult.FAILED

        if public_accessibility and public_accessibility[0] is True:
            self.details = "RDS instance is publicly accessible."
            return CheckResult.FAILED
        return CheckResult.PASSED