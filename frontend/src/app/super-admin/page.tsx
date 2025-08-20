'use client';

import { useState, useEffect } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { useRouter } from 'next/navigation';

export default function SuperAdminPanel() {
  const { user } = useAuth();
  const router = useRouter();
  const [clients, setClients] = useState<any[]>([]);
  const [newClient, setNewClient] = useState({
    companyName: '',
    adminEmail: '',
    adminPassword: '',
    permissions: [] as string[]
  });

  const availablePermissions = [
    'manage_products',
    'manage_orders', 
    'manage_customers',
    'view_reports',
    'manage_financial',
    'manage_delivery',
    'manage_menu',
    'manage_team'
  ];

  useEffect(() => {
    if (!user) {
      router.push('/login');
      return;
    }
    // Verificar se é super admin através de claims personalizados
    user.getIdTokenResult().then((idTokenResult) => {
      if (!idTokenResult.claims.isSuperAdmin) {
        router.push('/login');
        return;
      }
      loadClients();
    }).catch(() => {
      router.push('/login');
    });
  }, [user]);

  const loadClients = async () => {
    try {
      const response = await fetch('/api/v1/super-admin/clients');
      const data = await response.json();
      setClients(data);
    } catch (error) {
      console.error('Erro ao carregar clientes:', error);
    }
  };

  const createClient = async () => {
    try {
      const response = await fetch('/api/v1/super-admin/create-client', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newClient)
      });

      if (response.ok) {
        alert('Cliente criado com sucesso!');
        setNewClient({ companyName: '', adminEmail: '', adminPassword: '', permissions: [] });
        loadClients();
      }
    } catch (error) {
      alert('Erro ao criar cliente');
    }
  };

  const togglePermission = (permission: string) => {
    setNewClient(prev => ({
      ...prev,
      permissions: prev.permissions.includes(permission)
        ? prev.permissions.filter(p => p !== permission)
        : [...prev.permissions, permission]
    }));
  };

  if (!user) {
    return <div>Carregando...</div>;
  }

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold mb-8">👑 Painel Super Admin - Vynlo Sistemas</h1>

        <div className="bg-white p-6 rounded-lg shadow mb-8">
          <h2 className="text-xl font-semibold mb-4">🏢 Criar Novo Cliente</h2>
          
          <div className="grid grid-cols-2 gap-4 mb-4">
            <input
              type="text"
              placeholder="Nome da Empresa"
              value={newClient.companyName}
              onChange={(e) => setNewClient({...newClient, companyName: e.target.value})}
              className="border p-2 rounded"
            />
            <input
              type="email"
              placeholder="Email do Admin"
              value={newClient.adminEmail}
              onChange={(e) => setNewClient({...newClient, adminEmail: e.target.value})}
              className="border p-2 rounded"
            />
          </div>

          <input
            type="password"
            placeholder="Senha do Admin"
            value={newClient.adminPassword}
            onChange={(e) => setNewClient({...newClient, adminPassword: e.target.value})}
            className="border p-2 rounded w-full mb-4"
          />

          <div className="mb-4">
            <h3 className="font-semibold mb-2">Funcionalidades Permitidas:</h3>
            <div className="grid grid-cols-2 gap-2">
              {availablePermissions.map(permission => (
                <label key={permission} className="flex items-center">
                  <input
                    type="checkbox"
                    checked={newClient.permissions.includes(permission)}
                    onChange={() => togglePermission(permission)}
                    className="mr-2"
                  />
                  {permission.replace('_', ' ').toUpperCase()}
                </label>
              ))}
            </div>
          </div>

          <button
            onClick={createClient}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
          >
            Criar Cliente
          </button>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">📋 Clientes Cadastrados</h2>
          
          <div className="overflow-x-auto">
            <table className="w-full table-auto">
              <thead>
                <tr className="bg-gray-50">
                  <th className="p-2 text-left">Empresa</th>
                  <th className="p-2 text-left">Admin Email</th>
                  <th className="p-2 text-left">Funcionalidades</th>
                  <th className="p-2 text-left">Status</th>
                  <th className="p-2 text-left">Ações</th>
                </tr>
              </thead>
              <tbody>
                {clients.map(client => (
                  <tr key={client.id} className="border-t">
                    <td className="p-2">{client.companyName}</td>
                    <td className="p-2">{client.adminEmail}</td>
                    <td className="p-2">
                      <span className="text-sm bg-gray-100 px-2 py-1 rounded">
                        {client.permissions?.length || 0} funcionalidades
                      </span>
                    </td>
                    <td className="p-2">
                      <span className="text-green-600">✅ Ativo</span>
                    </td>
                    <td className="p-2">
                      <button className="text-blue-600 hover:underline mr-2">
                        Editar
                      </button>
                      <button className="text-red-600 hover:underline">
                        Suspender
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}