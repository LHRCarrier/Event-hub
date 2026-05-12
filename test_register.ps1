$ErrorActionPreference = 'Continue'
$uri = 'http://localhost:8080/eventhub_war_exploded/api/auth/register'
$body = @{
    username = "testuser999"
    password = "test123456"
    email = "test999@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri $uri -Method POST -ContentType 'application/json' -Body $body -TimeoutSec 10 -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)"
    }
}