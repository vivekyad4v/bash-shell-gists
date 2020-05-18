#!/bin/bash 

######## Ensure to allow follow urlparam.
### $ cat ~/.aws/config 
###   [default]
###   cli_follow_urlparam = false
#######


export KMS_KEY_ID="kms_key_id"
export SSM_PS_NP="/foo/uat/bar"

function get_param() {
cat > put_param.txt <<EOF
Foo=Bar
Alias=Cty
EOF
}

function get_param_encrypted() {
cat > put_param_encrypted.txt << EOF
Foo2=Bar2
Foo3=Bar3
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

function put_param_encrypted() {
while IFS== read -r KEY VALUE; do
  echo "key - $KEY, value - $VALUE"
  aws ssm put-parameter \
    --name "$SSM_PS_NP/$KEY" \
    --key-id "$KMS_KEY_ID" \
    --type "SecureString" \
    --value "$VALUE" \
   --overwrite
done < "put_param_encrypted.txt"
}
get_param
get_param_encrypted
put_param
put_param_encrypted
