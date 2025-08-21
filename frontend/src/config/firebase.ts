import { initializeApp, getApps, getApp, type FirebaseApp } from 'firebase/app';
import { getAuth, type Auth } from 'firebase/auth';
import { getFirestore, type Firestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
};

let cachedApp: FirebaseApp | null = null;

export const getFirebaseApp = (): FirebaseApp | null => {
  if (cachedApp) return cachedApp;
  // Evitar inicialização durante SSR/prerender e quando não há config
  if (typeof window === 'undefined') return null;
  if (!firebaseConfig.apiKey) return null;
  cachedApp = getApps().length ? getApp() : initializeApp(firebaseConfig);
  return cachedApp;
};

let cachedAuth: Auth | null = null;
let cachedDb: Firestore | null = null;

export const auth: Auth = (() => {
  const app = getFirebaseApp();
  // Durante build/prerender, exporta stub para evitar crash; no cliente reavaliará ao importar novamente
  if (!app) return {} as Auth;
  if (!cachedAuth) cachedAuth = getAuth(app);
  return cachedAuth as Auth;
})();

export const db: Firestore = (() => {
  const app = getFirebaseApp();
  if (!app) return {} as Firestore;
  if (!cachedDb) cachedDb = getFirestore(app);
  return cachedDb as Firestore;
})();

export default getFirebaseApp;