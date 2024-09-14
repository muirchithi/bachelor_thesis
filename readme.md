Author:

- Dennis Klug

## Abstract

## Getting started

### Build

To build this project the following dependencies are required:

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads.html)
- Either:
  - Place an [AWS credential file](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/getting-your-credentials.html) at .aws/credentials

    ![location of credentials file](documentation/credential_location.png)

  - Configure your default credentials through [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

**Important Note:** The default deployment region of your aws infrastructure is "eu-central-1". 
This can be changed in terraform/variables.tf trough modifying the default value. Not all services are available in every region before switching please check [here](https://aws.amazon.com/de/about-aws/global-infrastructure/regional-product-services/) if the services AWS IoT Core, IoT Events and Cloudformation are available in your target region.

The easiest way to set up the project is to run the [build.sh](build.sh) script.

Alternatively navigate to the [terraform folder](terraform) and run

```bash
terraform init #guckt erstmal ob alles da ist 
terraform plan # zeigt an was er machen würde mit dem aktuellen Stuff
terraform apply # läd die changes per IaaS API in die Cloud 
docker-compose build  
docker-compose up 
```
### Destroy

To shut down the emulated devices use CTRL+C inside the running shell.

To dismantle the cloud infrastructure run the [destroy.sh](destroy.sh) script.