#!/usr/bin/env bash

if [[ ! -f openapi-generator-cli.jar ]]; then
	wget http://central.maven.org/maven2/org/openapitools/openapi-generator-cli/4.2.2/openapi-generator-cli-4.2.2.jar -O openapi-generator-cli.jar
fi

rm -Rf packages

echo "---> Generating Bondora client for PHP"

if [[ ! -f bondora-v1.json ]]; then
	wget https://api.bondora.com/swagger/docs/v1 -O bondora-v1.json
fi

java -jar openapi-generator-cli.jar generate -i bondora-v1.json -g php \
    -o packages/bondora-openapi-php \
    --additional-properties=srcBasePath=src,variableNamingConvention=camelCase,invokerPackage=CedricZiel\\OpenAPI\\BondoraPHP \
    --git-user-id=cedricziel \
    --git-repo-id=bondora-openapi-php \
    --type-mappings=object=interface{} \
    --skip-validate-spec

pushd packages/bondora-openapi-php
    chmod +x git_push.sh
    ./git_push.sh cedricziel bondora-openapi-php "Automated Update"
popd