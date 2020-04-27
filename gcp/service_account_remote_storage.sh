#!/bin/sh
set -x

export SERVICE_ACCOUNT_NAME=terraform-sa
export PROJECT_NAME=supermagicdiary
export LOCATION=us-central1
export BUCKET_NAME=terraform-remote-state-supermagicdiary

# ------------------------------- CREATE SERVICE ACCOUNT

#First, enable the Google Cloud APIs we will be using:
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com

#Then create a service account:
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME}

#Now we can grant the necessary roles for our service account to create a GKE cluster and the associated resources:
gcloud projects add-iam-policy-binding ${PROJECT_NAME} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com --role roles/container.admin
gcloud projects add-iam-policy-binding ${PROJECT_NAME} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_NAME} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding ${PROJECT_NAME} --member serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin

#Finally, we can create and download a key file that Terraform will use to authenticate as the service account against the Google Cloud Platform API:
gcloud iam service-accounts keys create terraform-sa-keyfile.json --iam-account=${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com

# ------------------------------- CREATE TERRAFORM REMOTE STATE
#First, let’s create a bucket, we could do it graphically on the Google Cloud Console, or we can use the Google Cloud SDK we just installed:
gsutil mb -p ${PROJECT_NAME} -c regional -l ${LOCATION} gs://${BUCKET_NAME}/

#Once we have our bucket, we can activate object versioning to allow for state recovery in the case of accidental deletions and human error:
gsutil versioning set on gs://${BUCKET_NAME}/

#Finally, we can grant read/write permissions on this bucket to our service account:
gsutil iam ch serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_NAME}.iam.gserviceaccount.com:legacyBucketWriter gs://${BUCKET_NAME}/


