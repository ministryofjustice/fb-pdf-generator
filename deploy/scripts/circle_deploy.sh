#!/usr/bin/env sh

set -e -u -o pipefail

CONFIG_FILE="/tmp/helm_deploy.yaml"

git_sha_tag=$1
environment_name=$2
kube_token=$3

deploy_with_secrets() {
    echo -n "$KUBE_CERTIFICATE_AUTHORITY" | base64 -d > .kube_certificate_authority
    kubectl config set-cluster "$KUBE_CLUSTER" --certificate-authority=".kube_certificate_authority" --server="$KUBE_SERVER"
    kubectl config set-credentials "circleci_${environment_name}" --token="${kube_token}"
    kubectl config set-context "circleci_${environment_name}" --cluster="$KUBE_CLUSTER" --user="circleci_${environment_name}" --namespace="formbuilder-platform-${environment_name}"
    kubectl config use-context "circleci_${environment_name}"

    helm template deploy/ \
         --set image_tag="${git_sha_tag}" \
         --set environmentName=$environment_name \
         > $CONFIG_FILE

    kubectl apply -f $CONFIG_FILE -n formbuilder-platform-$environment_name
}

main() {
    echo "deploying ${environment_name}"
    deploy_with_secrets
}

main
