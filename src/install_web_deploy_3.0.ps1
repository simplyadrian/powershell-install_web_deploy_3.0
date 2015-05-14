### Check if product is already installed
$product_name = "*Web Deploy 3.0*"
$check_installed = gwmi win32_product | where {$_.name -like $product_name}

if (![string]::IsNullorEmpty($check_installed))
{
  Write-Output "Product is already installed:`n"
  Write-Output $check_installed
  Exit 0
}
else
{
  write-output("Product '$product_name' is not already installed")
}

# Run appropriate installer based on OS Architecture
cd "$env:RS_ATTACH_DIR"
$osArchitecture = (gwmi win32_OperatingSystem).OSArchitecture
if ($osArchitecture -eq "64-bit")
{
  Start-Process -FilePath msiexec -ArgumentList /i, WebDeploy_amd64_en-US.msi, ADDLOCAL=ALL, /quiet -Wait
}
else
{
  throw("Only 64-bit CPU architecture is supported by this script")
}

# Wait for program registration to complete
#Sleep 60 #no longer needed

# Verify Installation was successful by checking for registered programs
$check_installed = gwmi win32_product | where {$_.name -like $product_name}

if ($check_installed -eq $null)
{
  Write-Output "Error: Installation Failed!"
  Exit 1
}
else
{
  Write-Output "Installation was successful for:`n"
  $check_installed
}
