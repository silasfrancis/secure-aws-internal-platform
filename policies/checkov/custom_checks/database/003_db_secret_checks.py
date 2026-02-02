from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class RDSSecretNotPassedInPlainText(BaseResourceCheck):
    def __init__(self):
        name = "Ensure RDS instances do not have secrets passed in plain text"
        id = "CUSTOM_AWS_RDS_003"
        supported_resources = ['aws_db_instance']
        categories = [CheckCategories.SECRETS]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        db_password = conf.get('password')
        user_name = conf.get('username')

        if not db_password or not user_name:
            self.details = "RDS instance does not specify a password or username."
            return CheckResult.FAILED

        if isinstance(db_password[0], str) and db_password[0] != "":
            self.details = "RDS instance has password defined in plain text."
            return CheckResult.FAILED
        if isinstance(user_name[0], str) and user_name[0] != "":
            self.details = "RDS instance has username defined in plain text."
            return CheckResult.FAILED
        
        return CheckResult.PASSED