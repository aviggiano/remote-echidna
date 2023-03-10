locals {
  prefix = "${var.namespace}-${var.project}-${substr(sha256(join("-", [var.project_git_checkout, var.pr_number])), 0, 6)}"
}


variable "namespace" {
  type        = string
  description = "Namespace of the remote echidna infrastructure"
  default     = "remote-echidna"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Your project name"
}

variable "s3_bucket" {
  type        = string
  description = "S3 Bucket name to store and load echidna's output between runs"
}

variable "instance_type" {
  type        = string
  description = "Instance type to run echidna on"
  default     = "c5.2xlarge"
}

variable "ec2_instance_key_name" {
  type        = string
  description = "EC2 instance key name. Needs to be manually created first on the AWS console"
}

variable "solidity_version" {
  type        = string
  description = "Solidity version"
  default     = "0.8.17"
}

variable "project_git_url" {
  type        = string
  description = "Project Git URL"
}

variable "project_git_checkout" {
  type        = string
  description = "Project Git checkout (branch or commit hash)"
}

variable "pr_number" {
  type        = string
  description = "GitHub PR number to output logs on"
  default     = ""
}

variable "run_tests_cmd" {
  type        = string
  description = "Command to run echidna tests"
}
