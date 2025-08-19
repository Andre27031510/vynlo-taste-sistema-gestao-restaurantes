@echo off
echo ========================================
echo TESTE DETALHADO DE HEADERS DE SEGURANCA
echo ========================================
echo.

echo Testando headers de seguranca detalhados...
powershell -Command "$response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Status:' $response.StatusCode; Write-Host '--- HEADERS DE SEGURANCA ---'; $response.Headers.GetEnumerator() | ForEach-Object { Write-Host $_.Key ':' ($_.Value -join ', ') }"

echo.
echo Testando CORS com diferentes origens...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Options -Headers @{'Origin'='http://malicious-site.com'; 'Access-Control-Request-Method'='GET'}; Write-Host 'CORS para site malicioso:' $response.StatusCode } catch { Write-Host 'CORS bloqueado para site malicioso (correto)' -ForegroundColor Green }"

echo.
echo Testando Content-Type protection...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Content-Type:' $response.Headers['Content-Type'] } catch { Write-Host 'Erro Content-Type:' $_.Exception.Message }"

pause