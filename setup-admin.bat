@echo off
echo 🚀 CONFIGURANDO ADMIN VYNLO TASTE
echo.

echo 📦 Instalando Firebase Admin SDK...
npm install firebase-admin

echo.
echo 🔥 Criando usuário administrador...
node create-admin.js

echo.
echo 📱 Iniciando frontend...
cd frontend
npm install
npm run dev

pause