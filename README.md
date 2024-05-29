# Data Core Airflow (MWAAA)

The purpose of this repo is to give a quick example of a boilerplate structure for how to
approach Terraform at scale, with varied environments. Feel free to customize this as your
team/department may need.

This repository utilizes [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/). Terragrunt serves as a thin wrapper around
Terraform allowing you to have a DRY (DO NOT REPEAT YOURSELF) configuration. IE, write code
once and apply to different versioning. What's a little odd is all environments reside within
a single branch. You can control the module version locking by hosting modules in a separate
repository with tagged releases. The tagged releases will allow Terragrunt to only serve the
version of the infrastructure that existed at that tagged version.

In addition, this repo can have account overrides so each environment may reside within its
own AWS account if desired! Environments and regions are also dynamically defined based on
file structure.

### Remote Terraform / Terragrunt State

One of the biggest strengths of Terragrunt is the ability to store the terraform state
remotely. By so doing you can deploy your various environments with a singular state.
Terragrunt also employs a dynamodb table for locking so two deployments cannot occur
at the same time.

The global variables/inputs which allow this are defined inside
`~live/defaults.hcl`. The following table gives you a breakdown of the variables.

| Variable                   | Description                                                                                                        |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| platform                   | Default platform for all modules. Each repo is defined as a single "platform".                                     |
| aws_region                 | Default AWS platform. Also will be used as the location where state is stored.                                     |
| aws_profile                | Can be used to locally define aws profiles, allowing for quick switching.                                          |
| aws_account_id             | Default AWS account ID.                                                                                            |
| bucket_name_prefix         | This will serve as the default bucket prefix.                                                                      |
| terraform_locks_table_name | This is the dynamodb table created remotely to serve as a locking queue for terraform to avoid resource collision. |

Note, the following environment variables are also defined for ease of testing to override the
storage locations for the remote config. `TG_BUCKET_PREFIX` can be set to override the
`bucket_name_prefix` value at runtime for testing. Likewise the env variable `TG_DYNAMODB_TABLE`
is coded to allow the override of the `terraform_locks_table_name` config variable.

### Shared Module Repository

Another great feature of Terragrunt is the ability to store terraform code for modules
in a remote repository. This allows various Terragrunt repositories to reuse common code
defined anywhere (DRY). You can even version lock to tagged releases the code so that you can
ensure there is not feature creep. And you can also isolate that per deployed environment
as well.

## Project Layout

The naming standard of each resource is `[PREFIX]`-`[PROJECT]`-`[ENVIRONMENT]`-`[NAME]`. The prefix
may be dropped if not necessary. The defining of this structure is based in a variety of `.hcl`
config files. As a few files are dynamic, the structure of the repo is of great importance. The
structure for live folder must be as follows.

```text
├── live/
│   └── [ENV_NAME]/
│      └── env.hcl
│      └── account.hcl
│      └── [REGION]/
│         └── region.hcl
├── modules/
```

You are welcome to create multiple regions per environment and any number of environments. An example
would be:

```text
├── live/
│   └── defaults.hcl
│   └── dev/
│      └── env.hcl
│      └── account.hcl
│      └── us-east-1/
│         └── region.hcl
│   └── stage/
│      └── env.hcl
│      └── account.hcl
│      └── us-east-1/
│         └── region.hcl
│      └── us-east-2/
│         └── region.hcl
```

In this case the `dev` environment would be deployed to `us-east-2`, but the `stage` environment would
have resources in `us-east-1` and `us-east-2`.

| File        | Description                                                                                                                                                     |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| default.hcl | This is the primary config file for this repository. It sets the default `platform` name, as well as many other variables.                                      |
| env.hcl     | A dynamic file which uses the `[ENV]` folder as the variable. Must be at the region level.                                                                      |
| region.hcl  | A dynamic file which uses the `[REGION]` folder as the variable. Must be at the region level.                                                                   |
| account.hcl | An override config file which allows you to bypass values set by the `defaults.hlc` file. This is for use when you have environments in different AWS accounts. |

#### Local `modules` folder

During development, or if you do not find a need to share modules outside of this repo, you may
store your terraform code within a `modules` folder within the repo. Remember `live/` is for invoking
module code. No direct terraform should ever be stored in `./live`. You reference this code as a source
in the manner displayed within `~/`

#### Changes to the template code

As this repo provides a template for core-airflow deployment on AWS, before running the code you need to make
certain changes in few files with your AWS configuration details, your terraform code git reference, etc.
Files that needs to be updated:

| File           | Changes                                                                                                                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| default.hcl    | Give AWS account details such as account id, region, etc. Replace all `UPDATE ME` with proper values.                                                                                             |
| terragrunt.hcl | This file contains configuration of AWS VPC, replace the `<YOUR_TERRAGRUNT_SSH_GIT_LINK>` with your terraform code git repo and all other VPC related values in their corresponding placeholders. |
| account.hcl    | Replace `<YOUR_AWS_ACCOUNT_ID>` with proper value. Provide the AWS account on which you want to deploy the airflow.                                                                               |

#### Debugging Variables

Since debugging the inheritance can be fairly difficult, you can run the below command. It will
generate a `terragrunt-debug.tfvars.json` file at the `~/live/[ENV]/[REGION]/[MODULE]`
path. This will contain all the values passed to the module (terraform) code.

```commandline
terragrunt run-all plan --terragrunt-debug
```

#### Running & Testing Code

Running this repo matches the commands that terraform offers, except you must prepend the
command with `terragrunt run-all`. Run these commands within the `live` folder.

```commandline
terragrunt run-all [STANDARD TERRAFORM COMMAND]
terragrunt run-all plan
terragrunt run-all apply
terragrunt run-all destroy
```

If you want to isolate to a single environment, there are two simple approaches.
Each approach can be used to isolate down to a single region, module, etc.

###### 1. Isolate Execution w/ `--terragrunt-working-dir`

Use the `--terragrunt-working-dir` and provide a full path to the folder you want to
isolate. You can use this from the root folder of this repository. Be sure to use ./
to instruct terragrunt it's relative to the current path.

```commandline
terragrunt run-all plan --terragrunt-working-dir ./live/dev/
```

###### 2. Isolate Execution by `cd`

The second method is less specific to invoke. Simply navigate to the folder where you
want to perform recursive execution. The folder you are in will serve as the top level
folder for execution. An example of this approach is as follows.

```commandline
cd live/dev
terragrunt run-all plan
```
