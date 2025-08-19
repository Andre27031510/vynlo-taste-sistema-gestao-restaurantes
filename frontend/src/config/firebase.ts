// Import the functions you need from the SDKs you need
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyApXH8Qx1n6B82sZyAtwJ6NNxJfQlEz36Q",
  authDomain: "vynlo-sistema.firebaseapp.com",
  projectId: "vynlo-sistema",
  storageBucket: "vynlo-sistema.firebasestorage.app",
  messagingSenderId: "348634037274",
  appId: "1:348634037274:web:169fa8a9c3d85850cda5a3"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export default app;