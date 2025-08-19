@echo off
echo ========================================
echo TESTE GATLING SIMPLES
echo ========================================

cd performance-tests

echo Verificando aplicacao...
curl -s http://localhost:8080/api/v1/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Aplicacao nao rodando
    pause
    exit /b 1
)

echo OK: Aplicacao rodando
echo.

echo Executando teste simples...
mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.SimpleLoadTest

echo.
echo Teste concluido!
echo Relatorio em: target\gatling\
echo.

pause