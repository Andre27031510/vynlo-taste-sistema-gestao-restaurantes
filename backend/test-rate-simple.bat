@echo off
echo ========================================
echo TESTE DE RATE LIMITING SIMPLES
echo ========================================
echo.

echo Fazendo 10 requisicoes rapidas para testar rate limiting...
for /L %%i in (1,1,10) do (
    powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Req %%i: OK -' $response.StatusCode } catch { Write-Host 'Req %%i: Rate Limited' -ForegroundColor Yellow }"
)

pause