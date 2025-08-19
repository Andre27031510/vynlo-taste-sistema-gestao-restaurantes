@echo off
echo ========================================
echo TESTE DE RATE LIMITING CORRIGIDO
echo ========================================
echo.

powershell -Command "
for($i=1; $i -le 20; $i++) {
    try {
        $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get
        $status = $response.StatusCode
        $remaining = $response.Headers['X-Rate-Limit-Remaining']
        Write-Host \"Req ${i}: ${status} (Remaining: ${remaining})\"
    } catch {
        Write-Host \"Req ${i}: Rate Limited\" -ForegroundColor Yellow
    }
    Start-Sleep -Milliseconds 100
}
"

pause