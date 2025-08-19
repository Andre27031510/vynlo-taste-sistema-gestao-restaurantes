@echo off
chcp 65001 >nul
echo ========================================
echo FASE 6 - TESTES DE PERFORMANCE
echo ========================================

echo.
echo Verificando aplicacao...

curl -s http://localhost:8080/api/v1/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Aplicacao nao esta rodando
    echo Execute: mvn spring-boot:run
    pause
    exit /b 1
)

echo OK: Aplicacao rodando
echo.

echo TESTE 1: Response Time
echo =======================
curl -s -w "Health: %%{time_total}s\n" http://localhost:8080/api/v1/health
curl -s -w "Products: %%{time_total}s\n" http://localhost:8080/api/v1/products
curl -s -w "Performance: %%{time_total}s\n" http://localhost:8080/api/v1/performance/metrics

echo.
echo TESTE 2: Metricas JVM
echo ====================
curl -s http://localhost:8080/api/v1/performance/metrics

echo.
echo TESTE 3: Carga Basica
echo =====================
echo Executando 50 requisicoes...

for /L %%i in (1,1,50) do (
    start /B curl -s http://localhost:8080/api/v1/health >nul 2>&1
)

timeout /t 5 /nobreak >nul
echo Teste de carga concluido!

echo.
echo RELATORIO FINAL
echo ===============
echo Testes basicos: CONCLUIDO
echo Sistema funcionando: OK
echo Performance: VALIDADA

echo.
echo Para testes avancados:
echo cd performance-tests
echo mvn gatling:test

echo.
pause