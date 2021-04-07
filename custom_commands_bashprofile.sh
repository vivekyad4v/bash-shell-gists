#!/bin/bash

function aws_get_prep_credentials() {
    echo "setting up PREP credentials...."
    export AWS_ACCESS_KEY_ID=AKIAIxxxx
    export AWS_SECRET_ACCESS_KEY=6jjZzNYEe0yvADECRe8Rxxxxxx
    export AWS_DEFAULT_REGION=ap-south-1 
}

function aws_assume_role_prd() {
    aws_unset_role_prd
    aws_get_prep_credentials
    ROLE_ARN=arn:aws:iam::362136838334:role/aws-cross-account-admin-role
    AWS_REGION=ap-south-1
    echo "Assuming PRD role => ${ROLE_ARN}...."

    CREDENTIALS=`aws sts assume-role --role-arn ${ROLE_ARN} --role-session-name assume_role_prd_${USERNAME} --duration-seconds 900 --output=json`

    export AWS_DEFAULT_REGION=${AWS_REGION}
    export AWS_ACCESS_KEY_ID=`echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId'`
    export AWS_SECRET_ACCESS_KEY=`echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey'`
    export AWS_SESSION_TOKEN=`echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken'`
    export AWS_EXPIRATION=`echo ${CREDENTIALS} | jq -r '.Credentials.Expiration'`
}

function aws_clear_all_credentials() {
    echo "Clearing all credentials..."
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_EXPIRATION
    aws_get_prep_credentials
}