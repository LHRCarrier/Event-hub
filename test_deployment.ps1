$ErrorActionPreference = 'Continue'

Write-Host "=== 测试 1: 访问注册页面 ==="
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/register.jsp' -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "✓ 注册页面访问成功 (状态: $($response.StatusCode))"
} catch {
    Write-Host "✗ 注册页面访问失败: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "=== 测试 2: 调用注册接口 (创建新用户) ==="
$registerBody = @{
    username = "testuser_$(Get-Date -Format 'HHmmss')"
    password = "test123456"
    email = "testuser_$(Get-Date -Format 'HHmmss')@example.com"
} | ConvertTo-Json

Write-Host "请求数据: $registerBody"

try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/api/auth/register' -Method POST -ContentType 'application/json' -Body $registerBody -TimeoutSec 10 -UseBasicParsing
    Write-Host "✓ 注册成功 (状态: $($response.StatusCode))"
    Write-Host "响应: $($response.Content)"
    $registerResult = $response.Content | ConvertFrom-Json
    $registeredUsername = $registerBody.username
} catch {
    Write-Host "✗ 注册失败: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $responseStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $reader.BaseStream.Position = 0
        $errorContent = $reader.ReadToEnd()
        Write-Host "错误响应: $errorContent"
    }
}

Write-Host ""
Write-Host "=== 测试 3: 调用登录接口 (使用默认管理员账号) ==="
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/eventhub_war_exploded/api/auth/login' -Method POST -ContentType 'application/json' -Body $loginBody -TimeoutSec 10 -UseBasicParsing
    Write-Host "✓ 登录成功 (状态: $($response.StatusCode))"
    Write-Host "响应: $($response.Content)"
} catch {
    Write-Host "✗ 登录失败: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $responseStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $reader.BaseStream.Position = 0
        $errorContent = $reader.ReadToEnd()
        Write-Host "错误响应: $errorContent"
    }
}