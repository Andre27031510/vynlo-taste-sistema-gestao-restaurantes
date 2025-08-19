@echo off
echo 🚀 CRIANDO BACKEND MÍNIMO FUNCIONAL
echo.

echo 🗑️ Removendo TUDO...
rmdir /s /q src 2>nul
rmdir /s /q target 2>nul

echo.
echo 📁 Criando estrutura básica...
mkdir src\main\java\com\vynlotaste\controller
mkdir src\main\java\com\vynlotaste\service
mkdir src\main\java\com\vynlotaste\repository
mkdir src\main\java\com\vynlotaste\entity
mkdir src\main\java\com\vynlotaste\dto
mkdir src\main\java\com\vynlotaste\config

echo.
echo ✅ Estrutura criada!
pause