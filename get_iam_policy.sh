#!/bin/bash
#set -x

if [ $# -ne 1 ]; then
    echo $0: usage: Requires argument of Organizational name e.g.   your_dns_domain.com
    exit 1
fi

export org_name=$1
export project_id=$(gcloud config get-value project)
export org_id=$(gcloud organizations list --format=[no-heading] | grep ${org_name} | awk '{print $2}')

function iam_org () {
gcloud alpha organizations get-iam-policy $org_id --format json
}

function iam_folder () {
export folder_list=$(gcloud alpha resource-manager folders list --format=[no-heading] --organization=$org_id |awk '{print $3}')

for x in "$folder_list"
do
 gcloud alpha resource-manager folders get-iam-policy $x --format json
done
}

function iam_project () {
for x in $(gcloud projects list --format=[no-heading] |awk '{print $1}')
do
 STATUS=$(gcloud projects describe $x |grep lifecycleState |awk '{print $2}')
 PROJECT_ORG=$(gcloud projects describe $x |grep $org_id |awk -F\' '{print $2}')
 	if
 	[ "$STATUS" == "ACTIVE" ] && [ "$PROJECT_ORG" == "$org_id" ]; then
 	gcloud alpha projects get-iam-policy $x --format json
 	fi
done
}

iam_org
iam_folder
iam_project
