$ErrorActionPreference = 'Continue'

Write-Host "=== Test 1: Categories API ==="
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/api/categories' -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "Categories Status: $($response.StatusCode)"
    Write-Host "Categories Response: $($response.Content)"
} catch {
    Write-Host "Categories Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Categories Status Code: $($_.Exception.Response.StatusCode)"
    }
}

Write-Host ""
Write-Host "=== Test 2: Login API ==="
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/api/auth/login' -Method POST -ContentType 'application/json' -Body $loginBody -TimeoutSec 5 -UseBasicParsing
    Write-Host "Login Status: $($response.StatusCode)"
    Write-Host "Login Response: $($response.Content)"
} catch {
    Write-Host "Login Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Login Status Code: $($_.Exception.Response.StatusCode)"
    }
}