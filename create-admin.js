const admin = require('firebase-admin');
const path = require('path');

// Configuração do Firebase Admin usando arquivo de service account
const serviceAccountPath = path.join(__dirname, 'backend/src/main/resources/firebase-service-account.json');

// Verificar se arquivo existe
const fs = require('fs');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ Arquivo firebase-service-account.json não encontrado!');
  console.log('📋 Passos para configurar:');
  console.log('1. Baixe o arquivo de service account do Firebase Console');
  console.log('2. Salve como: backend/src/main/resources/firebase-service-account.json');
  console.log('3. Execute novamente este script');
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

// Inicializar Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function createAdminUser() {
  try {
    console.log('🔥 Criando usuário administrador...');
    
    // Criar usuário
    const userRecord = await admin.auth().createUser({
      email: 'admin@vynlotaste.com',
      password: 'VynloAdmin2024!',
      displayName: 'Administrador Vynlo Taste',
      emailVerified: true
    });

    console.log('✅ Usuário criado:', userRecord.uid);

    // Definir como admin
    await admin.auth().setCustomUserClaims(userRecord.uid, {
      role: 'admin',
      permissions: ['all'],
      isAdmin: true
    });

    console.log('✅ Permissões de admin definidas!');
    console.log('');
    console.log('🎯 CREDENCIAIS DE ACESSO:');
    console.log('Email: admin@vynlotaste.com');
    console.log('Senha: VynloAdmin2024!');
    console.log('');
    console.log('🚀 Agora execute o frontend:');
    console.log('cd frontend && npm run dev');
    
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      console.log('⚠️ Usuário já existe, definindo permissões...');
      
      const user = await admin.auth().getUserByEmail('admin@vynlotaste.com');
      await admin.auth().setCustomUserClaims(user.uid, {
        role: 'admin',
        permissions: ['all'],
        isAdmin: true
      });
      
      console.log('✅ Permissões atualizadas!');
    } else {
      console.error('❌ Erro:', error.message);
    }
  }
  
  process.exit(0);
}

createAdminUser();