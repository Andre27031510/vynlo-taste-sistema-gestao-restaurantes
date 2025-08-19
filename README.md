# 🚀 Vynlo Taste - Sistema Completo de Delivery Empresarial

Sistema empresarial completo para gestão de delivery e restaurantes, desenvolvido com tecnologias modernas e arquitetura escalável.

## ✨ **Funcionalidades Implementadas**

### 🔐 **Autenticação e Segurança**
- ✅ Firebase Authentication (Google, Email/Senha)
- ✅ JWT Tokens para API
- ✅ Controle de acesso baseado em roles (RBAC)
- ✅ Proteção de rotas no frontend e backend
- ✅ Criptografia de senhas com BCrypt

### 🗄️ **Banco de Dados**
- ✅ PostgreSQL com schema completo
- ✅ Migrações Flyway implementadas
- ✅ Dados iniciais (seeds) para desenvolvimento
- ✅ Índices otimizados para performance
- ✅ Triggers para auditoria automática

### 📱 **Frontend (Next.js + React)**
- ✅ Autenticação com Firebase
- ✅ Dashboard administrativo
- ✅ Componentes reutilizáveis
- ✅ Proteção de rotas
- ✅ Interface responsiva com Tailwind CSS
- ✅ Context API para gerenciamento de estado

### 🔧 **Backend (Spring Boot + Java)**
- ✅ API REST completa
- ✅ Integração Firebase Admin SDK
- ✅ Controllers para Auth, Products, Orders
- ✅ Services e Repositories implementados
- ✅ Documentação Swagger/OpenAPI
- ✅ Configurações de ambiente por perfil

### 📊 **Gestão de Produtos**
- ✅ CRUD completo de produtos
- ✅ Categorização e organização
- ✅ Controle de estoque
- ✅ Busca e filtros avançados
- ✅ Upload de imagens

### 🛒 **Sistema de Pedidos**
- ✅ Criação e gestão de pedidos
- ✅ Diferentes tipos (Delivery, Pickup, Dine-in)
- ✅ Cálculo automático de valores
- ✅ Histórico completo de pedidos

## 🛠️ **Stack Tecnológica**

### **Backend**
- **Java 17** - Linguagem principal
- **Spring Boot 3.2** - Framework web
- **Spring Security 6** - Segurança
- **Spring Data JPA** - Persistência
- **PostgreSQL 15** - Banco de dados
- **Firebase Admin SDK** - Autenticação
- **JWT** - Tokens de acesso
- **Flyway** - Migrações de banco
- **Maven** - Gerenciamento de dependências

### **Frontend**
- **Next.js 14** - Framework React
- **React 18** - Biblioteca UI
- **TypeScript** - Tipagem estática
- **Tailwind CSS** - Estilização
- **Firebase SDK** - Autenticação
- **Context API** - Gerenciamento de estado

### **Banco de Dados**
- **PostgreSQL** - Banco principal
- **Redis** - Cache (configurado)
- **Flyway** - Controle de versão do schema

## 🚀 **Como Executar o Projeto**

### **Pré-requisitos**
- Java 17+
- Node.js 18+
- PostgreSQL 14+
- Maven 3.8+
- Conta Firebase (para autenticação)

### **1. Configuração do Banco de Dados**
```sql
-- Criar banco PostgreSQL
CREATE DATABASE vynlo_taste;
CREATE USER vynlo_user WITH PASSWORD 'vynlo_pass';
GRANT ALL PRIVILEGES ON DATABASE vynlo_taste TO vynlo_user;
```

### **2. Configuração do Firebase**
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com)
2. Ative Authentication (Email/Senha e Google)
3. Baixe o arquivo de configuração
4. Configure as variáveis de ambiente

### **3. Backend (Spring Boot)**
```bash
cd backend

# Configurar variáveis de ambiente no .env
cp .env.example .env
# Editar .env com suas configurações

# Executar migrações
mvn flyway:migrate

# Iniciar aplicação
mvn spring-boot:run
```

