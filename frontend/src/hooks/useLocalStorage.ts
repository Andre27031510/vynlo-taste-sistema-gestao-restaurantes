import { useState, useEffect, useCallback } from 'react'

interface UseLocalStorageOptions<T> {
  defaultValue: T
  serialize?: (value: T) => string
  deserialize?: (value: string) => T
  expiration?: number // em milissegundos
}

export function useLocalStorage<T>(
  key: string,
  options: UseLocalStorageOptions<T>
) {
  const {
    defaultValue,
    serialize = JSON.stringify,
    deserialize = JSON.parse,
    expiration
  } = options

  // Função para obter valor do localStorage com verificação de expiração
  const getStoredValue = useCallback((): T => {
    try {
      const item = window.localStorage.getItem(key)
      if (item === null) return defaultValue

      const parsed = deserialize(item)
      
      // Verificar se há timestamp de expiração
      if (expiration && parsed.timestamp) {
        const now = Date.now()
        if (now - parsed.timestamp > expiration) {
          // Dados expirados, remover e retornar valor padrão
          window.localStorage.removeItem(key)
          return defaultValue
        }
        // Retornar apenas os dados, sem o timestamp
        return parsed.data
      }
      
      return parsed
    } catch (error) {
      console.warn(`Erro ao ler localStorage key "${key}":`, error)
      return defaultValue
    }
  }, [key, defaultValue, deserialize, expiration])

  // Função para definir valor no localStorage com timestamp
  const setStoredValue = useCallback((value: T) => {
    try {
      let valueToStore = value
      
      // Adicionar timestamp se houver expiração
      if (expiration) {
        valueToStore = {
          data: value,
          timestamp: Date.now()
        } as any
      }
      
      window.localStorage.setItem(key, serialize(valueToStore))
    } catch (error) {
      console.warn(`Erro ao definir localStorage key "${key}":`, error)
    }
  }, [key, serialize, expiration])

  // Estado local
  const [storedValue, setStoredValue] = useState<T>(getStoredValue)

  // Função para atualizar valor
  const setValue = useCallback((value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value
      setStoredValue(valueToStore)
      setStoredValue(valueToStore)
    } catch (error) {
      console.warn(`Erro ao definir valor para localStorage key "${key}":`, error)
    }
  }, [storedValue, setStoredValue])

  // Função para remover valor
  const removeValue = useCallback(() => {
    try {
      window.localStorage.removeItem(key)
      setStoredValue(defaultValue)
    } catch (error) {
      console.warn(`Erro ao remover localStorage key "${key}":`, error)
    }
  }, [key, defaultValue])

  // Função para limpar todos os dados expirados
  const clearExpired = useCallback(() => {
    if (!expiration) return
    
    try {
      const keys = Object.keys(window.localStorage)
      keys.forEach(storageKey => {
        try {
          const item = window.localStorage.getItem(storageKey)
          if (item) {
            const parsed = deserialize(item)
            if (parsed.timestamp && Date.now() - parsed.timestamp > expiration) {
              window.localStorage.removeItem(storageKey)
            }
          }
        } catch (error) {
          // Ignorar erros de parsing
        }
      })
    } catch (error) {
      console.warn('Erro ao limpar dados expirados:', error)
    }
  }, [expiration, deserialize])

  // Efeito para sincronizar com mudanças no localStorage
  useEffect(() => {
    const handleStorageChange = (e: StorageEvent) => {
      if (e.key === key && e.newValue !== null) {
        try {
          const newValue = deserialize(e.newValue)
          if (expiration && newValue.timestamp) {
            if (Date.now() - newValue.timestamp <= expiration) {
              setStoredValue(newValue.data)
            }
          } else {
            setStoredValue(newValue)
          }
        } catch (error) {
          console.warn(`Erro ao processar mudança no localStorage key "${key}":`, error)
        }
      }
    }

    window.addEventListener('storage', handleStorageChange)
    return () => window.removeEventListener('storage', handleStorageChange)
  }, [key, deserialize, expiration])

  // Limpar dados expirados periodicamente
  useEffect(() => {
    if (!expiration) return
    
    const interval = setInterval(clearExpired, 60000) // Verificar a cada minuto
    return () => clearInterval(interval)
  }, [clearExpired, expiration])

  return {
    value: storedValue,
    setValue,
    removeValue,
    clearExpired
  }
}

// Hook especializado para cache de dados da API
export function useApiCache<T>(
  key: string,
  defaultValue: T,
  expirationMinutes: number = 5
) {
  return useLocalStorage(key, {
    defaultValue,
    expiration: expirationMinutes * 60 * 1000
  })
}

// Hook para cache de formulários
export function useFormCache<T>(
  key: string,
  defaultValue: T,
  expirationMinutes: number = 30
) {
  return useLocalStorage(key, {
    defaultValue,
    expiration: expirationMinutes * 60 * 1000
  })
}

// Hook para cache de preferências do usuário
export function useUserPreferences<T>(
  key: string,
  defaultValue: T
) {
  return useLocalStorage(key, {
    defaultValue,
    expiration: 24 * 60 * 60 * 1000 // 24 horas
  })
}
