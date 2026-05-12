$ErrorActionPreference = 'Continue'

Write-Host "=== Test 1: Login ==="
$loginUri = 'http://localhost:8080/eventhub_war_exploded/api/auth/login'
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri $loginUri -Method POST -ContentType 'application/json' -Body $loginBody -TimeoutSec 10 -UseBasicParsing
    Write-Host "Login Status: $($response.StatusCode)"
    Write-Host "Login Response: $($response.Content)"
} catch {
    Write-Host "Login Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Login Status Code: $($_.Exception.Response.StatusCode)"
    }
}

Write-Host ""
Write-Host "=== Test 2: Register (new user) ==="
$registerUri = 'http://localhost:8080/eventhub_war_exploded/api/auth/register'
$registerBody = @{
    username = "newuser123"
    password = "password123"
    email = "newuser123@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri $registerUri -Method POST -ContentType 'application/json' -Body $registerBody -TimeoutSec 10 -UseBasicParsing
    Write-Host "Register Status: $($response.StatusCode)"
    Write-Host "Register Response: $($response.Content)"
} catch {
    Write-Host "Register Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Register Status Code: $($_.Exception.Response.StatusCode)"
    }
}