@echo off
echo 🔧 COMPILAÇÃO SIMPLES
echo.

echo 📦 Tentando compilar com configurações básicas...
.\apache-maven-3.9.6\bin\mvn.cmd -Dmaven.compiler.source=17 -Dmaven.compiler.target=17 clean compile -DskipTests -X

echo.
echo ✅ Compilação finalizada!
pause