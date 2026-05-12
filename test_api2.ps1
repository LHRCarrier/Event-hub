$ErrorActionPreference = 'Continue'

Write-Host "=== Test 1: Access register.html page ==="
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/register.html' -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "Page Status: $($response.StatusCode) - OK (Static HTML works)"
} catch {
    Write-Host "Page Error: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "=== Test 2: Call register API ==="
$body = @{
    username = "testuser999"
    password = "test123456"
    email = "test999@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/api/auth/register' -Method POST -ContentType 'application/json' -Body $body -TimeoutSec 5 -UseBasicParsing
    Write-Host "API Status: $($response.StatusCode)"
    Write-Host "API Response: $($response.Content)"
} catch {
    Write-Host "API Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "API Status Code: $($_.Exception.Response.StatusCode)"
    }
}

Write-Host ""
Write-Host "=== Test 3: Access Swagger UI ==="
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/swagger-ui/index.html' -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "Swagger Status: $($response.StatusCode) - OK"
} catch {
    Write-Host "Swagger Error: $($_.Exception.Message)"
}