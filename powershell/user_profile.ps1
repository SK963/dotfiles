#------------------------------POWERSHELL CONFIGURATION ------------------
# -----------------------------SCRIPTS------------------------------------
# checking new features 
# . "C:\Users\Shubham Kumar\.config\powershell\features.ps1"


# adding path for the custom directory for installed modules
# $env:PSModulePath += ";C:\Users\Shubham Kumar\AppData\Local\PowerShell\Modules"
$DEFAULT_MODULE = "C:\Users\Shubham Kumar\Documents\PowerShell\Modules\"
$MODULE = "C:\Users\Shubham Kumar\AppData\Local\PowerShell\Modules"
$env:PSModulePath += ";$MODULE"

# -------------------------------MODULES AND CONFIGS-------------------------
# Load Modules

# Import-Module -Name oh-my-posh

Import-Module -Name posh-git

# Terminal Icons
Import-Module -Name Terminal-Icons


# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionViewStyle ListView # Optional for list view of history

# Fzf  : fuzzy file finder
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'


# --------------------------------THEME-----------------------------------

# PROMPT CONFIG
# DEFAULT / PREBUILTS
# Set-PoshPrompt Parado 
# Invoke-Expression (&starship init powershell)  # STARSHIP 


# CUSTOM 
# oh-my-posh init pwsh --config ~/mytheme.omp.json | Invoke-Expression
oh-my-posh init pwsh --config "C:\Users\Shubham Kumar\.config\powershell\takuya.omp.json" | Invoke-Expression





# ------------------------------ PATHS -----------------------------------
$PROFILE = "C:\Users\Shubham Kumar\.config\powershell\user_profile.ps1"
$PERMANENT_PROFILE = "C:\Users\Shubham Kumar\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"



$CODE = "C:\Users\Shubham Kumar\Code"
$DSA = "C:\Users\Shubham Kumar\Code\DSA"
$DS = "C:\Users\Shubham Kumar\Code\DATA SCIENCE"
$DEVOPS = "C:\Users\Shubham Kumar\Code\Devops"
$PROJECT = "C:\Users\Shubham Kumar\Code\projects"
$DB = "C:\Users\Shubham Kumar\Code\Databases"
$WEB = "C:\Users\Shubham Kumar\Code\Web Development"
$config = "C:\Users\Shubham Kumar\.config"
$pwsh_config = "C:\Users\Shubham Kumar\.config\powershell"



# -------------------------------------FUNCTIONS----------------------------------------
# function open {
#     Invoke-Item (Get-Location)
# }

# get the count of files in the directories
function count {
    (Get-ChildItem -File | Measure-Object).Count
}

# installation to cutom directory

function Install-CustomModule {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ModuleName
    )

    Install-Module -Name $ModuleName -Scope CurrentUser -Force 
    Move-Item -Path "$DEFAULT_MODULE\$ModuleName" -Destination $MODULE -Force
    
}# USE : Istall-CustomMoudle module-name

# get directroy by file name
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }


function Get-ModulesFromPath {
    param (
        [string]$Path
    )

    # Check if the path exists
    if (-Not (Test-Path $Path)) {
        Write-Host "The specified path does not exist: $Path" -ForegroundColor Red
        return
    }

    # Get all available modules and filter by the specified path
    $modules = Get-Module -ListAvailable | Where-Object { $_.ModuleBase -like "$Path*" }

    # If no modules are found, display a message
    if (-Not $modules) {
        Write-Host "No modules found in the specified path: $Path" -ForegroundColor Yellow
    } else {
        # Return the modules as a result
        $modules | Select-Object Name, Version
    }
} # use : Get-ModulesFromPath -Path "C:\Users\Shubham\Documents\WindowsPowerShell\Modules"


# ------------------------------ALIAS ------------------------------------------

# open the directories using file manager
Set-Alias -Name open -Value Invoke-Item  # pass . (for current opening current working directory)  or desired location
Set-Alias -Name vim -Value nvim  







# ------------------------------------------------------------------------------