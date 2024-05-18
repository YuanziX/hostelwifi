# PowerShell script to log in and log out of the hostel wifi portal - works only on newer powershell (i think)

$USERNAME = ""
$PASSWORD = ""

$LOGIN_URL = "https://hfw.vitap.ac.in:8090/login.xml"
$LOGOUT_URL = "https://hfw.vitap.ac.in:8090/logout.xml"

function Login {
    $body = @{
        mode        = 191
        username    = $USERNAME
        password    = $PASSWORD
        producttype = 0
    }
    $response = Invoke-WebRequest -SkipCertificateCheck -Uri $LOGIN_URL -Method POST -Body $body -UseBasicParsing
    if ($response.Content -match "signed in as") {
        Write-Host "Logged in successfully."
    }
    elseif ($response.Content -match "maximum login limit") {
        Write-Host "Maximum login limit reached."
    }
    else {
        Write-Host "Something went wrong. Failed to log in."
    }
}

function Logout {
    $body = @{
        mode        = 193
        username    = $USERNAME
        password    = $PASSWORD
        producttype = 0
    }
    Invoke-WebRequest -SkipCertificateCheck -Uri $LOGOUT_URL -Method POST -Body $body -UseBasicParsing | Out-Null
    Write-Host "Logged out successfully."
}

function Help {
    Write-Host "Usage: $PSCommandPath [-l|-L] [-o|-O]"
    Write-Host "  -l, --login    Log in to the Sophos Client"
    Write-Host "  -o, --logout   Log out from the Sophos Client"
    Write-Host "  -h, --help     Show this help message"
}

if ($args.Count -eq 0) {
    Help
    exit
}

foreach ($arg in $args) {
    switch -regex ($arg) {
        "-l|--login" {
            Login
        }
        "-o|--logout" {
            Logout
        }
        "-h|--help" {
            Print-Usage
            exit
        }
        default {
            Write-Host "Invalid option: $arg"
            Help
            exit 1
        }
    }
}

if (-not $USERNAME -or -not $PASSWORD) {
    Write-Host "Error: Username and password must be set."
    exit 1
}
