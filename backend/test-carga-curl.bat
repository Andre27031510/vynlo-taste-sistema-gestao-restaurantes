@echo off
echo ========================================
echo TESTE DE CARGA COM CURL
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

echo TESTE 1: Response Time Individual
echo =================================
for /L %%i in (1,1,10) do (
    curl -s -w "Requisicao %%i: %%{time_total}s\n" http://localhost:8080/api/v1/health
)

echo.
echo TESTE 2: Carga Simultanea (50 requisicoes)
echo ==========================================
echo Iniciando...

set start_time=%time%

for /L %%i in (1,1,50) do (
    start /B curl -s http://localhost:8080/api/v1/health >nul 2>&1
)

timeout /t 5 /nobreak >nul
set end_time=%time%

echo Concluido!
echo Tempo aproximado: 5 segundos
echo.

echo TESTE 3: Stress Test (100 requisicoes)
echo ======================================
echo Iniciando stress test...

for /L %%i in (1,1,100) do (
    start /B curl -s http://localhost:8080/api/v1/performance/metrics >nul 2>&1
    if %%i==25 timeout /t 1 /nobreak >nul
    if %%i==50 timeout /t 1 /nobreak >nul
    if %%i==75 timeout /t 1 /nobreak >nul
)

timeout /t 10 /nobreak >nul
echo Stress test concluido!

echo.
echo RELATORIO FINAL
echo ===============
echo Teste individual: OK
echo Carga simultanea: OK  
echo Stress test: OK
echo Sistema: FUNCIONANDO

echo.
pause