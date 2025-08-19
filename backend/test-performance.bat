@echo off
echo ========================================
echo 🚀 VYNLO TASTE - TESTES DE PERFORMANCE
echo ========================================

echo.
echo 📊 Iniciando testes de carga e performance...
echo.

cd performance-tests

echo ✅ 1. TESTE DE CARGA (Load Test)
echo    - 100 usuários simultâneos
echo    - Duração: 2 minutos
echo.
mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.LoadTestSimulation

echo.
echo ⚡ 2. TESTE DE STRESS (Stress Test)
echo    - Até 1000 usuários
echo    - Duração: 5 minutos
echo.
mvn gatling:test -Dgatling.simulationClass=com.vynlotaste.performance.StressTestSimulation

echo.
echo 📈 Relatórios gerados em: target/gatling/
echo.

pause