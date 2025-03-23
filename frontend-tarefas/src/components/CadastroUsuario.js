import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

function CadastroUsuario() {
  const [usuarios, setUsuarios] = useState([]);
  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [usuarioEditando, setUsuarioEditando] = useState(null); // Armazena o usuário em edição
  const navigate = useNavigate();

  // Função para buscar usuários
  const buscarUsuarios = async () => {
    try {
      console.log('Buscando usuários...');
      const response = await fetch('http://localhost:9000/usuarios');
      if (!response.ok) {
        throw new Error('Erro ao buscar usuários');
      }
      const data = await response.json();
      console.log('Usuários encontrados:', data);
      setUsuarios(data);
    } catch (error) {
      console.error('Erro ao buscar usuários:', error);
    }
  };

  // Busca os usuários ao carregar a página
  useEffect(() => {
    console.log('Carregando página...');
    buscarUsuarios();
  }, []);

  const handleIncluirUsuario = async () => {
    if (nome.trim() === '' || email.trim() === '' || senha.trim() === '') {
      alert('Preencha todos os campos.');
      return;
    }

    try {
      console.log('Incluindo usuário...');
      const response = await fetch('http://localhost:9000/cadastro', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          nome,
          email,
          senha,
        }),
      });

      if (response.ok) {
        console.log('Usuário incluído com sucesso!');
        await buscarUsuarios(); // Atualiza a lista de usuários
        setNome(''); // Limpa os campos
        setEmail('');
        setSenha('');
        alert('Usuário cadastrado com sucesso!');
      } else {
        alert('Erro ao cadastrar usuário.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleAlterarUsuario = async (id) => {
    const usuario = usuarios.find((u) => u.id === id);
    if (usuario) {
      console.log('Editando usuário:', usuario);
      setNome(usuario.nome);
      setEmail(usuario.email);
      setSenha(usuario.senha);
      setUsuarioEditando(usuario); // Define o usuário em edição
    }
  };

  const handleSalvarAlteracao = async () => {
    if (!usuarioEditando) return;

    try {
      console.log('Salvando alterações do usuário...');
      const response = await fetch(`http://localhost:9000/usuarios/${usuarioEditando.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          nome,
          email,
          senha,
        }),
      });

      if (response.ok) {
        console.log('Usuário alterado com sucesso!');
        await buscarUsuarios(); // Atualiza a lista de usuários
        setNome(''); // Limpa os campos
        setEmail('');
        setSenha('');
        setUsuarioEditando(null); // Limpa o usuário em edição
        alert('Usuário alterado com sucesso!');
      } else {
        alert('Erro ao alterar usuário.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleExcluirUsuario = async (id) => {
    try {
      console.log('Excluindo usuário...');
      const response = await fetch(`http://localhost:9000/usuarios/${id}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        console.log('Usuário excluído com sucesso!');
        await buscarUsuarios(); // Atualiza a lista de usuários
        alert('Usuário excluído com sucesso!');
      } else {
        alert('Erro ao excluir usuário.');
      }
    } catch (error) {
      console.error('Erro:', error);
    }
  };

  const handleSair = () => {
    navigate('/'); // Volta para a página principal
  };

  return (
    <div style={styles.container}>
      <h2>Cadastro de Usuários</h2>
      <div style={styles.form}>
        <input
          type="text"
          value={nome}
          onChange={(e) => setNome(e.target.value)}
          placeholder="Nome"
          style={styles.input}
        />
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="E-mail"
          style={styles.input}
        />
        <input
          type="password"
          value={senha}
          onChange={(e) => setSenha(e.target.value)}
          placeholder="Senha"
          style={styles.input}
        />
        {usuarioEditando ? (
          <button onClick={handleSalvarAlteracao} style={styles.buttonAlterar}>
            Salvar Alteração
          </button>
        ) : (
          <button onClick={handleIncluirUsuario} style={styles.buttonIncluir}>
            Incluir Usuário
          </button>
        )}
      </div>
      <ul style={styles.lista}>
        {usuarios.map((usuario) => (
          <li key={usuario.id} style={styles.item}>
            <span>{usuario.nome} - {usuario.email}</span>
            <div style={styles.botoes}>
              <button
                onClick={() => handleAlterarUsuario(usuario.id)}
                style={styles.buttonAlterar}
              >
                Alterar
              </button>
              <button
                onClick={() => handleExcluirUsuario(usuario.id)}
                style={styles.buttonExcluir}
              >
                Excluir
              </button>
            </div>
          </li>
        ))}
      </ul>
      <button onClick={handleSair} style={styles.buttonSair}>
        Sair
      </button>
    </div>
  );
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '20px',
    backgroundColor: '#f0f0f0',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginBottom: '20px',
    width: '100%',
    maxWidth: '400px',
  },
  input: {
    padding: '8px',
    fontSize: '16px',
    borderRadius: '5px',
    border: '1px solid #ccc',
  },
  buttonIncluir: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#007bff',
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  buttonAlterar: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#28a745', // Verde
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  buttonExcluir: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#dc3545', // Vermelho
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  lista: {
    listStyle: 'none',
    padding: '0',
    width: '100%',
    maxWidth: '600px',
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '10px',
    borderBottom: '1px solid #ccc',
    backgroundColor: '#fff',
    borderRadius: '5px',
    marginBottom: '10px',
  },
  botoes: {
    display: 'flex',
    gap: '10px',
  },
  buttonSair: {
    padding: '10px 20px',
    fontSize: '16px',
    backgroundColor: '#6c757d', // Cinza
    color: '#fff',
    border: 'none',
    borderRadius: '5px',
    cursor: 'pointer',
    marginTop: '20px',
  },
};

export default CadastroUsuario;