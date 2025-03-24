import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

function Login() {
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await fetch('http://localhost:9000/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, senha }),
      });

      console.log('Status da resposta:', response.status);

      if (response.ok) {
        const data = await response.json();
        console.log('Dados recebidos:', data);
        alert('Login realizado com sucesso!');
        navigate('/tarefas'); // Redireciona para a página de tarefas
      } else {
        // Tenta ler a resposta para mais detalhes
        const errorMsg = await response.text();
        console.error('Erro na requisição:', errorMsg);
        alert('Usuário/senha não encontrado');
      }
    } catch (error) {
      console.error('Erro ao fazer login:', error);
      alert('Erro ao fazer login. Tente novamente.');
    }
  };

  const handleSair = () => {
    navigate('/'); // Volta para a página principal
  };

  return (
    <div style={styles.container}>
      <h2>Login</h2>
      <form onSubmit={handleSubmit} style={styles.form}>
        <div style={styles.formGroup}>
          <label>Email:</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            style={styles.input}
          />
        </div>
        <div style={styles.formGroup}>
          <label>Senha:</label>
          <input
            type="password"
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            required
            style={styles.input}
          />
        </div>
        <div style={styles.buttonContainer}>
          <button type="submit" style={styles.button}>
            Entrar
          </button>
          <button type="button" onClick={handleSair} style={styles.button}>
            Sair
          </button>
        </div>
      </form>
    </div>
  );
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    height: '100vh',
    backgroundColor: '#f0f0f0',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
  },
  formGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '5px',
  },
  input: {
    padding: '8px',
    fontSize: '16px',
    borderRadius: '5px',
    border: '1px solid #ccc',
  },
  buttonContainer: {
    display: 'flex',
    gap: '10px',
  },
  button: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#007bff',
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
};

export default Login;