### **4. Frontend (Next.js)**
```bash
cd frontend

# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.local.example .env.local
# Editar .env.local com suas configurações Firebase

# Iniciar aplicação
npm run dev
```

### **5. Acessar o Sistema**
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080/api
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html

## 📋 **Usuários Padrão**

### **Administrador**
- **Email**: admin@vynlotaste.com
- **Senha**: password
- **Permissões**: Acesso total ao sistema

### **Gerente**
- **Email**: gerente@vynlotaste.com
- **Senha**: password
- **Permissões**: Gestão de produtos e pedidos

### **Cliente**
- **Email**: cliente@exemplo.com
- **Senha**: password
- **Permissões**: Fazer pedidos

## 🔧 **Configurações de Ambiente**

### **Backend (.env)**
```env
# Database
DB_USER=postgres
DB_HOST=localhost
DB_NAME=vynlo_taste
DB_PASSWORD=sua_senha
DB_PORT=5432

# Firebase
FIREBASE_PROJECT_ID=seu_projeto_id
FIREBASE_PRIVATE_KEY=sua_chave_privada
FIREBASE_CLIENT_EMAIL=seu_email_cliente

# JWT
JWT_SECRET=sua_chave_secreta_jwt
JWT_EXPIRATION=86400000
```

### **Frontend (.env.local)**
```env
# Firebase
NEXT_PUBLIC_FIREBASE_API_KEY=sua_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=seu_projeto.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=seu_projeto_id

# API
NEXT_PUBLIC_API_URL=http://localhost:8080/api/v1
```

## 📚 **Documentação da API**

### **Endpoints Principais**
```
POST   /api/v1/auth/login          # Login com email/senha
POST   /api/v1/auth/firebase       # Login com Firebase
POST   /api/v1/auth/register       # Registro de usuário
GET    /api/v1/products            # Listar produtos
POST   /api/v1/products            # Criar produto
GET    /api/v1/orders              # Listar pedidos
POST   /api/v1/orders              # Criar pedido
```

### **Swagger/OpenAPI**
Acesse a documentação completa em: http://localhost:8080/api/swagger-ui.html

## 🧪 **Testes**

### **Backend**
```bash
cd backend
mvn test
```

### **Frontend**
```bash
cd frontend
npm test
```

## 📦 **Deploy**

### **Docker**
```bash
# Backend
cd backend
docker build -t vynlo-taste-backend .
docker run -p 8080:8080 vynlo-taste-backend

# Frontend
cd frontend
docker build -t vynlo-taste-frontend .
docker run -p 3000:3000 vynlo-taste-frontend
```

### **Docker Compose**
```bash
docker-compose up -d
```

## 🔄 **Próximas Implementações**

### **Alta Prioridade**
- [ ] Sistema de pagamentos (Stripe/PIX)
- [ ] Notificações WhatsApp Business
- [ ] Rastreamento de entregas em tempo real
- [ ] Relatórios financeiros avançados

### **Média Prioridade**
- [ ] App mobile (React Native)
- [ ] Integração com delivery apps
- [ ] Sistema de fidelidade
- [ ] Chat interno

### **Baixa Prioridade**
- [ ] IA para recomendações
- [ ] Analytics avançados
- [ ] Multi-tenancy
- [ ] Internacionalização

## 🤝 **Contribuição**

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 **Licença**

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 **Suporte**

- **Email**: suporte@vynlotaste.com
- **Documentação**: [Wiki do Projeto](https://github.com/vynlotaste/wiki)
- **Issues**: [GitHub Issues](https://github.com/vynlotaste/issues)

---

## 🎯 **Status do Projeto**

✅ **MVP Completo** - Sistema funcional com autenticação, produtos e pedidos  
🔄 **Em Desenvolvimento** - Integrações e funcionalidades avançadas  
📈 **Roadmap Definido** - Próximas funcionalidades planejadas  

**🚀 Sistema de Delivery Empresarial Vynlo Taste - Pronto para Produção!** 🚀