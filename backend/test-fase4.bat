@echo off
echo ========================================
echo FASE 4 - TESTES DE SEGURANCA E VALIDACAO
echo ========================================
echo.

echo [1/4] TESTANDO AUTENTICACAO E AUTORIZACAO
echo ==========================================

echo Testando endpoint publico (health)...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Health Check:' $response.status -ForegroundColor Green } catch { Write-Host 'Erro:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo Testando endpoint protegido sem token...
powershell -Command "try { Invoke-RestMethod -Uri 'http://localhost:8080/api/v1/products' -Method Get } catch { Write-Host 'Endpoint protegido (esperado 401/403):' $_.Exception.Response.StatusCode -ForegroundColor Yellow }"

echo.
echo Testando endpoints do actuator...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator' -Method Get; Write-Host 'Actuator endpoints disponiveis:' $response._links.Count -ForegroundColor Green } catch { Write-Host 'Erro actuator:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo [2/4] TESTANDO RATE LIMITING
echo =============================

echo Testando multiplas requisicoes rapidas...
for /L %%i in (1,1,5) do (
    powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Req %%i: OK' -ForegroundColor Green } catch { Write-Host 'Req %%i: Rate Limited' -ForegroundColor Yellow }"
)

echo.
echo [3/4] TESTANDO CORS E HEADERS DE SEGURANCA
echo ==========================================

echo Testando headers de seguranca...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get; Write-Host 'Headers de seguranca:'; $response.Headers | ForEach-Object { if($_.Key -match 'X-|Content-|Cache-') { Write-Host $_.Key ':' $_.Value -ForegroundColor Cyan } } } catch { Write-Host 'Erro headers:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo Testando CORS com origem diferente...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Options -Headers @{'Origin'='http://localhost:3000'; 'Access-Control-Request-Method'='GET'}; Write-Host 'CORS permitido para localhost:3000' -ForegroundColor Green } catch { Write-Host 'CORS bloqueado:' $_.Exception.Message -ForegroundColor Yellow }"

echo.
echo [4/4] TESTANDO METRICAS E MONITORAMENTO
echo =======================================

echo Testando metricas Prometheus...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator/prometheus' -Method Get; Write-Host 'Metricas Prometheus: Disponivel (' $response.Length ' chars)' -ForegroundColor Green } catch { Write-Host 'Erro metricas:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo Testando info da aplicacao...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator/info' -Method Get; Write-Host 'Info da aplicacao: Disponivel' -ForegroundColor Green } catch { Write-Host 'Erro info:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo Testando metricas detalhadas...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/actuator/metrics' -Method Get; Write-Host 'Metricas disponiveis:' $response.names.Count -ForegroundColor Green } catch { Write-Host 'Erro metricas detalhadas:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo FASE 4 - TESTES CONCLUIDOS
echo ========================================
pause