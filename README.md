# remote-echidna

Run echidna on AWS with Terraform

## Description

This project creates the following infrastructure on AWS:

- [Security Group](./terraform/security_group.tf) with SSH access from anywhere, to allow for an easier debugging
- [S3 bucket](./terraform/s3_bucket.tf) with private access to store and load echidna's output between runs
- [IAM Policy](./terraform/iam_user.tf) with access to the S3 bucket
- [IAM User](./terraform/iam_user.tf) with the created IAM Policy
- [EC2 Instance](./terraform/ec2_instance.tf) that runs echidna on the desired git project and uses the IAM User credentials to upload results to S3

## Usage with Terraform Cloud

1. Add this project as a dependency of the repository you want to test. The easiest way is with a git module

```
git submodule add https://github.com/aviggiano/remote-echidna.git
```

2. Create a [Workspace](https://app.terraform.io/app/YOUR_ORG/workspaces/new) with `Version control workflow` on Terraform Cloud and link your Github project

3. Add the the parameters below to your [Workspace variables](https://app.terraform.io/app/YOUR_ORG/workspaces/YOUR_WORKSPACE/variables) on Terraform Cloud, including `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables

4. Configure your [Working Directory](https://app.terraform.io/app/YOUR_ORG/workspaces/YOUR_WORKSPACE/settings/general) as `remote-echidna`

5. Set `Include submodules on clone` on the [Version Control](https://app.terraform.io/app/YOUR_ORG/workspaces/YOUR_WORKSPACE/settings/version-control) settings

### Inputs

| Parameter               | Description                                                                  | Example                                                                                | Required |
| ----------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | -------- |
| `ec2_instance_key_name` | EC2 instance key name. Needs to be manually created first on the AWS console | `key.pem`                                                                              | Yes      |
| `project`               | Your project name                                                            | `smart-contracts`                                                                      | Yes      |
| `project_git_url`       | Project Git URL                                                              | `https://github.com/aviggiano/smart-contracts.git`                                     | Yes      |
| `run_tests_cmd`         | Command to run echidna tests                                                 | `yarn && echidna-test test/Contract.sol --contract Contract --config test/config.yaml` | Yes      |

## Development

#### 1. Create a `tfvars` file

Include the parameters required by [vars.tf](./terraform/vars.tf)

```
# vars.tfvars

project               = "echidna-project"
project_git_url       = "https://github.com/aviggiano/echidna-project.git"
ec2_instance_key_name = "key.pem"
run_tests_cmd         = "yarn && echidna-test test/Contract.sol --contract Contract --config test/config.yaml"
```

### 2. Run terraform

```
terraform apply -var-file vars.tfvars
```

## Next steps

- [ ] Improve state management to avoid conflicting runs from multiple people
- [ ] Perform cleanup of terraform state after the job finishes
- [ ] Create AMI with all required software instead of [installing everything](./terraform/user_data.tftpl) at each time (would speed up about 1min)
