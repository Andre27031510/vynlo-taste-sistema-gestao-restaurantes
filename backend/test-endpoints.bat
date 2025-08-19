@echo off
echo =============================================================================
echo                    🧪 VYNLO TASTE - TESTE DE ENDPOINTS
echo =============================================================================
echo.

echo 🔍 Verificando se aplicação está rodando...
netstat -ano | findstr :8080 >nul
if %errorlevel% neq 0 (
    echo ❌ Aplicação não está rodando na porta 8080
    echo 🚀 Iniciando aplicação...
    start /B .\apache-maven-3.9.6\bin\mvn spring-boot:run -Dspring.profiles.active=dev
    echo ⏳ Aguardando 30 segundos para inicialização...
    timeout /t 30 /nobreak >nul
)

echo.
echo 🧪 Testando Endpoints da API...
echo.

echo 📊 1. Health Check:
curl -s http://localhost:8080/api/actuator/health
echo.
echo.

echo 📊 2. Swagger UI:
echo http://localhost:8080/api/swagger-ui.html
echo.

echo 📊 3. Teste de Autenticação:
curl -s -X POST http://localhost:8080/api/v1/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"admin@vynlotaste.com\",\"password\":\"password\"}"
echo.
echo.

echo 📊 4. Teste de Produtos:
curl -s http://localhost:8080/api/v1/products
echo.
echo.

echo 📊 5. Teste de Pedidos:
curl -s http://localhost:8080/api/v1/orders
echo.
echo.

echo ✅ Testes concluídos!
pause