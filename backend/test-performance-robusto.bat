@echo off
echo ========================================
echo TESTES DE PERFORMANCE ROBUSTOS
echo ========================================

echo.
echo Verificando pre-requisitos...

curl -s http://localhost:8080/api/v1/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Aplicacao nao esta rodando
    pause
    exit /b 1
)

echo OK: Aplicacao rodando
echo.

echo FASE 1: TESTE DE CARGA ROBUSTO
echo =================================
cd performance-tests
mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.RobustLoadTest
cd ..

echo.
echo FASE 2: TESTE DE STRESS EXTREMO
echo =================================
set /p stress="Executar teste de stress (s/n): "
if /i "%stress%"=="s" (
    cd performance-tests
    mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.StressTestRobust
    cd ..
)

echo.
echo FASE 3: MONITORAMENTO
echo ====================
powershell -ExecutionPolicy Bypass -File "monitoring\advanced-monitor.ps1" -Duration 300

echo.
echo RELATORIOS GERADOS:
echo ==================
echo Gatling: performance-tests\target\gatling\
echo Monitor: monitoring\logs\

echo.
echo TESTES CONCLUIDOS!
pause