@echo off
echo ========================================
echo TESTE ROBUSTO SIMPLIFICADO
echo ========================================

echo Verificando aplicacao...
curl -s http://localhost:8080/api/v1/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Aplicacao nao rodando
    pause
    exit /b 1
)

echo OK: Aplicacao rodando
echo.

echo TESTE 1: Gatling Load Test
echo ==========================
cd performance-tests
mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.RobustLoadTest
cd ..

echo.
echo TESTE 2: Monitor Sistema (5 min)
echo ================================
powershell -ExecutionPolicy Bypass -File "monitoring\advanced-monitor.ps1" -Duration 300

echo.
echo TESTE 3: Metricas Finais
echo ========================
curl -s http://localhost:8080/api/v1/performance/metrics > metrics-final.json
echo Metricas salvas em: metrics-final.json

echo.
echo RELATORIOS:
echo ===========
echo Gatling: performance-tests\target\gatling\
echo Monitor: monitoring\logs\
echo Metricas: metrics-final.json

echo.
echo TESTE ROBUSTO CONCLUIDO!
pause