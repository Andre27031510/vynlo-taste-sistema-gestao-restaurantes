@echo off
echo ========================================
echo 🔄 VYNLO TASTE - TESTE DE ENDURANCE
echo ========================================

echo.
echo ⚠️  ATENÇÃO: Este teste roda por 24 horas!
echo    Certifique-se de que o sistema está preparado.
echo.

set /p confirm="Deseja continuar? (s/n): "
if /i "%confirm%" neq "s" (
    echo Teste cancelado.
    pause
    exit /b
)

cd performance-tests

echo.
echo 🔄 Iniciando teste de endurance...
echo    - 50 usuários constantes
echo    - Duração: 24 horas
echo    - Monitoramento de memory leaks
echo.

mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.EnduranceTestSimulation

echo.
echo 📈 Teste concluído! Verifique os relatórios.
echo.

pause