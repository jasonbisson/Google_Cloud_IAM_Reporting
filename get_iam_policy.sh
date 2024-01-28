#!/bin/bash

# Argument validation
if [ $# -ne 1 ]; then
    echo "$0: usage: Requires the organization's domain name (e.g., your_dns_domain.com)"
    exit 1
fi

org_name=$1
project_id=$(gcloud config get-value project)
org_id=$(gcloud organizations list --format=[no-heading] | grep "${org_name}" | awk '{print $2}')

# IAM Functions (adjust formatting and output as desired)
function iam_org() {
    gcloud organizations get-iam-policy "$org_id" --format json
}

function iam_folder() {
    folder_list=$(gcloud resource-manager folders list --format=[no-heading] --organization="$org_id" | awk '{print $3}')
    for folder_id in $folder_list; do
        gcloud alpha resource-manager folders get-iam-policy "$folder_id" --format json
    done
}

function iam_project() {
    for project_id in $(gcloud projects list --format=[no-heading] |awk '{print $1}'); do
        if gcloud projects describe "$project_id" --format='value(lifecycleState, parent.id)' | grep -Eq 'ACTIVE.*'"$org_id"''; then
            gcloud projects get-iam-policy "$project_id" --format json
        fi
    done
}

# Print section headers or dividers if combining output 
iam_org
iam_folder
iam_project

