<#
Creates an Azure AD service principal, assigns it a role, and stores its secret in Key Vault.
#>

param(
    [string]$Name,
    [string]$Role = 'Contributor',
    [string]$Scope = "/subscriptions/$((Get-AzContext).Subscription.Id)",
    [string]$KeyVaultName,
    [string]$SecretName = "$Name-sp-secret"
)

# Ensure Az.KeyVault module is available
if (-not (Get-Module -ListAvailable -Name Az.KeyVault)) {
    Write-Output "Az.KeyVault module not found, importing..."
    Import-Module Az.KeyVault -ErrorAction Stop
}

# Generate a random password for the SP
Add-Type -AssemblyName System.Web
$passwordPlain = [System.Web.Security.Membership]::GeneratePassword(16, 3)
$securePassword = ConvertTo-SecureString -String $passwordPlain -AsPlainText -Force

# Create the SP and assign the role
$sp = New-AzADServicePrincipal `
    -DisplayName $Name `
    -Password $securePassword `
    -Role $Role `
    -Scope $Scope `
    -ErrorAction Stop

Write-Output " Service Principal '$Name' created in Azure Environment...."
Write-Output "   • AppId:   $($sp.ApplicationId)"
Write-Output "   • Tenant:  $((Get-AzContext).Tenant.Id)"

# Store the secret in Key Vault
try {
    $secret = Set-AzKeyVaultSecret `
        -VaultName $KeyVaultName `
        -Name $SecretName `
        -SecretValue (ConvertTo-SecureString -String $passwordPlain -AsPlainText -Force) `
        -ErrorAction Stop

    Write-Output "Secret stored in Key Vault '$KeyVaultName' as '$SecretName'."
} catch {
    Write-Error "Failed to write secret to Key Vault: $_"
    exit 1
}

# Output a Key Vault URI for downstream jobs
Write-Output "KeyVaultSecretUri: $($secret.Id)"
