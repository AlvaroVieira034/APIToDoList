import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import MainPage from './components/MainPage';
import CadastroUsuario from './components/CadastroUsuario';
import Login from './components/Login';
import Tarefas from './components/Tarefas'; // Importe a página de tarefas
import './App.css';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MainPage />} />
        <Route path="/cadastro" element={<CadastroUsuario />} />
        <Route path="/login" element={<Login />} />
        <Route path="/tarefas" element={<Tarefas />} /> {/* Rota para a página de tarefas */}
      </Routes>
    </Router>
  );
}

export default App;