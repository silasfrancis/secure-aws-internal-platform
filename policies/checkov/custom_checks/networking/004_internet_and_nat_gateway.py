from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class InternetandNatGatewayRestrictions(BaseResourceCheck):
    def __init__(self):
        name = "Ensure that Internet Gateways and NAT Gateways are not publicly accessible"
        id = "CUSTOM_AWS_NW_004"
        supported_resources = ['aws_internet_gateway', 'aws_nat_gateway']
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        if self.entity_type == 'aws_internet_gateway':
            attachments = conf.get("vpc_id")
            if not attachments:
                return CheckResult.FAILED

        if self.entity_type == 'aws_nat_gateway':
            allocation_id = conf.get("allocation_id")
            if not allocation_id:
                return CheckResult.FAILED
        if self.entity_type == 'aws_nat_gateway':
            subnet_id = conf.get("subnet_id")
            if not subnet_id:
                return CheckResult.FAILED
        

        return CheckResult.PASSED