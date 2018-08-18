#!/bin/bash

GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
ROLE_FILE=gcp_roles.csv 
PERMISSION_FILE=gcp_permissions.csv 

function get_roles () {
gcloud iam roles list --format="csv(title,name,description,stage)"
}

function get_permissions () {
gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$GOOGLE_CLOUD_PROJECT --format="csv(name,title,description,stage,apiDisabled)"
}

get_roles > $ROLE_FILE
get_permissions > $PERMISSION_FILE
