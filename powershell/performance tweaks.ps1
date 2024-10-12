# --------------------------------------------------  PERFORMANCE TWEAKS   ----------------------

# installing a list of modules
$modules = @('ModuleName1', 'ModuleName2', 'ModuleName3')

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Force -AllowClobber
    }
}

# Exporting moudles list in a specific directory to a json file 

function Export-ModulesToJson {
    param (
        [string]$ModulePath,  # Path where installed modules are located
        [string]$JsonFilePath # Destination path for the JSON file
    )

    # Check if the module path exists
    if (-Not (Test-Path $ModulePath)) {
        Write-Host "The specified module path does not exist: $ModulePath" -ForegroundColor Red
        return
    }

    # Get all available modules and filter by the specified module path
    $modules = Get-Module -ListAvailable | Where-Object { $_.ModuleBase -like "$ModulePath*" }

    # If no modules are found, display a message
    if (-Not $modules) {
        Write-Host "No modules found in the specified path: $ModulePath" -ForegroundColor Yellow
    } else {
        # Export the modules to a JSON file
        $modules | Select-Object Name, Version | ConvertTo-Json | Out-File $JsonFilePath
        Write-Host "Modules exported to: $JsonFilePath" -ForegroundColor Green
    }
}

# Example of how to call the function
# Export-ModulesToJson -ModulePath "C:\Users\username\AppData\Local\PowerShell\Modules" -JsonFilePath "C:\Users\username\Documents\moduleList.json"



# Installing modules from a json file to a specific directory

function Install-ModulesFromJson {
    param (
        [string]$JsonFilePath,  # Path to the JSON file
        [string]$InstallPath = $null # Optional install path, default system paths will be used if not provided
    )

    # Check if the JSON file exists
    if (-Not (Test-Path $JsonFilePath)) {
        Write-Host "The JSON file does not exist: $JsonFilePath" -ForegroundColor Red
        return
    }

    # Import the JSON file with the module information
    $moduleList = Get-Content $JsonFilePath | ConvertFrom-Json

    # Loop through each module and install it
    foreach ($module in $moduleList) {
        try {
            # If InstallPath is provided, use it; otherwise, use the default path
            if ($InstallPath) {
                Install-Module -Name $module.Name -RequiredVersion $module.Version -Scope CurrentUser -Force -AllowClobber
                Move-Item -Path "$DEFAULT_MODULE\$module" -Destination $InstallPath -Force
                # $DEFAULT_MOUDULE : refers to the path : "C:\Users\username\Documents\PowerShell\Modules\"
            } else {
                Install-Module -Name $module.Name -RequiredVersion $module.Version -Scope CurrentUser -Force -AllowClobber
            }

            Write-Host "Module $($module.Name) installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to install module $($module.Name): $_" -ForegroundColor Red
        }
    }
}

# Example of how to call the function
# Install-ModulesFromJson -JsonFilePath "C:\Users\username\Documents\moduleList.json" -InstallPath "C:\Program Files\WindowsPowerShell\Modules"


# --------------------------------------------------------------------------------------------------------------------------
# 