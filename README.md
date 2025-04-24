# Azure Service Principal Creation Automation with PowerShell & Azure DevOps
This repository automates the creation of Azure Service Principals using PowerShell, integrated seamlessly with Azure DevOps pipelines. It simplifies onboarding of service principals by:
- Creating an Azure Active Directory (AAD) application
- Registering a service principal for the application
- Assigning roles (e.g., Contributor, Reader) at desired scopes
- Outputting credentials required for secure programmatic access

## Repository Structure
 ├── Create-ServicePrincipal-Azure.ps1 # PowerShell script to create SP ├── SPN_creation_azurepipeline.yml # Azure DevOps pipeline definition └── README.md

## Prerequisites:
- Ensure you have an access to Azure Cloud
- create a Service connection for the pipeline to authenticate to Azure Cloud
- Azure PowerShell Az module installed

## How to Use
### 1. Clone the repo
```bash
git clone https://github.com/Siluvai1997/ServicePrincipal-Creation-Automation-in-Azure-using-PS.git
cd ServicePrincipal-Creation-Automation-in-Azure-using-PS
```
### 2. Run the Script locally (Optional)
```bash
.\Create-ServicePrincipal-AzureOnboarding.ps1
```
### 3. Configure Azure DevOps Pipeline
- Go to your Azure DevOps project
- Create a new pipeline and point it to SPN_creation_azurepipeline.yml from this repo
- Ensure your service connection (Azure Resource Manager) has the required permissions
- Run the pipeline
