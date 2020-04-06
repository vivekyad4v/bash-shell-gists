#!/bin/bash 

export SSM_PS_NP="/foo/uat/bar"

function get_param() {
cat > put_param.txt <<EOF
Foo=Bar
Alias=Cty
EOF
}

function put_param() {
while IFS== read -r KEY VALUE; do
  echo "key - $KEY, value - $VALUE"
  aws ssm put-parameter \
    --name "$SSM_PS_NP/$KEY" \
    --type "String" \
    --value "$VALUE" \
   --overwrite
done < "put_param.txt"
}

get_param
put_param
