CFN_TEMPLATE := "./infra/infra.yml"
CFN_TEMPLATE_PACKAGED = "./packaged.yml"
CFN_STACKNAME := jimmy-aws-training-homework
CFN_PARAMETER_FILE := ./infra/config.json
CFN_TEMPLATEDIR = $(shell dirname $(CFN_TEMPLATE))
DEPLOY_BUCKET := cf-templates-1u9k776nfllvt-ap-northeast-1

ifdef CFN_PARAMETER_FILE
CFN_PARAMETER_OVERRIDES := --parameter-overrides $(shell jq -r 'to_entries | map(.key + "=" + .value) | join(" ")' $(CFN_PARAMETER_FILE))
endif

install:
	pip install awscli cfn-lint

clean:
	rm -rf $(CFN_TEMPLATE_PACKAGED)

lint:
	cfn-lint -t $(CFN_TEMPLATE)

validate: lint
	aws cloudformation validate-template --template-body file://${CFN_TEMPLATE}

package: validate
	aws cloudformation package \
		--template-file $(CFN_TEMPLATE) \
		--s3-bucket $(DEPLOY_BUCKET) \
		--output-template-file $(CFN_TEMPLATE_PACKAGED)

deploy-infra: package
	aws cloudformation deploy \
		--template-file $(CFN_TEMPLATE_PACKAGED) \
		--stack-name $(CFN_STACKNAME) \
		$(CFN_PARAMETER_OVERRIDES) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset