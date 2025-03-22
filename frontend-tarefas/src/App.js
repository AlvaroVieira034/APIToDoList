import React from 'react';
import CadastroUsuario from './components/CadastroUsuario';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Gerenciador de Tarefas</h1>
        <CadastroUsuario />
      </header>
    </div>
  );
}

export default App;