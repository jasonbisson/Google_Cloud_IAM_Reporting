#!/bin/bash

GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
ROLE_FILE=gcp_roles.csv 
PERMISSION_FILE=gcp_permissions.csv 

function get_roles() {
  echo "Extracting IAM roles..."
  gcloud iam roles list --format="csv(title,name,description,stage)" > $ROLE_FILE
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract IAM roles."
    exit 1
  fi
}

function get_permissions() {
  echo "Extracting testable permissions..."
  gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$GOOGLE_CLOUD_PROJECT --format="csv(name,title,description,stage,apiDisabled)" > $PERMISSION_FILE
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract permissions."
    exit 1
  fi
}

get_roles 
get_permissions 

